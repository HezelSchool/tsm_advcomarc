#!/usr/bin/env python3

import os
import sys
import time
import uuid
import ipaddress
import xml.etree.ElementTree as ET
from pathlib import Path
import paramiko
import requests
from urllib.parse import quote
from dotenv import load_dotenv

load_dotenv(Path(__file__).parent / ".env")

# ----- Constants

EVE_URL    = os.getenv("EVE_URL",    "http://192.168.1.113")
USERNAME   = os.getenv("USERNAME",   "admin")
PASSWORD   = os.getenv("PASSWORD",   "eve")
SSH_USER   = os.getenv("SSH_USER",   "root")
SSH_PASS   = os.getenv("SSH_PASS",   "eve")
LAB_NAME   = os.getenv("LAB_NAME",   "Test1")
LAB_FOLDER = os.getenv("LAB_FOLDER", "/")
VEOS_IMAGE = os.getenv("VEOS_IMAGE", "veos-4.36.0.1F")
VEOS_QEMU  = (
    "-machine type=pc-1.0,accel=kvm -serial mon:stdio -nographic "
    "-display none -no-user-config -rtc base=utc -boot order=d -cpu host"
)

# ----- Topology

ROUTERS = [
    {"name": "TLMRT1", "left": 600, "top": 400},
    {"name": "TLMRT2", "left": 200, "top": 400},
    {"name": "TLMRT3", "left": 600, "top": 150},
    {"name": "TLMRT4", "left": 200, "top": 150},
]

# 0=Management1 (unused), 1=Ethernet1, 2=Ethernet2, 3=Ethernet3
ROUTER_CONNECTIONS = {
    "TLMRT1": {1: "LAN1",  2: "WAN12", 3: "WAN13"},
    "TLMRT2": {1: "LAN2",  2: "WAN12", 3: "WAN24"},
    "TLMRT3": {1: "LAN3",  2: "WAN34", 3: "WAN13"},
    "TLMRT4": {1: "LAN4",  2: "WAN34", 3: "WAN24"},
}

NETWORKS = [
    {"name": "LAN1",  "left": 780, "top": 430},
    {"name": "LAN2",  "left":  20, "top": 430},
    {"name": "LAN3",  "left": 780, "top": 120},
    {"name": "LAN4",  "left":  20, "top": 120},
    {"name": "WAN12", "left": 400, "top": 480},
    {"name": "WAN13", "left": 680, "top": 280},
    {"name": "WAN24", "left": 120, "top": 280},
    {"name": "WAN34", "left": 400, "top":  80},
]

VPCS_NODES = [
    {"name": "Client1", "lan": "LAN1", "left": 720, "top": 530},
    {"name": "Server1", "lan": "LAN1", "left": 840, "top": 530},
    {"name": "Client2", "lan": "LAN2", "left":  40, "top": 530},
    {"name": "Server2", "lan": "LAN2", "left": 160, "top": 530},
    {"name": "Client3", "lan": "LAN3", "left": 720, "top":  40},
    {"name": "Server3", "lan": "LAN3", "left": 840, "top":  40},
    {"name": "Client4", "lan": "LAN4", "left":  40, "top":  40},
    {"name": "Server4", "lan": "LAN4", "left": 160, "top":  40},
]

# interface name → IP/prefix per router
ROUTER_IFACE_CONFIGS = {
    "TLMRT1": [("Ethernet1", "192.168.1.1/24"),  ("Ethernet2", "192.168.12.1/24"), ("Ethernet3", "192.168.13.1/24")],
    "TLMRT2": [("Ethernet1", "192.168.2.1/24"),  ("Ethernet2", "192.168.12.2/24"), ("Ethernet3", "192.168.24.2/24")],
    "TLMRT3": [("Ethernet1", "192.168.3.1/24"),  ("Ethernet2", "192.168.34.3/24"), ("Ethernet3", "192.168.13.3/24")],
    "TLMRT4": [("Ethernet1", "192.168.4.1/24"),  ("Ethernet2", "192.168.34.4/24"), ("Ethernet3", "192.168.24.4/24")],
}

# VPCS startup: ip_cidr, gateway
VPCS_IP_CONFIGS = {
    "Client1": ("192.168.1.101/24", "192.168.1.1"),
    "Server1": ("192.168.1.11/24",  "192.168.1.1"),
    "Client2": ("192.168.2.101/24", "192.168.2.1"),
    "Server2": ("192.168.2.11/24",  "192.168.2.1"),
    "Client3": ("192.168.3.101/24", "192.168.3.1"),
    "Server3": ("192.168.3.11/24",  "192.168.3.1"),
    "Client4": ("192.168.4.101/24", "192.168.4.1"),
    "Server4": ("192.168.4.11/24",  "192.168.4.1"),
}

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

