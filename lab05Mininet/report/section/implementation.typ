/*
 * --------------------------------------------------------------------------------
 * File: /home/hezeltm/Projects/typst_template/practical_work/section/implementation.typ
 * Project: /home/hezeltm/Projects/typst_template/practical_work/section
 * Created Date: Friday, December 19th 2025, 8:47:21 am
 * Author: Dimitri Julmy, dev@dimitri-julmy.com
 * --------------------------------------------------------------------------------
 * Last Modified: Fri Dec 19 2025
 * Modified By: Dimitri Julmy
 * --------------------------------------------------------------------------------
 * Copyright (c) 2025 Dimitri Julmy
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * --------------------------------------------------------------------------------
 */

// ---------- Imports

#import "@preview/codelst:2.0.2": sourcecode
#import "../helper.typ": qbox

// ---------- Implementation

== Mise en place de l'environnement de simulation

#qbox(
  [
    1. Referring to the Lab. Simulation reported at the end of OpenFlow course, please implement the simulations reported on slide 45, 46 and 47 of the course module on OpenFlow.
  ],
)

Premièrement, installer `VirtualBox` (procédure pour `Arch OS`) (#link("https://wiki.archlinux.org/title/VirtualBox")[https://wiki.archlinux.org/title/VirtualBox]):

#sourcecode(```sh
yay -S virtualbox
```)

Puis télécharger l'image `mininet-2.3.0-210211-ubuntu-16.04.7-server-amd64-ovf` depuis #link("https://github.com/mininet/mininet/releases")[la source officielle : https://github.com/mininet/mininet/releases].

Une fois l'image téléchargée, la décompresser et l'importer dans le dossier voulu.

#sourcecode(```sh
unzip mininet-2.3.0-210211-ubuntu-16.04.7-server-amd64-ovf.zip -d ~/Isos/
```)

- `-d ~/Isos/` : spécifie le répertoire de destination de la décompression.

Pour créer la machine virtuelle, suivre #link("https://mininet.org/vm-setup-notes/")[le guide officiel : https://mininet.org/vm-setup-notes/].

+ Sur `VirtualBox`, cliquer sur `Import` et sélectionner le fichier `mininet-2.3.0-210211-ubuntu-16.04.7-server-amd64.ovf`. Valider l'importation.
+ Sélectionner la machine virtuelle importée, cliquer sur `Settings` en mode `Expert` puis `Network`. Sélectionner `Host-only Adapter` pour `Adapter 1`. Sélectionner `vboxnet0` pour `Name`. Valider les changements.

Si `vboxnet0` n'est pas disponible, il faut le créer à l'aide des commandes suivantes :

#sourcecode(```sh
# Create a host-only network interface
sudo vboxmanage hostonlyif create
# Check if the interface was created successfully
vboxmanage list hostonlyifs
```)

- `hostonlyif create` : crée une nouvelle interface réseau hôte-uniquement virtuelle (`vboxnet0`).
- `list hostonlyifs` : liste toutes les interfaces hôte-uniquement existantes pour confirmer la création.

Exécuter la machine virtuelle et se connecter avec les identifiants suivants :

- _Username_ : `mininet`
- _Password_ : `mininet`

Trouver l'adresse IP de la machine virtuelle à l'aide de la commande suivante (à exécuter dans la machine virtuelle). Pour ce travail, l'adresse IP est : `192.168.56.101`.

#sourcecode(```sh
# Get eth0 IP address
ifconfig eth0
```)

- `eth0` : nom de l'interface réseau correspondant à l'adaptateur hôte-uniquement VirtualBox dans la VM.

Pour faciliter la connexion SSH par nom, ajouter une entrée dans le fichier `/etc/hosts` de la machine hôte :

#sourcecode(```sh
echo "192.168.56.101 mininet-vm" | sudo tee -a /etc/hosts
```)

- `tee` : lit depuis stdin et écrit simultanément dans un fichier et sur stdout.
- `-a` : mode _append_ — ajoute à la fin du fichier sans écraser le contenu existant.

Se connecter en SSH à la machine virtuelle depuis la machine hôte :

#sourcecode(```sh
ssh -Y mininet@mininet-vm
```)

- `-Y` : active le transfert X11 de confiance (_trusted X11 forwarding_), permettant d'afficher des interfaces graphiques (comme `xterm` ou `Wireshark`) depuis la VM sur la machine hôte.

Démarrer le contrôleur `POX` dans un premier terminal `SSH` :

#sourcecode(```sh
# Run POX controller
sudo ~/pox/pox.py forwarding.l2_pairs info.packet_dump samples.pretty_log log.level --DEBUG
```)

- `forwarding.l2_pairs` : module d'apprentissage L2 réactif — apprend les paires MAC src/dst et installe des règles de flux dans les commutateurs.
- `info.packet_dump` : affiche le contenu des paquets reçus par le contrôleur (utile pour le débogage).
- `samples.pretty_log` : formate les logs de façon lisible avec horodatage et niveau de sévérité.
- `log.level --DEBUG` : fixe le niveau de verbosité des logs à `DEBUG` pour voir tous les événements OpenFlow.

Puis, démarrer la topologie souhaitée dans une autre session `SSH`.

- `single,3` : un commutateur central connecté à 3 hôtes (`h1`, `h2`, `h3`).

#sourcecode(```sh
sudo mn -x --topo single,3 --controller remote
```)

- `linear,3` : une chaîne linéaire de 3 commutateurs, chacun connecté à un hôte (`h1`, `h2`, `h3`).

#sourcecode(```sh
sudo mn -x --topo linear,3 --controller remote
```)

- `linear,4` : une chaîne linéaire de 4 commutateurs, chacun connecté à un hôte (`h1`, `h2`, `h3`, `h4`).

#sourcecode(```sh
sudo mn --topo linear,4 --controller remote
```)

Les paramètres communs à ces commandes `mn` :

- `-x` : ouvre un terminal `xterm` pour chaque nœud du réseau (requiert le transfert X11 activé par `ssh -Y`).
- `--topo <type>,<n>` : définit la topologie réseau à instancier (`single`, `linear`, `tree`, etc.) avec le nombre de nœuds.
- `--controller remote` : indique à Mininet d'utiliser un contrôleur distant plutôt que le contrôleur interne — se connecte à `localhost:6633` par défaut (port standard OpenFlow 1.0).

Démarrer le serveur HTTP sur `h1` et effectuer une requête depuis `h2` :

#sourcecode(```sh
h1 python -m SimpleHTTPServer 80 &
h2 wget -O - h1
```)

- `-m SimpleHTTPServer` : lance le module Python `SimpleHTTPServer` comme programme principal (sert le répertoire courant via `HTTP`).
- `80` : port d'écoute du serveur `HTTP`.
- `&` : exécute le serveur en arrière-plan pour libérer le terminal Mininet.
- `wget -O -` : télécharge la ressource et redirige le contenu vers `stdout` au lieu de l'enregistrer dans un fichier.

== Vérification du fonctionnement des composants

#qbox(
  [2. Please verify the functionality of all system components.],
)

Une fois Mininet démarré, les commandes suivantes vérifient que tous les composants fonctionnent correctement. Les exemples ci-dessous sont basés sur la topologie `single,3`. Toutes les commandes sont à exécuter dans la CLI Mininet.

*Lister les nœuds et liens du réseau :*

#sourcecode(```sh
# List nodes
nodes
# Output
available nodes are:
c0 h1 h2 h3 s1

# List links
net
# Output
h1 h1-eth0:s1-eth1
h2 h2-eth0:s1-eth2
h3 h3-eth0:s1-eth3
s1 lo:  s1-eth1:h1-eth0 s1-eth2:h2-eth0 s1-eth3:h3-eth0
c0
```)

*Vérifier la configuration réseau de `h1` :*

#sourcecode(```sh
# Check h1 network configuration
mininet> h1 ifconfig
# Output
h1-eth0   Link encap:Ethernet  HWaddr a6:78:8c:84:c9:6b
          inet addr:10.0.0.1  Bcast:10.255.255.255  Mask:255.0.0.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
```)

Chaque hôte Mininet est un espace de noms réseau Linux indépendant (`network namespace`) avec sa propre interface virtuelle. `h1` reçoit l'adresse IP `10.0.0.1`. L'adresse MAC est générée aléatoirement par Mininet à chaque démarrage.

*Test de connectivité ICMP entre `h1` et `h2` :*

#sourcecode(```sh
# Test ICMP connectivity
h1 ping h2 -c 4
# Output
PING 10.0.0.2 (10.0.0.2) 56(84) bytes of data.
64 bytes from 10.0.0.2: icmp_seq=1 ttl=64 time=41.3 ms
64 bytes from 10.0.0.2: icmp_seq=2 ttl=64 time=0.070 ms
64 bytes from 10.0.0.2: icmp_seq=3 ttl=64 time=0.062 ms
64 bytes from 10.0.0.2: icmp_seq=4 ttl=64 time=0.051 ms
--- 10.0.0.2 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 2998ms
rtt min/avg/max/mdev = 0.051/10.372/41.307/17.860 ms
```)

le résultat `0% packet loss` confirme que `h1` et `h2` communiquent correctement.

*Test de connectivité globale (`pingall`) :*

#sourcecode(```sh
# Test overall connectivity
pingall
# Output
*** Ping: testing ping reachability
h1 -> h2 h3
h2 -> h1 h3
h3 -> h1 h2
*** Results: 0% dropped (6/6 received)
```)

Le résultat `0% dropped (6/6 received)` confirme que tous les hôtes communiquent correctement et que le contrôleur `POX` gère le réseau dans son intégralité.

*Affichage de la table de flux de `s1` :*

#sourcecode(```sh
# Check s1 flow table
dpctl dump-flows
# Output
*** s1 ------------------------------------------------------------------------
NXST_FLOW reply (xid=0x4):
 cookie=0x0, duration=77.490s, table=0, n_packets=7, n_bytes=630, idle_age=47, dl_src=a6:78:8c:84:c9:6b,dl_dst=86:16:5d:0c:3b:5f actions=output:2
 cookie=0x0, duration=77.452s, table=0, n_packets=8, n_bytes=672, idle_age=47, dl_src=86:16:5d:0c:3b:5f,dl_dst=a6:78:8c:84:c9:6b actions=output:1
 cookie=0x0, duration=47.486s, table=0, n_packets=3, n_bytes=238, idle_age=42, dl_src=a6:78:8c:84:c9:6b,dl_dst=1a:3b:3c:40:71:5a actions=output:3
 cookie=0x0, duration=47.448s, table=0, n_packets=4, n_bytes=280, idle_age=42, dl_src=1a:3b:3c:40:71:5a,dl_dst=a6:78:8c:84:c9:6b actions=output:1
 cookie=0x0, duration=47.444s, table=0, n_packets=3, n_bytes=238, idle_age=42, dl_src=86:16:5d:0c:3b:5f,dl_dst=1a:3b:3c:40:71:5a actions=output:3
 cookie=0x0, duration=47.408s, table=0, n_packets=4, n_bytes=280, idle_age=42, dl_src=1a:3b:3c:40:71:5a,dl_dst=86:16:5d:0c:3b:5f actions=output:2
```)

Après le `pingall`, la table de flux de `s1` contient 6 entrées : deux règles (une par sens) pour chacune des 3 paires d'hôtes possibles (h1↔h2, h1↔h3, h2↔h3).

== Capture du trafic réseau avec Wireshark

#qbox(
  [3. Please log all packet exchanges using Wireshark.],
)

L'objectif de cette étape est de capturer le trafic réseau généré lors de l'exécution d'un _simple web server_ sur `h1` et d'une requête HTTP depuis `h2`. L'infrastructure simulée pour ce test est la topologie `single,3` avec le contrôleur `POX` en mode `forwarding.l2_pairs`.

Capturer le trafic réseau dans une première session `SSH` :

#sourcecode(```sh
# Test overall connectivity
sudo tshark -i any -w /tmp/capture.pcap
```)

Démarrer le serveur HTTP sur `h1` et effectuer une requête depuis `h2` dans une seconde session `SSH` :

#sourcecode(```sh
h1 python -m SimpleHTTPServer 80 &
h2 wget -O - h1
```)

Arrêter la capture (Ctrl+C) et modifier les permissions du fichier de capture pour permettre à l'utilisateur hôte de le lire (par défaut, il est créé avec des permissions restrictives) :

#sourcecode(```sh
sudo chmod 644 /tmp/capture.pcap
```)

Transférer le fichier de capture vers la machine hôte pour analyse avec Wireshark (commande à exécuter sur la machine hôte) :

#sourcecode(```sh
scp mininet@192.168.56.101:/tmp/capture.pcap ~/capture.pcap
```)

La capture peut ensuite être ouverte dans Wireshark sur la machine hôte pour analyse.

== Échange d'initialisation OpenFlow

#qbox(
  [4. Isolate the OpenFlow initialization exchange (get inspiration from the course slides).],
)

TODO

== Requêtes et réponses ARP

#qbox(
  [5. Try identifying the ARP requests and replies (get inspired from the course slides).],
)

TODO

== Échanges de création de socket ICMP et HTTP

#qbox(
  [6. Isolate and comment the socket creation exchanges using both ICMP and HTTP.],
)

TODO
