#!/usr/bin/env python3
"""
EVE-NG simulation campaign runner for the SDN lab.
Starts all nodes, waits for vEOS boot + OSPF convergence, then runs
cross-LAN pings from every VPCS node and reports pass/fail results.
"""

import os
import sys
import time
import socket
import requests
from pathlib import Path
from urllib.parse import quote
from dotenv import load_dotenv

load_dotenv(Path(__file__).parent / ".env")

EVE_URL    = os.getenv("EVE_URL",    "http://192.168.1.113")
EVE_HOST   = EVE_URL.split("//")[1]
USERNAME   = os.getenv("USERNAME",   "admin")
PASSWORD   = os.getenv("PASSWORD",   "eve")
LAB_NAME   = os.getenv("LAB_NAME",   "Test1")
LAB_FOLDER = os.getenv("LAB_FOLDER", "/")

# Topology data (edit topology.py to change node names, IPs, or test pairs)
from topology import VPCS_IPS, TEST_PAIRS

VEOS_BOOT_TIMEOUT = 360   # seconds to wait for vEOS to reach "running"
OSPF_CONV_WAIT    = 60    # extra seconds after routers are up for OSPF to converge
PING_COUNT        = 3     # pings per test

# ----- Helpers

def lab_url_path(name, folder):
    folder = folder.strip("/")
    if folder:
        return quote(f"{folder}/{name}.unl", safe="")
    return f"{name}.unl"

def check(r, action):
    if r.status_code not in (200, 201):
        print(f"[ERROR] {action} → HTTP {r.status_code}: {r.text}")
        sys.exit(1)
    data = r.json()
    if data.get("code") not in (200, 201):
        print(f"[ERROR] {action} → {data.get('message', data)}")
        sys.exit(1)
    return data

def wait_all_running(session, base, node_ids, timeout, label="nodes"):
    """Poll until all node IDs have status==2 (running) or timeout."""
    pending = set(node_ids)
    deadline = time.time() + timeout
    while pending and time.time() < deadline:
        for nid in list(pending):
            r = session.get(f"{base}/nodes/{nid}")
            if r.status_code == 200:
                status = r.json().get("data", {}).get("status", 0)
                if status in (2, "2"):
                    pending.discard(nid)
                    print(f"  [UP] node id={nid}")
        if pending:
            time.sleep(10)
    if pending:
        print(f"[WARN] Timed out waiting for {label}: ids={pending}")
    return not pending

# ----- VPCS console

class VPCSConsole:
    PROMPT = b"VPCS> "

    def __init__(self, host, port, timeout=10):
        self.s = socket.socket()
        self.s.connect((host, port))
        self.s.settimeout(timeout)
        self._read_until(self.PROMPT, timeout=30)

    def _read_until(self, target, timeout=30):
        buf = b""
        deadline = time.time() + timeout
        while target not in buf and time.time() < deadline:
            try:
                chunk = self.s.recv(4096)
                if not chunk:
                    break
                buf += self._strip_iac(chunk)
            except socket.timeout:
                break
        return buf

    @staticmethod
    def _strip_iac(data):
        out, i = b"", 0
        while i < len(data):
            if data[i:i+1] == b"\xff":
                cmd = data[i+1:i+2]
                if cmd in (b"\xfb", b"\xfc", b"\xfd", b"\xfe"):
                    i += 3
                elif cmd == b"\xff":
                    out += b"\xff"; i += 2
                else:
                    i += 2
            else:
                out += data[i:i+1]; i += 1
        return out

    def run(self, cmd, timeout=15):
        self.s.sendall(cmd.encode() + b"\n")
        return self._read_until(self.PROMPT, timeout=timeout).decode(errors="replace")

    def close(self):
        try:
            self.s.close()
        except Exception:
            pass

