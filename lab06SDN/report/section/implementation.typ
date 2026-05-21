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

La procédure ci-dessous est détaillée pour un environnement `Arch Linux OS`.

Installer `VirtualBox` (#link("https://wiki.archlinux.org/title/VirtualBox")[https://wiki.archlinux.org/title/VirtualBox]):

#sourcecode(```sh
yay -S virtualbox
```)

Télécharger #link("https://www.eve-ng.net/index.php/download/#DL-COMM")[_Free EVE Community Edition Version 6.2.0-4_].

Créer une nouvelle VM (`machine` → `New`, `Ctrl + n`) avec les paramètres suivants, puis cliquer sur `Finish` :

- _Virtual machine name and operating system_ :
  - `VM Name` : `EVE-NG`
  - `ISO Image` : `/path/to/image/eve-ce-prod-6.2.0-4-full.iso`
  - `OS` : `Linux`
- _Specify virtual hardware_
  - `Base Memory` : `8000 MB`
  - `CPU` : `4`
- _Specify virtual hard disk_
  - `Disk Size` : `50 GB`

Dans `Settings` (mode `Expert`) → `Network`, passer l'`Adapter 1` en `Bridged Adapter`. Laisser les autres paramètres par défaut.

Au premier démarrage, suivre l'installation de `EVE-NG Community 6.2.0-4` (langue et clavier). Une fois terminée, la _VM_ retourne sur _GRUB_ : retirer le disque via `Device` → `Optical Device` → `Remove Disk From Virtual Device`, puis éteindre la machine (`Power off the machine`). Au redémarrage, se connecter avec :

- Nom d'utilisateur : `root`
- Mot de passe : `eve`

Conserver les valeurs par défaut pour les configurations suivantes. La machine redémarre ; se reconnecter avec les mêmes identifiants. L'_URL_ de l'interface web est affichée dans la console (`http://192.168.1.113` dans notre cas). Se connecter avec les identifiants suivant :

- Nom d'utilisateur : `admin`
- Mot de passe : `eve`

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

== Analyse de l'environnement EVE

#qbox(
  [Take a look at the tools and configurations made available by the program.],
)

_EVE-NG_ (_Emulated Virtual Environment_) expose une interface web permettant de concevoir, démarrer et superviser des topologies réseau entièrement depuis un navigateur.

*Outils principaux :*

- *_Topology Editor_* : éditeur graphique drag-and-drop pour créer des topologies réseau. Permet d'ajouter des nœuds, de les relier par des liens virtuels et d'exporter/importer des labs au format `.unl`.
- *Console d'accès* : accès aux nœuds via Telnet, SSH ou VNC selon le type d'équipement (IOL, QEMU, Docker).
- *Capture de paquets* : capture intégrée sur n'importe quel lien de la topologie, avec ouverture directe dans Wireshark sur la machine cliente.
- *Gestion des labs* : création, sauvegarde et partage de labs sous forme d'archives ZIP.

*Configurations disponibles :*

- *Templates de nœuds* : modèles préconfigurés pour une multitude de constructeurs (Cisco, Juniper, Arista, Palo Alto, Fortinet, etc.). Chaque template définit le type d'hyperviseur, le nombre d'interfaces, la RAM et le CPU alloués.
- *Types de réseaux* : réseau de management (`Cloud0`), bridges internes (`Net`) et connexions vers le réseau hôte (`Cloud1`–`Cloud9`).
- *Configurations de démarrage* : possibilité de pré-charger une configuration initiale sur chaque nœud avant le démarrage du lab.
- *Gestion des utilisateurs* : comptes utilisateurs avec rôles (administrateur, étudiant) et accès simultanés aux labs en édition Pro.

Source : #link("https://www.eve-ng.net/index.php/documentation/")[eve-ng.net - Documentation officielle EVE-NG : https://www.eve-ng.net/index.php/documentation/]

#qbox(
  [Please check the infrastructure and librairies made available by EVE.],
)

EVE-NG s'appuie sur un socle Linux (Ubuntu Server 22.04 LTS) et tire parti de plusieurs technologies de virtualisation pour émuler des équipements réseau hétérogènes.

