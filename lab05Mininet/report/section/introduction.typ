// -------------------------------------------------------------------
// Copyright © 2025 Dimitri Julmy
// License MIT
// -------------------------------------------------------------------
// Author : Dimitri Julmy <dev@dimitri-julmy.com>
// Date   : 27.11.2025
// -------------------------------------------------------------------
// Report Template - introduction.typ
// -------------------------------------------------------------------

// ---------- Imports

// Third-party

// Values

// ---------- Introduction

Ce laboratoire explore les concepts fondamentaux du _Software-Defined Networking_ (`SDN`) à travers la simulation d'un réseau virtuel avec _Mininet_ et le contrôleur _POX_. Le `SDN` repose sur la séparation du plan de contrôle et du plan de données : le contrôleur décide des règles de transfert, et les _switches_ les appliquent via le protocole _OpenFlow_.

L'environnement déployé repose sur une machine virtuelle `Ubuntu 16.04` (`mininet-2.3.0`) importée sous _VirtualBox_ et accessible en `SSH` depuis la machine hôte à l'adresse `192.168.56.101`. Le contrôleur _POX_ (`forwarding.l2_pairs`) est lancé sur la _VM_ et écoute sur le port `6633`. Les topologies simulées (`single,3`, `linear,3`, `linear,4`) sont instanciées via la CLI _Mininet_. Les captures réseau sont effectuées avec `tcpdump` directement sur la _VM_, puis transférées sur la machine hôte via `scp` pour analyse dans _Wireshark_.

L'objectif est d'observer et d'analyser les échanges réseau générés par _OpenFlow_, `ARP`, `ICMP` et `HTTP`, afin de comprendre comment le plan de contrôle _SDN_ gère l'initialisation, l'apprentissage des adresses MAC et l'installation des règles de flux dans les _switches_.