def make_router_config(name, ifaces):
    lines = [f"hostname {name}", "!", "ip routing", "!"]
    nets = []
    for iface, addr in ifaces:
        lines += [f"interface {iface}", f"   ip address {addr}", "   no shutdown", "!"]
        nets.append(str(ipaddress.ip_interface(addr).network))
    lines.append("router ospf 1")
    for net in nets:
        lines.append(f"   network {net} area 0.0.0.0")
    lines += ["!", "end", ""]
    return "\n".join(lines)

# ----- Deploy

def main():
    session = requests.Session()
    session.headers.update({"Content-Type": "application/json"})

    # Login
    r = session.post(f"{EVE_URL}/api/auth/login",
                     json={"username": USERNAME, "password": PASSWORD, "html5": "-1"})
    check(r, "login")
    print("[OK] Authenticated")

    # Delete existing lab
    lab_path = lab_url_path(LAB_NAME, LAB_FOLDER)
    r = session.delete(f"{EVE_URL}/api/labs/{lab_path}")
    if r.status_code == 200:
        print(f"[OK] Existing lab '{LAB_NAME}' deleted, waiting for cleanup...")
        for _ in range(30):
            time.sleep(1)
            r = session.get(f"{EVE_URL}/api/labs/{lab_path}")
            if r.status_code == 404 or r.json().get("code") == 404:
                break
        time.sleep(2)
        print("[OK] Lab fully removed")

    # Create lab (generates UUID and empty .unl on disk)
    r = session.post(f"{EVE_URL}/api/labs", json={
        "name":        LAB_NAME,
        "path":        LAB_FOLDER,
        "version":     "1",
        "description": "SDN Lab — Arista vEOS ring topology",
    })
    check(r, "Lab creation")
    print(f"[OK] Lab '{LAB_NAME}' created")

    # Read UUID from the generated .unl
    base = f"{EVE_URL}/api/labs/{lab_url_path(LAB_NAME, LAB_FOLDER)}"
    lab_uuid = check(session.get(base), "get lab")["data"]["id"]
    print(f"[OK] Lab UUID: {lab_uuid}")

    # ----- Build complete .unl XML

    net_ids = {net["name"]: i for i, net in enumerate(NETWORKS, start=1)}

    lab_el = ET.Element("lab",
        name=LAB_NAME, id=lab_uuid,
        version="1", scripttimeout="600", lock="0",
    )
    ET.SubElement(lab_el, "description").text = "SDN Lab — Arista vEOS ring topology"
    topology  = ET.SubElement(lab_el, "topology")
    nodes_el  = ET.SubElement(topology, "nodes")
    nets_el   = ET.SubElement(topology, "networks")

    # Networks
    for net in NETWORKS:
        ET.SubElement(nets_el, "network",
            id=str(net_ids[net["name"]]), type="bridge",
            name=net["name"], left=str(net["left"]), top=str(net["top"]),
            visibility="1", icon="lan.png",
        )
        print(f"[OK] network {net['name']:6s} → id={net_ids[net['name']]}")

    # Routers (ids 1–4)
    for i, router in enumerate(ROUTERS, start=1):
        node_el = ET.SubElement(nodes_el, "node",
            id=str(i), name=router["name"],
            type="qemu", template="veos", image=VEOS_IMAGE,
            console="telnet", cpu="2", cpulimit="1", ram="2048", ethernet="4",
            uuid=str(uuid.uuid4()),
            qemu_options=VEOS_QEMU, qemu_version="2.4.0", qemu_arch="x86_64",
            delay="0", icon="Router.png", config="1",
            left=str(router["left"]), top=str(router["top"]),
        )
        for iface_idx, net_name in ROUTER_CONNECTIONS[router["name"]].items():
            ET.SubElement(node_el, "interface",
                id=str(iface_idx), name=f"Eth{iface_idx}",
                type="ethernet", network_id=str(net_ids[net_name]),
            )
        print(f"[OK] Router {router['name']:6s} → id={i}")

    # VPCS (ids 5–12)
    for i, vpc in enumerate(VPCS_NODES, start=len(ROUTERS) + 1):
        node_el = ET.SubElement(nodes_el, "node",
            id=str(i), name=vpc["name"],
            type="vpcs", template="vpcs", image="",
            ethernet="1", delay="0", icon="Router.png", config="1",
            left=str(vpc["left"]), top=str(vpc["top"]),
        )
        ET.SubElement(node_el, "interface",
            id="0", name="eth0",
            type="ethernet", network_id=str(net_ids[vpc["lan"]]),
        )
        print(f"[OK] VPCS {vpc['name']:8s} → id={i}, wired to {vpc['lan']}")

    # ----- Write .unl via SSH/SFTP
    ET.indent(lab_el)
    xml_bytes = (
        b'<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n'
        + ET.tostring(lab_el, encoding="unicode").encode()
    )

    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(EVE_URL.split("//")[1], username=SSH_USER, password=SSH_PASS)
    sftp = ssh.open_sftp()
    with sftp.open(f"/opt/unetlab/labs/{LAB_NAME}.unl", "wb") as f:
        f.write(xml_bytes)
    sftp.close()
    ssh.close()
    print("[OK] .unl written via SFTP")

    # ----- Push startup configs via SSH
    print("\n[CONFIGS] Pushing startup configurations...")
    ssh_cfg = paramiko.SSHClient()
    ssh_cfg.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh_cfg.connect(EVE_URL.split("//")[1], username=SSH_USER, password=SSH_PASS)
    sftp_cfg = ssh_cfg.open_sftp()
    config_base = f"/opt/unetlab/labs/{LAB_NAME}"

    for i, router in enumerate(ROUTERS, start=1):
        node_dir = f"{config_base}/{i}"
        _, stdout, _ = ssh_cfg.exec_command(f"mkdir -p {node_dir}")
        stdout.channel.recv_exit_status()
        cfg = make_router_config(router["name"], ROUTER_IFACE_CONFIGS[router["name"]])
        with sftp_cfg.open(f"{node_dir}/startup-config", "w") as f:
            f.write(cfg)
        print(f"[OK] Router {router['name']:6s} startup-config written")

    for i, vpc in enumerate(VPCS_NODES, start=len(ROUTERS) + 1):
        node_dir = f"{config_base}/{i}"
        _, stdout, _ = ssh_cfg.exec_command(f"mkdir -p {node_dir}")
        stdout.channel.recv_exit_status()
        ip_cidr, gw = VPCS_IP_CONFIGS[vpc["name"]]
        with sftp_cfg.open(f"{node_dir}/startup.vpc", "w") as f:
            f.write(f"ip {ip_cidr} {gw}\n")
        print(f"[OK] VPCS {vpc['name']:8s} startup.vpc written")

    sftp_cfg.close()
    ssh_cfg.close()

    # ----- Verify
    print("\n[VERIFY] Reading back .unl for verification...")
    ssh2 = paramiko.SSHClient()
    ssh2.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh2.connect(EVE_URL.split("//")[1], username=SSH_USER, password=SSH_PASS)
    sftp2 = ssh2.open_sftp()
    with sftp2.open(f"/opt/unetlab/labs/{LAB_NAME}.unl", "rb") as f:
        written = ET.fromstring(f.read())
    sftp2.close()
    ssh2.close()

    errors = 0

    # Check networks
    found_nets = {el.get("name"): int(el.get("id")) for el in written.findall(".//network")}
    for net in NETWORKS:
        if net["name"] not in found_nets:
            print(f"  [FAIL] network {net['name']} missing")
            errors += 1
        elif found_nets[net["name"]] != net_ids[net["name"]]:
            print(f"  [FAIL] network {net['name']} wrong id={found_nets[net['name']]}")
            errors += 1
        else:
            print(f"  [OK]   network {net['name']:6s} id={found_nets[net['name']]}")

    # Check router interface wiring
    for i, router in enumerate(ROUTERS, start=1):
        node_el = written.find(f".//node[@id='{i}']")
        if node_el is None:
            print(f"  [FAIL] router {router['name']} missing")
            errors += 1
            continue
        for iface_idx, net_name in ROUTER_CONNECTIONS[router["name"]].items():
            iface_el = node_el.find(f"interface[@id='{iface_idx}']")
            expected = str(net_ids[net_name])
            if iface_el is None:
                print(f"  [FAIL] {router['name']} Eth{iface_idx} interface missing")
                errors += 1
            elif iface_el.get("network_id") != expected:
                print(f"  [FAIL] {router['name']} Eth{iface_idx} → net {iface_el.get('network_id')} (expected {expected})")
                errors += 1
            else:
                print(f"  [OK]   {router['name']} Eth{iface_idx} → {net_name} (net_id={expected})")

    # Check VPCS wiring
    for i, vpc in enumerate(VPCS_NODES, start=len(ROUTERS) + 1):
        node_el = written.find(f".//node[@id='{i}']")
        if node_el is None:
            print(f"  [FAIL] VPCS {vpc['name']} missing")
            errors += 1
            continue
        iface_el = node_el.find("interface[@id='0']")
        expected = str(net_ids[vpc["lan"]])
        if iface_el is None:
            print(f"  [FAIL] {vpc['name']} interface missing")
            errors += 1
        elif iface_el.get("network_id") != expected:
            print(f"  [FAIL] {vpc['name']} → net {iface_el.get('network_id')} (expected {expected})")
            errors += 1
        else:
            print(f"  [OK]   {vpc['name']:8s} → {vpc['lan']} (net_id={expected})")

    if errors == 0:
        print(f"\n[DONE] Topology deployed and verified → {EVE_URL}")
    else:
        print(f"\n[DONE] Deployed with {errors} verification error(s) → {EVE_URL}")

# ----- Main

if __name__ == "__main__":
    main()