*Infrastructure :*

- *KVM/QEMU* : hyperviseur principal utilisé pour exécuter les images QEMU des équipements réseau (routeurs, firewalls, switches). Chaque nœud tourne dans une VM légère.
- *IOL (IOS on Linux)* : permet de faire tourner certaines images Cisco IOS directement comme des processus Linux, sans virtualisation complète, ce qui réduit la consommation de ressources.
- *Docker* : support des conteneurs pour des nœuds légers (serveurs Linux, outils de test réseau).
- *Linux bridges / veth / tap* : interconnexion des nœuds via des interfaces réseau virtuelles du noyau Linux.
- *UKSM (Ultra Kernel Samepage Merging)* : mécanisme de déduplication mémoire qui fusionne les pages RAM identiques entre VMs, réduisant considérablement la RAM consommée lorsque plusieurs instances du même OS tournent simultanément (disponible en édition Pro).

*API et bibliothèques :*

- *EVE-NG REST API* : API HTTP complète pour piloter EVE-NG par programmation (gestion des labs, démarrage/arrêt des nœuds, configuration des topologies). Les principaux endpoints sont `/api/labs`, `/api/nodes`, `/api/networks` et `/api/topologies`.
- *peve* : bibliothèque Python communautaire encapsulant l'API REST d'EVE-NG, facilitant l'automatisation des labs depuis des scripts Python.

Source : #link("https://www.eve-ng.net/index.php/documentation/howtos/how-to-eve-ng-api/")[eve-ng.net - EVE-NG REST API : https://www.eve-ng.net/index.php/documentation/howtos/how-to-eve-ng-api/]

#qbox(
  [Please check the website of ARISTA, a provider of SDN solutions. Try looking for libraries and extensions that will allow enriching the palette offered by natively by EVE.],
)

Arista Networks est un fournisseur de solutions SDN dont le système d'exploitation *EOS (Extensible Operating System)* est conçu pour être entièrement programmable. Arista propose plusieurs bibliothèques et outils permettant d'enrichir les capacités d'EVE-NG.

*Image virtuelle pour EVE-NG :*

- *vEOS-lab* : image virtuelle d'EOS distribuée par Arista, compatible avec le moteur QEMU d'EVE-NG. Elle permet d'intégrer des switches/routeurs Arista réels dans les topologies EVE-NG pour tester les configurations EOS en lab.

*Bibliothèques et extensions SDN :*

- *eAPI* : API REST native d'EOS, exposée en HTTP/HTTPS sur chaque équipement Arista. Elle permet d'envoyer des commandes EOS et de récupérer l'état du réseau au format JSON, sans agent tiers.
- *pyeapi* : bibliothèque Python cliente pour eAPI, simplifiant l'automatisation des équipements Arista depuis des scripts Python (requêtes, configuration, parsing des résultats).
- *Arista AVD (Ansible Validated Designs)* : collection Ansible complète fournissant des rôles et playbooks pour concevoir, valider et déployer automatiquement des infrastructures réseau Arista (notamment des fabrics EVPN/VXLAN). Publiée sur Ansible Galaxy et GitHub.
- *EOS SDK* : SDK C++ permettant de développer des agents personnalisés qui s'exécutent nativement sur EOS, avec accès direct aux tables de routage, aux interfaces et aux événements réseau.
- *CloudVision (CVP)* : plateforme centralisée de gestion et de télémétrie réseau, offrant du streaming telemetry en temps réel et un contrôle de configuration réseau à grande échelle.

Source : #link("https://avd.arista.com/")[avd.arista.com - Arista AVD : https://avd.arista.com/] \
Source : #link("https://pyeapi.readthedocs.io/")[pyeapi.readthedocs.io - pyeapi documentation : https://pyeapi.readthedocs.io/] \
Source : #link("https://arista.com/en/support/product-documentation/eos-sdk")[arista.com - EOS SDK : https://arista.com/en/support/product-documentation/eos-sdk]

== Implement the architecture

La topologie réseau à implémenter est représentée par @eve_arch.

#figure(
  image("../asset/eve_arch.png", width: 100%),
  caption: [TODO],
)<eve_arch>

TODO
