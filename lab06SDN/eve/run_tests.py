#!/usr/bin/env python3

import os
import sys
import time
import socket
import requests
from pathlib import Path
from urllib.parse import quote, urlparse
from dotenv import load_dotenv
from topology import VPCS_IP_CONFIGS, VPCS_IPS, SAME_LAN_PAIRS, TEST_PAIRS

load_dotenv(Path(__file__).parent / ".env")

EVE_URL    = os.getenv("EVE_URL",    "http://192.168.1.113")
EVE_HOST   = urlparse(EVE_URL).hostname
USERNAME   = os.getenv("USERNAME",   "admin")
PASSWORD   = os.getenv("PASSWORD",   "eve")
LAB_NAME   = os.getenv("LAB_NAME",   "Test1")
LAB_FOLDER = os.getenv("LAB_FOLDER", "/")

VEOS_BOOT_TIMEOUT = 900  # seconds to wait for all nodes to reach status=2

# --- telnet helpers ---

IAC  = 255
WILL = 251
WONT = 252
DO   = 253
DONT = 254

def _negotiate(sock, data):
    out = bytearray()
    i = 0
    while i < len(data):
        b = data[i]
        if b == IAC and i + 2 < len(data):
            cmd, opt = data[i+1], data[i+2]
            if cmd == WILL:
                sock.send(bytes([IAC, DONT, opt]))
            elif cmd == DO:
                sock.send(bytes([IAC, WONT, opt]))
            i += 3
        else:
            out.append(b)
            i += 1
    return bytes(out)

def _read_until(sock, prompt, timeout=15):
    buf = b""
    deadline = time.time() + timeout
    while time.time() < deadline:
        sock.settimeout(max(0.1, deadline - time.time()))
        try:
            chunk = sock.recv(4096)
        except socket.timeout:
            break
        if not chunk:
            break
        buf += _negotiate(sock, chunk)
        if prompt in buf:
            break
    return buf

def vpcs_run(port, commands, timeout=15):
    PROMPT = b"VPCS> "
    sock = socket.create_connection((EVE_HOST, port), timeout=timeout)
    _read_until(sock, PROMPT, timeout)
    # flush any stale buffered output before issuing commands
    sock.sendall(b"\n")
    _read_until(sock, PROMPT, timeout)
    results = []
    for cmd in commands:
        sock.sendall(cmd.encode() + b"\n")
        results.append(_read_until(sock, PROMPT, timeout).decode(errors="replace"))
    sock.close()
    return results

# --- EVE-NG helpers ---

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

def telnet_port(node_info):
    return urlparse(node_info.get("url", "")).port

def main():
    session = requests.Session()
    session.headers.update({"Content-Type": "application/json"})

    # Authenticate
    r = session.post(f"{EVE_URL}/api/auth/login",
                     json={"username": USERNAME, "password": PASSWORD, "html5": "-1"})
    check(r, "login")
    print("[OK] Authenticated")

    # Open lab
    lab_path = lab_url_path(LAB_NAME, LAB_FOLDER)
    base = f"{EVE_URL}/api/labs/{lab_path}"
    check(session.get(base), "open lab")
    print(f"[OK] Lab '{LAB_NAME}' opened")

    # Start all nodes
    try:
        r = session.get(f"{base}/nodes/start", timeout=10)
        if r.status_code == 200 and r.json().get("code") in (200, 201):
            print("[OK] All nodes started")
        else:
            print(f"[WARN] nodes/start → HTTP {r.status_code} / {r.text[:80]}")
    except requests.exceptions.Timeout:
        print("[OK] nodes/start sent (response timed out, nodes booting)")

    # Wait for all nodes to reach status=2
    print(f"\n[WAIT] Waiting for all nodes (timeout {VEOS_BOOT_TIMEOUT}s)...")
    data = check(session.get(f"{base}/nodes"), "get nodes")
    node_ids = list(data["data"].keys())

    pending  = set(node_ids)
    deadline = time.time() + VEOS_BOOT_TIMEOUT
    while pending and time.time() < deadline:
        statuses = {}
        for nid in list(pending):
            r = session.get(f"{base}/nodes/{nid}")
            if r.status_code == 200:
                info   = r.json().get("data", {})
                status = info.get("status", 0)
                name   = info.get("name", nid)
                statuses[name] = status
                if status in (2, "2"):
                    pending.discard(nid)
                    print(f"  [UP] {name} (id={nid})")
        if pending:
            summary = ", ".join(f"{n}={s}" for n, s in sorted(statuses.items()))
            elapsed = int(VEOS_BOOT_TIMEOUT - (deadline - time.time()))
            print(f"  [{elapsed:3d}s] still pending: {summary}")
            time.sleep(10)

    if pending:
        print(f"[WARN] Still not running after timeout: ids={pending}")
    else:
        print("[OK] All nodes are running")

    # Build name -> node info map (refresh to get current telnet ports)
    data = check(session.get(f"{base}/nodes"), "get nodes")
    nodes = {info["name"]: info for info in data["data"].values()}

    # Configure all VPCS nodes
    print("\n[CONFIG] Configuring VPCS nodes...")
    for name in VPCS_IP_CONFIGS:
        info = nodes.get(name)
        if not info:
            print(f"  [WARN] {name} not found in lab")
            continue
        port = telnet_port(info)
        if not port:
            print(f"  [WARN] {name} has no telnet port")
            continue
        ip_cidr, gw = VPCS_IP_CONFIGS[name]
        try:
            outs = vpcs_run(port, [f"ip {ip_cidr} {gw}"])
            ok = "VPCS :" in outs[0]
            print(f"  {'[OK]' if ok else '[FAIL]'} {name}: {ip_cidr} gw {gw}")
            if not ok:
                print(f"    → {outs[0].strip()}")
        except Exception as e:
            print(f"  [ERROR] {name}: {e}")

    # Run same-LAN pairs first (no routing needed, must pass)
    print("\n[TEST] Same-LAN pings...")
    passed_count = 0
    results = []
    for src, dst in SAME_LAN_PAIRS:
        src_info = nodes.get(src)
        if not src_info:
            results.append((src, dst, False, "node not found"))
            continue
        port = telnet_port(src_info)
        target = VPCS_IPS[dst]
        try:
            outs = vpcs_run(port, [f"ping {target}"])
            ok = "84 bytes" in outs[0]
            results.append((src, dst, ok, ""))
            if ok:
                passed_count += 1
        except Exception as e:
            results.append((src, dst, False, str(e)))

    for src, dst, ok, err in results:
        label = "[PASS]" if ok else "[FAIL]"
        detail = f" ({err})" if err else ""
        print(f"  {label} {src} → {dst}{detail}")

    print(f"\n{passed_count}/{len(SAME_LAN_PAIRS)} same-LAN tests passed")

    # Stop all nodes
    try:
        session.get(f"{base}/nodes/stop", timeout=10)
        print("\n[OK] All nodes stopped")
    except requests.exceptions.Timeout:
        print("\n[OK] nodes/stop sent")

    sys.exit(0)

if __name__ == "__main__":
    main()
