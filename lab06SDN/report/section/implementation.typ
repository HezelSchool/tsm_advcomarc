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

== Mise en place EVE

La procédure ci-dessous est détaillée pour un environnement _Arch Linux_.

Installer _VirtualBox_ (#link("https://wiki.archlinux.org/title/VirtualBox")[https://wiki.archlinux.org/title/VirtualBox]):

#sourcecode(```sh
yay -S virtualbox
```)

Télécharger #link("https://www.eve-ng.net/index.php/download/#DL-COMM")[_Free EVE Community Edition Version 6.2.0-4_].

Créer une nouvelle VM (`machine` > `New`, `Ctrl + n`) avec les paramètres suivants, puis cliquer sur `Finish` :

- _Virtual machine name and operating system_ :
  - `VM Name` : `EVE-NG`
  - `ISO Image` : `/path/to/image/eve-ce-prod-6.2.0-4-full.iso`
  - `OS` : `Linux`
- _Specify virtual hardware_
  - `Base Memory` : `8000 MB`
  - `CPU` : `4`
- _Specify virtual hard disk_
  - `Disk Size` : `50 GB`

Dans `Settings > Network` (mode `Expert`), passer l'`Adapter 1` en `Bridged Adapter`. Laisser les autres paramètres par défaut.

Au premier démarrage, suivre l'installation de `EVE-NG Community 6.2.0-4` (langue et clavier). Une fois terminée, la _VM_ retourne sur _GRUB_ : retirer le disque via `Device > Optical Device > Remove Disk From Virtual Device`, puis éteindre la machine (`Power off the machine`). Au redémarrage, se connecter avec :

- Nom d'utilisateur : `root`
- Mot de passe : `eve`

Conserver les valeurs par défaut pour les configurations suivantes. La machine redémarre ; se reconnecter avec les mêmes identifiants. L'_URL_ de l'interface web est affichée dans la console (`http://192.168.1.113` dans notre cas). Se connecter avec les identifiants suivant :

- Nom d'utilisateur : `admin`
- Mot de passe : `eve`

Télécharger l'image du routeur _Arista_ `vEOS-lab-4.36.0.1F.qcow2` et le _bootloader_ `Aboot-veos-serial-8.0.2.iso` depuis le support de cours _Moodle_.

Avant de démarrer la _VM_, activer la virtualisation imbriquée (_nested virtualization_) dans _VirtualBox_ pour que _KVM_ soit disponible dans le _guest_ (_VM_ éteinte) :

#sourcecode(```sh
# Sur la machine hôte (VM éteinte)
VBoxManage modifyvm "EVE-NG" --nested-hw-virt on
```)

Démarrer la _VM_, puis transférer les images et corriger les permissions :

#sourcecode(```sh
# Sur la machine hôte
ssh root@10.24.45.108 "mkdir -p /opt/unetlab/addons/qemu/veos-4.36.0.1F"
scp ~/Downloads/vEOS-lab-4.36.0.1F.qcow2 root@10.24.45.108:/opt/unetlab/addons/qemu/veos-4.36.0.1F/hda.qcow2
scp ~/Downloads/Aboot-veos-serial-8.0.2.iso root@10.24.45.108:/opt/unetlab/addons/qemu/veos-4.36.0.1F/cdrom.iso

# Sur la VM
echo "kvm" > /opt/unetlab/platform
/opt/unetlab/wrappers/unl_wrapper -a fixpermissions
```)

Source : #link("https://www.youtube.com/watch?v=-WnV8UyVjek&t=213s")[Youtube - TechNPlay -  How to Install EVE-NG on Oracle VirtualBox 2025]

== EVE and alternate solutions

#qbox(
  [While installing EVE, please look for the differences between EVE and another alternate solution: GNS3, and document the findings.],
)

*GNS3* :

- Émulateur réseau _open-source_.
- Exécute de vraies images _IOS_ (pas de logiciels simulés).
- Le comportement des équipements est identique au matériel physique (grâce aux vraies images _IOS_).
- Architecture client-serveur (l'interface graphique tourne localement tandis que le _backend_ d'émulation tourne localement ou sur un serveur distant).

\+ Avantages :

- Plus grande communauté (davantage de tutoriels, _templates_ et ressources)
- Expérience bureau native
- Intégration officielle _Cisco_
- Excellente intégration _Wireshark_
- Développement actif

\- Désavantages :

- Architecture mono-utilisateur (non conçue pour les simulations partagées)
- La configuration de la _VM GNS3_ peut être complexe
- Émulation _IOS legacy_ uniquement pour les images anciennes

*EVE* :

- Plateforme d'émulation réseau fonctionnant entièrement comme une application serveur _Linux_.
- Accessible via un navigateur web (aucune installation locale requise).
- Conçue pour les environnements de labs partagés (plusieurs utilisateurs peuvent se connecter simultanément au même serveur _EVE-NG_, chacun travaillant dans sa propre topologie).
- Deux éditions : _Community_ (gratuite) et _Professional_ (payante)

#pagebreak()

\+ Avantages :

- Accès via navigateur
- Environnements de labs partagés
- Fort support multi-constructeurs
- Déduplication mémoire _UKSM_ (exécuter 10 routeurs identiques consomme beaucoup moins de _RAM_ que 10 processus séparés)

\- Désavantages :

- Configuration d'un serveur requise
- Les meilleures fonctionnalités sont payantes
- Communauté plus petite que _GNS3_

*Comparaison des fonctionnalités*

#table(
  columns: (2.5fr, 2fr, 2fr, 2fr),
  align: (left, center, center, center),
  [#strong[Fonctionnalité]], [#strong[GNS3]], [#strong[EVE-NG Community]], [#strong[EVE-NG Pro]],
  [Coût], [Gratuit], [Gratuit], [~\$120/an],
  [Interface], [Interface bureau (_Windows/Mac/Linux_)], [Navigateur web], [Navigateur web],
  [Installation], [Application locale + _VM GNS3_], [Serveur _Linux_ (_bare metal_ ou _VM_)], [Serveur _Linux_],
  [Support multi-utilisateurs], [❌ Mono-utilisateur], [❌ Limité], [✅ Multi-utilisateurs complet],
  [Support _Cisco IOS_], [✅ Complet], [✅ Complet], [✅ Complet],
  [_Cisco IOS-XE/XR/NX-OS_], [✅], [✅], [✅],
  [_Palo Alto / Fortinet / Juniper_], [✅ Via _QEMU_], [✅ Via _QEMU_], [✅ Via _QEMU_],
  [Efficacité _RAM_], [Standard], [Standard], [✅ Déduplication _UKSM_],
  [Support conteneurs _Docker_], [✅], [✅], [✅],
  [Capture de paquets intégrée], [✅ Intégration _Wireshark_], [✅], [✅],
  [Communauté et _templates_], [Très grande], [Grande], [Grande + officielle],
  [Labs certification _Cisco_], [✅ _GNS3_ Academy officielle], [Labs communautaires], [Labs _EVE-NG_ officiels],
)

Source : #link("https://www.raghededris.com/2026/03/13/eve-ng-vs-gns3-comparison/")[raghededris.com - EVE-NG vs GNS3 : https://www.raghededris.com/2026/03/13/eve-ng-vs-gns3-comparison/]

#pagebreak()

== Analyse de l'environnement EVE

#qbox(
  [Take a look at the tools and configurations made available by the program.],
)

_EVE-NG_ (_Emulated Virtual Environment_) expose une interface web permettant de concevoir, démarrer et superviser des topologies réseau entièrement depuis un navigateur.

*Outils principaux :*

- *_Topology Editor_* : éditeur graphique _drag-and-drop_ pour créer des topologies réseau. Permet d'ajouter des nœuds, de les relier par des liens virtuels et d'exporter/importer des labs au format `.unl`.
- *Console d'accès* : accès aux nœuds via _Telnet_, _SSH_ ou _VNC_ selon le type d'équipement (_IOL_, _QEMU_, _Docker_).
- *Capture de paquets* : capture intégrée sur n'importe quel lien de la topologie, avec ouverture directe dans _Wireshark_ sur la machine cliente.
- *Gestion des labs* : création, sauvegarde et partage de labs sous forme d'archives _ZIP_.

*Configurations disponibles :*

- *Templates de nœuds* : modèles préconfigurés pour une multitude de constructeurs (_Cisco_, _Juniper_, _Arista_, _Palo Alto_, _Fortinet_, etc.). Chaque template définit le type d'hyperviseur, le nombre d'interfaces, la _RAM_ et le _CPU_ alloués.
- *Types de réseaux* : réseau de management (`Cloud0`), bridges internes (`Net`) et connexions vers le réseau hôte (`Cloud1`–`Cloud9`).
- *Configurations de démarrage* : possibilité de pré-charger une configuration initiale sur chaque nœud avant le démarrage du lab.
- *Gestion des utilisateurs* : comptes utilisateurs avec rôles (administrateur, étudiant) et accès simultanés aux labs en édition _Pro_.

Source : #link("https://www.eve-ng.net/index.php/documentation/")[eve-ng.net - Documentation officielle EVE-NG : https://www.eve-ng.net/index.php/documentation/]

#qbox(
  [Please check the infrastructure and librairies made available by EVE.],
)

_EVE-NG_ s'appuie sur un socle _Linux_ (`Ubuntu Server 22.04 LTS`) et tire parti de plusieurs technologies de virtualisation pour émuler des équipements réseau hétérogènes.

*Infrastructure :*

- *_KVM/QEMU_* : hyperviseur principal utilisé pour exécuter les images _QEMU_ des équipements réseau (routeurs, _firewalls_, _switches_). Chaque nœud tourne dans une _VM_ légère.
- *_IOL (IOS on Linux)_* : permet de faire tourner certaines images _Cisco_ _IOS_ directement comme des processus _Linux_, sans virtualisation complète, ce qui réduit la consommation de ressources.
- *_Docker_* : support des conteneurs pour des nœuds légers (serveurs _Linux_, outils de test réseau).
- *_Linux bridges / veth / tap_* : interconnexion des nœuds via des interfaces réseau virtuelles du noyau _Linux_.
- *_UKSM (Ultra Kernel Samepage Merging)_* : mécanisme de déduplication mémoire qui fusionne les pages _RAM_ identiques entre _VMs_, réduisant considérablement la _RAM_ consommée lorsque plusieurs instances du même _OS_ tournent simultanément (disponible en édition _Pro_).

#pagebreak()

*_API_ et bibliothèques :*

- *_EVE-NG REST API_* : _API_ HTTP complète pour piloter _EVE-NG_ par programmation (gestion des labs, démarrage/arrêt des nœuds, configuration des topologies). Les principaux endpoints sont `/api/labs`, `/api/nodes`, `/api/networks` et `/api/topologies`.
- *_peve_* : bibliothèque _Python_ communautaire encapsulant l'_API REST_ d'_EVE-NG_, facilitant l'automatisation des labs depuis des scripts _Python_.

Source : #link("https://www.eve-ng.net/index.php/documentation/howtos/how-to-eve-ng-api/")[eve-ng.net - EVE-NG REST API : https://www.eve-ng.net/index.php/documentation/howtos/how-to-eve-ng-api/]

#qbox(
  [Please check the website of ARISTA, a provider of SDN solutions. Try looking for libraries and extensions that will allow enriching the palette offered by natively by EVE.],
)

_Arista Networks_ est un fournisseur de solutions _SDN_ dont le système d'exploitation *_EOS (Extensible Operating System)_* est conçu pour être entièrement programmable. _Arista_ propose plusieurs bibliothèques et outils permettant d'enrichir les capacités d'_EVE-NG_.

*Image virtuelle pour _EVE-NG_ :*

- *_vEOS-lab_* : image virtuelle d'_EOS_ distribuée par Arista, compatible avec le moteur _QEMU_ d'_EVE-NG_. Elle permet d'intégrer des _switches_/routeurs Arista réels dans les topologies _EVE-NG_ pour tester les configurations _EOS_ en lab.

*Bibliothèques et extensions _SDN_ :*

- *`eAPI`* : _API REST_ native d'_EOS_, exposée en _HTTP/HTTPS_ sur chaque équipement _Arista_. Elle permet d'envoyer des commandes _EOS_ et de récupérer l'état du réseau au format _JSON_, sans agent tiers.
- *_pyeapi_* : bibliothèque _Python_ cliente pour `eAPI`, simplifiant l'automatisation des équipements _Arista_ depuis des scripts _Python_ (requêtes, configuration, _parsing_ des résultats).
- *_Arista AVD (Ansible Validated Designs)_* : collection _Ansible_ complète fournissant des rôles et _playbooks_ pour concevoir, valider et déployer automatiquement des infrastructures réseau _Arista_. Publiée sur _Ansible Galaxy_ et _GitHub_.
- *_EOS SDK_* : _SDK_ _C++_ permettant de développer des agents personnalisés qui s'exécutent nativement sur _EOS_, avec accès direct aux tables de routage, aux interfaces et aux événements réseau.
- *_CloudVision (CVP)_* : plateforme centralisée de gestion et de télémétrie réseau, offrant du _streaming telemetry_ en temps réel et un contrôle de configuration réseau à grande échelle.

Source : #link("https://avd.arista.com/")[avd.arista.com - Arista AVD : https://avd.arista.com/] \
Source : #link("https://pyeapi.readthedocs.io/")[pyeapi.readthedocs.io - pyeapi documentation : https://pyeapi.readthedocs.io/] \

#pagebreak()

== Implémentation

La topologie réseau à implémenter est représentée par @eve_arch.

#figure(
  image("../asset/eve_arch.png", width: 100%),
  caption: [Topologie SDN déployée dans EVE-NG : 4 routeurs Arista vEOS (TLMRT1–4) interconnectés par 4 liens WAN, chaque routeur desservant un LAN avec 2 hôtes VPCS.],
)<eve_arch>

La topologie comporte quatre routeurs virtuels _Arista vEOS_ (TLMRT1 à TLMRT4), chacun connecté à un réseau local (LAN1–LAN4, sous-réseaux `192.168.1.0/24` à `192.168.4.0/24`). Chaque LAN héberge deux hôtes simulés par _VPCS_ (un _Client_ et un _Server_). Les routeurs sont reliés entre eux par quatre liens WAN point-à-point : WAN12, WAN13, WAN24 et WAN34. Le routage dynamique _OSPF_ (aire 0) est configuré sur toutes les interfaces pour assurer la connectivité inter-LAN.

=== Script de déploiement

L'ensemble du déploiement de la topologie est automatisé via le script `deploy_topology.py`. Son fonctionnement se décompose en trois phases.

*Phase 1 — Création du lab via l'API REST :*

Le script s'authentifie auprès d'_EVE-NG_ (`POST /api/auth/login`), supprime le lab existant si nécessaire, puis en crée un nouveau (`POST /api/labs`) pour obtenir un UUID unique. Ce lab est ensuite peuplé en construisant le fichier de topologie au format `.unl` (XML propriétaire d'_EVE-NG_) directement en mémoire.

*Phase 2 — Construction et écriture du fichier `.unl` :*

Le format `.unl` est un fichier _XML_ décrivant la totalité de la topologie : réseaux virtuels (_bridges_), nœuds et câblage des interfaces. Le script construit cet _XML_ en _Python_ via `xml.etree.ElementTree`, y intègre les 8 réseaux, les 4 nœuds _vEOS_ (type `qemu`, image `veos-4.36.0.1F`) et les 8 nœuds _VPCS_, avec leurs positions sur le _canvas_ et leur câblage aux réseaux correspondants.

Le fichier résultant est déposé directement sur le serveur _EVE-NG_ via _SFTP_ :

#sourcecode(```python
sftp.open(f"/opt/unetlab/labs/{LAB_NAME}.unl", "wb").write(xml_bytes)
```)

*Problème rencontré avec les réseaux :*

Une première approche consistait à créer les nœuds et les réseaux via les _endpoints_ _REST_ d'_EVE-NG_ (`POST /api/labs/{lab}/nodes`, `POST /api/labs/{lab}/networks`). Cependant, _EVE-NG CE_ ne dispose pas d'un _endpoint_ _REST_ permettant de câbler directement une interface d'un nœud à un réseau. Les connexions doivent être encodées dans le `.unl`. L'approche retenue est donc de construire l'intégralité du fichier `.unl` en _Python_ et de le pousser via _SFTP_, court-circuitant ainsi les limitations de l'_API REST_ pour le câblage.

*Phase 3 — Déploiement des configurations de démarrage :*

Les configurations initiales de chaque routeur (`startup-config` au format _EOS_) et de chaque hôte _VPCS_ (`startup.vpc`) sont générées dynamiquement depuis les données de `topology.py` et déposées via _SFTP_ dans les répertoires de nœuds d'_EVE-NG_ :

#sourcecode(```
/opt/unetlab/labs/{LAB_NAME}/{node_id}/startup-config   # pour chaque routeur vEOS
/opt/unetlab/labs/{LAB_NAME}/{node_id}/startup.vpc      # pour chaque hôte VPCS
```)

Le script se termine par une phase de vérification : il relit le `.unl` depuis le serveur et contrôle que chaque réseau, chaque routeur et chaque VPCS sont correctement câblés, en affichant le résultat pour chaque connexion.

== Script d'exécution

Le script `run_tests.py` orchestre le démarrage du lab et la validation de la connectivité. Une fois les nœuds démarrés, les hôtes _VPCS_ sont configurés avec leur adresse _IP_ et leur passerelle. Les pings *intra-LAN* (entre les deux hôtes d'un même _LAN_) sont concluants : 4/4 passent systématiquement, ce qui confirme que le câblage virtuel _EVE-NG_ est correct et que les nœuds _VPCS_ communiquent bien au niveau 2.

#sourcecode(```
[CONFIG] Configuring VPCS nodes...
  [OK] Client1: 192.168.1.101/24 gw 192.168.1.1
  [OK] Server1: 192.168.1.11/24  gw 192.168.1.1
  [OK] Client2: 192.168.2.101/24 gw 192.168.2.1
  [OK] Server2: 192.168.2.11/24  gw 192.168.2.1
  [OK] Client3: 192.168.3.101/24 gw 192.168.3.1
  [OK] Server3: 192.168.3.11/24  gw 192.168.3.1
  [OK] Client4: 192.168.4.101/24 gw 192.168.4.1
  [OK] Server4: 192.168.4.11/24  gw 192.168.4.1

[TEST] Same-LAN pings
  [PASS] Client1 → Server1
  [PASS] Client2 → Server2
  [PASS] Client3 → Server3
  [PASS] Client4 → Server4

4/4 passed
```)

#pagebreak()

Les routeurs _vEOS_ démarrent également : leurs sorties console sont visibles dans les _logs_, et chacun atteint le _prompt_ `login:` après environ 3 500 secondes (émulation _TCG_, sans _KVM_). Cependant, nous n'arrivons pas à obtenir de convergence _OSPF_, et les pings *inter-LAN* échouent systématiquement : 0/12.

#sourcecode(```
[CONFIG] Booting and configuring vEOS routers via telnet (parallel)...
    [TLMRT1] waiting for login prompt (up to 7200s)...
    [TLMRT1] still booting... (30s)
    [TLMRT1] | Welcome to Arista Networks EOS 4.36.0.1F
    ...
    [TLMRT4] still booting... (3499s)
    [TLMRT4] | Flash Memory size:  3.9G
    [TLMRT4] ready (3527s)

[WAIT] Polling for gateway IPs (up to 1800s)...
  [  25s] 0/8 gateways up
  [  80s] 0/8 gateways up
  ...
  [1791s] 0/8 gateways up
[WARN] Only 0/8 gateways responded — agents may not have started

[TEST] Cross-LAN pings
  [FAIL] Client1 → Server2
  [FAIL] Client1 → Server3
  [FAIL] Client1 → Server4
  [FAIL] Client2 → Server3
  [FAIL] Client2 → Server4
  [FAIL] Client3 → Server4
  [FAIL] Server1 → Client2
  [FAIL] Server1 → Client3
  [FAIL] Server1 → Client4
  [FAIL] Server2 → Client3
  [FAIL] Server2 → Client4
  [FAIL] Server3 → Client4

0/12 passed
```)

Les tentatives effectuées pour débloquer la situation sont les suivantes :

- *Injection de la `startup-config` via `qemu-nbd`* : avant de démarrer les nœuds, le script montait le disque _QCOW2_ de chaque routeur via `qemu-nbd` et écrivait le fichier `startup-config` directement sur la partition _flash_ (partition 2, _ext4_). Le fichier était bien présent sur le disque (vérifié par remontage), mais les interfaces ne se levaient jamais après le _boot_ : _ConfigAgent_ ne semblait pas appliquer la configuration dans le délai observé.

- *Suppression des pokes _ESC_* : les envois périodiques du caractère _ESC_ (`\x1b`) sur le port _Telnet_, destinés à accélérer le _boot_ en sautant l'initialisation _EOS_, annulaient en réalité le processus `Aaa.sh` qui attendait le démarrage des agents (`wfw`). Retirer l'_ESC_ a permis aux agents de démarrer correctement, mais n'a pas résolu le problème de configuration.

- *Augmentation du _timeout_ de login* : le délai d'attente du _prompt_ `login:` a été porté de 3 600 s à 7 200 s, car `wfw` s'exécute pendant 3 600 s à partir d'environ 400 s après le démarrage, reportant le `login:` effectif à ~4 000 s. Cette correction a permis au script de ne plus _timeout_ avant le _prompt_, mais n'a pas amélioré la configuration réseau.

- *_Keepalive_ de la session _EVE-NG_* : pendant la fenêtre de _polling_ des passerelles (jusqu'à 30 minutes), aucun appel à l'_API REST_ n'était effectué. Un _cron_ interne d'_EVE-NG_ nettoyant les sessions _PHP_ toutes les 30 minutes pouvait expirer la session et arrêter les nœuds silencieusement. Un appel périodique à `GET /api/labs/{lab}/nodes` toutes les 60 secondes a été ajouté pour maintenir la session active.

- *Configuration directe via _Telnet CLI_* : plutôt que de dépendre de _ConfigAgent_, le script se connecte en `admin` sur le port _Telnet_ de chaque routeur après le `login:`, entre en mode configuration (`configure terminal`) et pousse les commandes d'interface et _OSPF_ directement. Cette approche contourne entièrement le mécanisme de `startup-config`.

Malgré l'ensemble de ces tentatives, nous ne sommes pas parvenus à obtenir une convergence _OSPF_ ni des pings inter-LAN fonctionnels (0/12).

== Code source

=== `topology.py`

#sourcecode(```py
VEOS_QEMU = (
    "-machine type=pc-1.0,accel=tcg -serial mon:stdio -nographic "
    "-display none -no-user-config -rtc base=utc -boot order=d -cpu Haswell"
)

ROUTERS = [
    {"name": "TLMRT1", "left": 600, "top": 400},
    {"name": "TLMRT2", "left": 200, "top": 400},
    {"name": "TLMRT3", "left": 600, "top": 150},
    {"name": "TLMRT4", "left": 200, "top": 150},
]

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

ROUTER_IFACE_CONFIGS = {
    "TLMRT1": [("Ethernet1", "192.168.1.1/24"),  ("Ethernet2", "192.168.12.1/24"), ("Ethernet3", "192.168.13.1/24")],
    "TLMRT2": [("Ethernet1", "192.168.2.1/24"),  ("Ethernet2", "192.168.12.2/24"), ("Ethernet3", "192.168.24.2/24")],
    "TLMRT3": [("Ethernet1", "192.168.3.1/24"),  ("Ethernet2", "192.168.34.3/24"), ("Ethernet3", "192.168.13.3/24")],
    "TLMRT4": [("Ethernet1", "192.168.4.1/24"),  ("Ethernet2", "192.168.34.4/24"), ("Ethernet3", "192.168.24.4/24")],
}

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

VPCS_IPS = {name: cidr.split("/")[0] for name, (cidr, _) in VPCS_IP_CONFIGS.items()}

SAME_LAN_PAIRS = [
    ("Client1", "Server1"),
    ("Client2", "Server2"),
    ("Client3", "Server3"),
    ("Client4", "Server4"),
]

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
```)

#pagebreak()

=== `deploy_topology.py`

#sourcecode(```py
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

# ----- Topology (edit topology.py to change names, IPs, or canvas positions)

from topology import (VEOS_QEMU, ROUTERS, ROUTER_CONNECTIONS, NETWORKS,
                      VPCS_NODES, ROUTER_IFACE_CONFIGS, VPCS_IP_CONFIGS)

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
```)

=== `run_topology.py`

#sourcecode(```py
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
```)