def ping_test(host, port, target_ip, count=3):
    try:
        console = VPCSConsole(host, port, timeout=10)
        output = console.run(f"ping {target_ip} {count}", timeout=count * 3 + 8)
        console.close()
        ok = "bytes from" in output
        return ok, output.strip()
    except Exception as e:
        return False, str(e)

# ----- Main

def main():
    session = requests.Session()
    session.headers.update({"Content-Type": "application/json"})

    r = session.post(f"{EVE_URL}/api/auth/login",
                     json={"username": USERNAME, "password": PASSWORD, "html5": "-1"})
    check(r, "login")
    print("[OK] Authenticated")

    lab_path = lab_url_path(LAB_NAME, LAB_FOLDER)
    base = f"{EVE_URL}/api/labs/{lab_path}"

    # Open the lab in the current session (required before node operations)
    check(session.get(base), "open lab")
    print(f"[OK] Lab '{LAB_NAME}' opened")

    # Collect node info before starting
    data = check(session.get(f"{base}/nodes"), "get nodes")
    nodes_raw = data["data"]

    router_ids = []
    vpcs_info  = {}  # name → {id, port}

    for node_id, info in nodes_raw.items():
        name  = info["name"]
        ntype = info.get("type", "")
        if ntype == "qemu":
            router_ids.append(int(node_id))
        elif ntype == "vpcs":
            vpcs_info[name] = {"id": int(node_id), "port": info.get("console")}

    print(f"[OK] Found {len(router_ids)} routers, {len(vpcs_info)} VPCS nodes")

    # Start all nodes
    r = session.get(f"{base}/nodes/start")
    if r.status_code == 200 and r.json().get("code") in (200, 201):
        print("[OK] All nodes started")
    else:
        print(f"[WARN] nodes/start → HTTP {r.status_code} / {r.text[:80]}")

    # Re-query to pick up assigned console ports
    time.sleep(3)
    data = check(session.get(f"{base}/nodes"), "get nodes (post-start)")
    for node_id, info in data["data"].items():
        name = info["name"]
        if name in vpcs_info:
            vpcs_info[name]["port"] = info.get("console")

    # Wait for vEOS routers to boot
    print(f"\n[WAIT] Waiting for vEOS routers (timeout {VEOS_BOOT_TIMEOUT}s)...")
    wait_all_running(session, base, router_ids, VEOS_BOOT_TIMEOUT, label="routers")

    # Extra wait for OSPF to converge
    print(f"[WAIT] Waiting {OSPF_CONV_WAIT}s for OSPF convergence...")
    time.sleep(OSPF_CONV_WAIT)

    # ----- Simulation campaigns
    print("\n[TEST] Running simulation campaigns...\n")
    results = []

    for src_name, dst_name in TEST_PAIRS:
        if src_name not in vpcs_info:
            print(f"  [SKIP] {src_name} not in lab")
            continue
        port = vpcs_info[src_name]["port"]
        if not port:
            print(f"  [SKIP] {src_name} has no console port")
            continue

        dst_ip = VPCS_IPS[dst_name]
        ok, output = ping_test(EVE_HOST, port, dst_ip, count=PING_COUNT)
        tag = "PASS" if ok else "FAIL"
        results.append((src_name, dst_name, dst_ip, tag, output))
        indicator = "✓" if ok else "✗"
        print(f"  [{tag}] {indicator} {src_name:10s} → {dst_name:10s} ({dst_ip})")
        if not ok:
            first_line = output.split("\n")[0][:100]
            print(f"         {first_line}")

    # ----- Summary
    passed = sum(1 for *_, s, _ in results if s == "PASS")
    total  = len(results)
    print(f"\n{'=' * 52}")
    print(f"  SIMULATION RESULTS: {passed}/{total} tests passed")
    print(f"{'=' * 52}")
    for src, dst, ip, status, _ in results:
        mark = "✓" if status == "PASS" else "✗"
        print(f"  {mark} {src:10s} → {dst:10s}  ({ip})")
    print()

    if passed < total:
        sys.exit(1)

if __name__ == "__main__":
    main()
