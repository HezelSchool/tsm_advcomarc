#!/usr/bin/env python3

import os
import sys
import time
import requests
from pathlib import Path
from urllib.parse import quote
from dotenv import load_dotenv

load_dotenv(Path(__file__).parent / ".env")

EVE_URL    = os.getenv("EVE_URL",    "http://192.168.1.113")
USERNAME   = os.getenv("USERNAME",   "admin")
PASSWORD   = os.getenv("PASSWORD",   "eve")
LAB_NAME   = os.getenv("LAB_NAME",   "Test1")
LAB_FOLDER = os.getenv("LAB_FOLDER", "/")

VEOS_BOOT_TIMEOUT = 900  # seconds to wait for all nodes to reach status=2

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

    # Stop all nodes
    try:
        session.get(f"{base}/nodes/stop", timeout=10)
        print("[OK] All nodes stopped")
    except requests.exceptions.Timeout:
        print("[OK] nodes/stop sent")

    sys.exit(0)

if __name__ == "__main__":
    main()
