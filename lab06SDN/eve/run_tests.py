#!/usr/bin/env python3

import os
import sys
import time
import socket
import threading
import ipaddress
import paramiko
import requests
from pathlib import Path
from urllib.parse import quote, urlparse
from dotenv import load_dotenv
from topology import VPCS_IP_CONFIGS, VPCS_IPS, SAME_LAN_PAIRS, TEST_PAIRS, ROUTER_IFACE_CONFIGS

load_dotenv(Path(__file__).parent / ".env")

EVE_URL    = os.getenv("EVE_URL",    "http://192.168.1.113")
EVE_HOST   = urlparse(EVE_URL).hostname
USERNAME   = os.getenv("USERNAME",   "admin")
PASSWORD   = os.getenv("PASSWORD",   "eve")
SSH_USER   = os.getenv("SSH_USER",   "root")
SSH_PASS   = os.getenv("SSH_PASS",   "eve")
LAB_NAME   = os.getenv("LAB_NAME",   "Test1")
LAB_FOLDER = os.getenv("LAB_FOLDER", "/")

VEOS_BOOT_TIMEOUT  = 900   # seconds to wait for EVE-NG status=2
VEOS_LOGIN_TIMEOUT = 7200  # seconds to wait for vEOS login prompt (TCG is slow; wfw runs for 3600s starting ~400s in)

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

def _read_until_any(sock, prompts, timeout=15):
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
        if any(p in buf for p in prompts):
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

def boot_and_configure_veos(port, router_name):
    """Wait for vEOS login prompt, log in as admin, and apply interface+OSPF config via CLI."""
    iface_configs = ROUTER_IFACE_CONFIGS[router_name]

    config_cmds = ["ip routing"]
    for iface, ip_cidr in iface_configs:
        config_cmds += [f"interface {iface}", f"   ip address {ip_cidr}", "   no shutdown"]
    config_cmds.append("router ospf 1")
    for _, ip_cidr in iface_configs:
        net = str(ipaddress.ip_interface(ip_cidr).network)
        config_cmds.append(f"   network {net} area 0.0.0.0")

    print(f"    [{router_name}] waiting for login prompt (up to {VEOS_LOGIN_TIMEOUT}s)...", flush=True)
    start = time.time()
    deadline = start + VEOS_LOGIN_TIMEOUT
    _line_buf = [""]

    try:
        sock = socket.create_connection((EVE_HOST, port), timeout=30)
    except Exception as e:
        print(f"    [{router_name}] connection failed: {e}", flush=True)
        return False

    sock.sendall(b"\n")
    buf = b""

    while time.time() < deadline:
        sock.settimeout(30)
        try:
            chunk = sock.recv(4096)
        except socket.timeout:
            elapsed = int(time.time() - start)
            print(f"    [{router_name}] still booting... ({elapsed}s)", flush=True)
            sock.sendall(b"\n")
            continue
        if not chunk:
            break
        negotiated = _negotiate(sock, chunk)
        buf += negotiated
        for char in negotiated.decode(errors="replace"):
            if char == "\n":
                if _line_buf[0].strip():
                    print(f"    [{router_name}] | {_line_buf[0]}", flush=True)
                _line_buf[0] = ""
            elif char != "\r":
                _line_buf[0] += char
        if b"login:" in buf:
            break
    else:
        sock.close()
        print(f"    [{router_name}] login prompt not reached within {VEOS_LOGIN_TIMEOUT}s", flush=True)
        return False

    if b"login:" not in buf:
        sock.close()
        print(f"    [{router_name}] login prompt not reached (EOF)", flush=True)
        return False

    elapsed = int(time.time() - start)
    print(f"    [{router_name}] reached login: ({elapsed}s), configuring...", flush=True)
    time.sleep(1)
    sock.sendall(b"admin\r\n")

    buf = _read_until_any(sock, [b"Password:", b">", b"#"], timeout=30)
    if b"Password:" in buf:
        sock.sendall(b"\r\n")
        buf = _read_until_any(sock, [b">", b"#"], timeout=30)
    if not (b">" in buf or b"#" in buf):
        sock.close()
        print(f"    [{router_name}] no shell prompt after login", flush=True)
        return False

    if b">" in buf and b"#" not in buf:
        sock.sendall(b"enable\r\n")
        buf = _read_until(sock, b"#", timeout=30)
        if b"#" not in buf:
            sock.close()
            print(f"    [{router_name}] enable failed", flush=True)
            return False

    sock.sendall(b"configure terminal\r\n")
    buf = _read_until(sock, b"(config)", timeout=30)
    if b"(config)" not in buf:
        sock.close()
        print(f"    [{router_name}] configure terminal failed", flush=True)
        return False

    for cmd in config_cmds:
        sock.sendall(cmd.encode() + b"\r\n")
        time.sleep(1.0)

    sock.sendall(b"end\r\n")
    _read_until(sock, b"#", timeout=30)
    sock.sendall(b"write memory\r\n")
    _read_until(sock, b"#", timeout=30)

    # Verify interfaces are up
    sock.sendall(b"show ip interface brief\r\n")
    ifbuf = _read_until(sock, b"#", timeout=30)
    for line in ifbuf.decode(errors="replace").splitlines():
        if line.strip():
            print(f"    [{router_name}] | {line}", flush=True)

    sock.close()
    elapsed = int(time.time() - start)
    print(f"    [{router_name}] configured and saved ({elapsed}s)", flush=True)
    return True

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

