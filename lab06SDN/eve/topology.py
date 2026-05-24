# Shared topology definition for deploy_topology.py and run_tests.py.
# Edit this file to change node names, IPs, canvas positions, or test pairs.

VEOS_QEMU = (
    "-machine type=pc-1.0,accel=kvm -serial mon:stdio -nographic "
    "-display none -no-user-config -rtc base=utc -boot order=d -cpu host"
)

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

# interface → IP/prefix for each router (used to build EOS startup config)
ROUTER_IFACE_CONFIGS = {
    "TLMRT1": [("Ethernet1", "192.168.1.1/24"),  ("Ethernet2", "192.168.12.1/24"), ("Ethernet3", "192.168.13.1/24")],
    "TLMRT2": [("Ethernet1", "192.168.2.1/24"),  ("Ethernet2", "192.168.12.2/24"), ("Ethernet3", "192.168.24.2/24")],
    "TLMRT3": [("Ethernet1", "192.168.3.1/24"),  ("Ethernet2", "192.168.34.3/24"), ("Ethernet3", "192.168.13.3/24")],
    "TLMRT4": [("Ethernet1", "192.168.4.1/24"),  ("Ethernet2", "192.168.34.4/24"), ("Ethernet3", "192.168.24.4/24")],
}

# ip_cidr, gateway for each VPCS node (written to startup.vpc)
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

# Flat IP lookup derived from VPCS_IP_CONFIGS (used by run_tests.py)
VPCS_IPS = {name: cidr.split("/")[0] for name, (cidr, _) in VPCS_IP_CONFIGS.items()}

# Cross-LAN ping campaigns: all unique unordered pairs across different LANs
TEST_PAIRS = [
    ("Client1", "Server2"),
    ("Client1", "Server3"),
    ("Client1", "Server4"),
    ("Client2", "Server3"),
    ("Client2", "Server4"),
    ("Client3", "Server4"),
    ("Server1", "Client2"),
    ("Server1", "Client3"),
    ("Server1", "Client4"),
    ("Server2", "Client3"),
    ("Server2", "Client4"),
    ("Server3", "Client4"),
]