def run_pings(pairs, nodes, label):
    print(f"\n[TEST] {label}")
    passed = 0
    for src, dst in pairs:
        src_info = nodes.get(src)
        if not src_info:
            print(f"  [FAIL] {src} → {dst} (node not found)")
            continue
        port = telnet_port(src_info)
        target = VPCS_IPS[dst]
        try:
            outs = vpcs_run(port, [f"ping {target}"])
            ok = "84 bytes" in outs[0]
            print(f"  {'[PASS]' if ok else '[FAIL]'} {src} → {dst}")
            if ok:
                passed += 1
        except Exception as e:
            print(f"  [FAIL] {src} → {dst} ({e})")
    print(f"\n{passed}/{len(pairs)} passed")
    return passed

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
    lab_data = check(session.get(base), "open lab")
    lab_uuid = lab_data["data"]["id"]
    print(f"[OK] Lab '{LAB_NAME}' opened (uuid={lab_uuid})")

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

    # Build name -> node info map (preserve node_id for QCOW2 injection)
    data = check(session.get(f"{base}/nodes"), "get nodes")
    nodes = {}
    for nid, info in data["data"].items():
        info["node_id"] = nid
        nodes[info["name"]] = info

    # Configure all VPCS nodes (retry up to 3 times on failure)
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
        for attempt in range(1, 4):
            try:
                outs = vpcs_run(port, [f"ip {ip_cidr} {gw}"])
                ok = "VPCS :" in outs[0]
            except Exception as e:
                ok = False
                outs = [str(e)]
            if ok:
                print(f"  [OK] {name}: {ip_cidr} gw {gw}" + (f" (attempt {attempt})" if attempt > 1 else ""))
                break
            if attempt < 3:
                time.sleep(2)
        else:
            print(f"  [FAIL] {name}: {ip_cidr} gw {gw} (3 attempts failed)")
            print(f"    → {outs[0].strip()}")

    # Same-LAN pings (no routing needed)
    run_pings(SAME_LAN_PAIRS, nodes, "Same-LAN pings")

    # Boot vEOS routers and configure via telnet CLI after login: — in parallel
    print("\n[CONFIG] Booting and configuring vEOS routers via telnet (parallel)...")
    router_ports = {}
    for router_name in ROUTER_IFACE_CONFIGS:
        info = nodes.get(router_name)
        if not info:
            print(f"  [WARN] {router_name} not found")
            continue
        port = telnet_port(info)
        if port:
            router_ports[router_name] = port
        else:
            print(f"  [WARN] {router_name} has no telnet port")

    results = {}
    threads = []
    for router_name, port in router_ports.items():
        def _wait(name=router_name, p=port):
            results[name] = boot_and_configure_veos(p, name)
        t = threading.Thread(target=_wait, daemon=True)
        threads.append(t)
        t.start()
    for t in threads:
        t.join()
    routers_ok = all(results.get(n, False) for n in router_ports)

    # Poll for gateways to respond — agents apply startup-config in background after login:
    # Under TCG, this can take several minutes after the login prompt appears.
    gw_pairs = [(name, VPCS_IP_CONFIGS[name][1]) for name in VPCS_IP_CONFIGS]
    GW_POLL_TIMEOUT = 1800  # 30 minutes
    print(f"\n[WAIT] Polling for gateway IPs (up to {GW_POLL_TIMEOUT}s, agents start in background)...")
    gw_deadline = time.time() + GW_POLL_TIMEOUT
    gw_passed = 0
    gw_api_last = time.time()
    while time.time() < gw_deadline:
        # keepalive: touch the EVE-NG session every 60s to prevent PHP session expiry
        if time.time() - gw_api_last > 60:
            try:
                session.get(f"{base}/nodes", timeout=10)
            except Exception:
                pass
            gw_api_last = time.time()
        gw_passed = 0
        for vpcs_name, gw_ip in gw_pairs:
            info = nodes.get(vpcs_name)
            if not info:
                continue
            try:
                outs = vpcs_run(telnet_port(info), [f"ping {gw_ip}"])
                if "84 bytes" in outs[0]:
                    gw_passed += 1
            except Exception:
                pass
        elapsed = int(GW_POLL_TIMEOUT - (gw_deadline - time.time()))
        print(f"  [{elapsed:3d}s] {gw_passed}/{len(gw_pairs)} gateways up", flush=True)
        if gw_passed == len(gw_pairs):
            print("[OK] All gateways up — EOS agents applied startup-config")
            break
        time.sleep(30)
    else:
        print(f"[WARN] Only {gw_passed}/{len(gw_pairs)} gateways responded — agents may not have started")

    # Wait for OSPF convergence after interfaces are up
    if gw_passed > 0:
        print("\n[WAIT] Waiting 90s for OSPF to converge...")
        time.sleep(90)

    # Cross-LAN pings (require routing)
    run_pings(TEST_PAIRS, nodes, "Cross-LAN pings")

    # Stop all nodes
    try:
        session.get(f"{base}/nodes/stop", timeout=10)
        print("\n[OK] All nodes stopped")
    except requests.exceptions.Timeout:
        print("\n[OK] nodes/stop sent")

    sys.exit(0)

if __name__ == "__main__":
    main()
