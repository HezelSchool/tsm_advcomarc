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

#import "../helper.typ": qbox

// ---------- Implementation

== Étape 0 : Connexion à RouterOS avec Winbox

=== Installation de Winbox

#qbox(
    [Télécharger Winbox depuis le site officiel MikroTik : https://mikrotik.com/download/ winbox]
)

Nous installons l'exécutable `WinBox` (`v4.0.1 Windows 64-bit`) sur un hôte Windows (`Microsoft Windows 11 Home 10.0.26200 Build 26200`). L'exécutable est téléchargé depuis le #link("https://mikrotik.com/download/winbox")[le site officiel de `MikroTik`: https://mikrotik.com/download/winbox].

#qbox(
    [Pour Windows : exécuter directement l’application]
)

Une fois l'application téléchargée et extraite, nous pouvons l'exécuter directement en double-cliquant sur l'exécutable `WinBox.exe`. La fenêtre de connexion ci-dessous s'affiche.

#image("../asset/winbox_launch_window.png", width: 100%)

=== Première connexion

#qbox(
    [Connecter le câble Ethernet entre votre ordinateur et le port Ethernet de l’AP MikroTik]
)

Un câble Ethernet est connecté sur le port Ethernet `1` de l'AP MikroTik et sur le port Ethernet de l'hôte Windows.

#qbox(
    [Lancer Winbox, cliquer sur l’onglet « Neighbors » pour découvrir l’appareil puis sélectionner l’appareil détecté (connexion par adresse MAC recommandée). Les identifiants par défaut sont `Username` : `admin` et `Password` : (vide). Finalement cliquer sur « Connect ».]
)

Lors de la première tentative de connexion, le message d'erreur `username or password wrong` s'affiche. Cela est probablement dû au fait que l'AP n'a pas été réinitialisé après une utilisation précédente. Pour réinitialiser l'AP, nous avons suivi les étapes ci-dessous :

1. Débrancher l'alimentation de l'AP.
2. Maintenir le bouton de réinitialisation enfoncé.
3. Rebrancher l'alimentation tout en maintenant le bouton de réinitialisation enfoncé jusqu'à ce que les LED clignotent.
4. Relâcher le bouton de réinitialisation.

La procédure de réinitialisation est disponible dans la documentation officielle de MikroTik : #link("https://help.mikrotik.com/docs/spaces/ROS/pages/24805498/RouterOS+configuration+reset")[MikroTik RouterOS configuration reset: https://help.mikrotik.com/docs/spaces/ROS/pages/24805498/RouterOS+configuration+reset].

Une fois l'AP réinitialisé, nous avons constaté qu'un _neighbor_ supplémentaire est détecté. En réalité, il s'agit du même AP (confirmé par l'adresse MAC identique sur les deux entrées) disponible sur la même interface Ethernet mais pour deux protocole différents : `IPv4` (`192.168.88.1`) et `IPv6` (`fe80::d601:c3ff:fefa:9a38`).

#image("../asset/additional_neighbor.png", width: 100%)

Lors de la connexion, nous configurons le mot de passe de l'utilisateur `admin` en `1234`.

=== Réinitialisation en cas de problème

Voir la section précédente pour la procédure de réinitialisation de l'AP.

=== Interface Winbox

Une fois connecté à l'AP, nous avons accès à l'interface graphique de configuration de RouterOS. Cette interface est divisée en plusieurs sections, notamment :

- *Interfaces* : Configuration des interfaces réseau et WiFi

#image("../asset/first_connect_interfaces.png", width: 100%)

- *Wireless* : Paramètres WiFi (SSID, sécurité, canaux)

#image("../asset/first_connect_wireless.png", width: 100%)

- *IP* : Configuration IP, DHCP, routes, firewall

#image("../asset/first_connect_ip.png", width: 100%)

- *System* : Informations système, utilisateurs, logs

#image("../asset/first_connect_system.png", width: 100%)

- *Tools* : Outils de diagnostic (ping, traceroute, sniffer)

#image("../asset/first_connect_tools.png", width: 100%)

- *Files* : Gestionnaire de fichiers

#image("../asset/first_connect_files.png", width: 100%)

== Étape 1 : Création d’un WLAN sur l’AP

=== Schéma réseau cible

#qbox(
    [Vous allez créer le réseau selon la figure 1. Afin de configurer proprement le point d’accès, voici le lien vers ladocumentation officielle : https://help.mikrotik.com/docs/display/ROS/Getting+started]
)

Le réseau à créer est présenté dans la figure ci-dessous.

#image("../asset/network_to_create.png", width: 100%)

1. Configuration IP/masque de sous-réseau sur le port Ethernet `1`

Cliquer sur le sous-menu `IP > Addresses` puis sur le bouton `New` pour ajouter une nouvelle adresse IP (`10.0.0.254`) et son masque de sous-réseau à l'interface `ether1`. Cliquer sur le bouton `Apply`.

#image("../asset/configure_ip.png", width: 100%) TODO

La nouvelle adresse IP est affichée dans la liste des adresses IP configurées.

#image("../asset/configured_ip.png", width: 100%) TODO

2. Création et configuration de la _Gateway_ par défaut

Cliquer sur le sous-menu `IP > Routes` puis sur le bouton `New` pour ajouter une nouvelle route par défaut (`10.0.0.1`) via l'interface `ether1`. Remplir les champs `Gateway` avec l'adresse IP `10.0.0.1` et `Distance` avec la valeur `1`. Cliquer sur le bouton `Apply`.

#image("../asset/configure_gateway.png", width: 100%) TODO

La nouvelle `Gateway` est affichée dans la liste des routes configurées.

#image("../asset/configured_gateway.png", width: 100%) TODO

3. Activation du _WiFi_

Premièrement, cliquer sur le sous-menu `System > Packages` pour activer le `package` `wifi-qcom`. Cliquer sur le bouton `Enable` puis sur le bouton `Apply Changes`. L'AP va redémarrer pour appliquer les changements. Une fois l'AP redémarré, deux entrées supplémentaires sont affichées dans la section `Wifi` et le `package` `wifi-qcom` est affiché comme étant `enabled` dans la section `System > Packages`.

#image("../asset/enable_wifi_package.png", width: 100%) TODO

4. Création et configuration du _Bridge_

Cliquer sur le sous-menu `Bridge` puis sur le bouton `New` pour ajouter un nouveau _bridge_.

#image("../asset/configure_bridge.png", width: 100%) TODO

Dans l'onglet `Ports`, cliquer sur le bouton `Add` et ajouter les interfaces `ether2` à `ether5` ainsi que les wifi `wifi1` et `wifi2` au _bridge_. Pour chaque interface ajoutée, cliquer sur le bouton `Apply` puis sur le bouton `OK`. La liste des ports du _bridge_ doit ressembler à l'image ci-dessous une fois la configuration terminée.

#image("../asset/configured_bridge.png", width: 100%) TODO

Finalement, cliquer sur le sous-menu `IP > Addresses` puis sur le bouton `New` pour configurer la nouvelle adresse IP du _bridge_ (`192.168.1.1/24`). Sauvegarder la configuration en cliquant sur le bouton `Apply` puis sur le bouton `OK`.

#image("../asset/configured_bridge_ip.png", width: 100%) TODO

L'adresse IP du _bridge_ est affichée dans la liste des adresses IP configurées. On remarque que cette configuration crée ainsi un réseau local `192.168.1.0`.

#image ("../asset/configured_bridge_ip_list.png", width: 100%)

5. Création et configuration du service `DHCP`

Afin d'attribuer automatiquement les adresses IP aux clients connectés au réseau local, nous configurons le service `DHCP` sur l'AP. Cliquer sur le sous-menu `IP > DHCP Server` puis sur le bouton `New`. Nous gardons les paramètres par défaut et changeons uniquement le champ `interface` en sélectionnant `bridge1`. Cliquer sur le bouton `Apply` puis sur le bouton `OK`.

#image("../asset/configure_dhcp.png", width: 100%) TODO

Le service `DHCP` est affiché dans la liste des serveurs `DHCP` configurés.

#image("../asset/configured_dhcp.png", width: 100%) TODO

Dans l'onglet `Networks`, cliquer sur le bouton `New` pour associer le réseau `192.168.1.0/24/` à la _default gateway_ `192.168.1.1` et au serveur `DNS` de Google (`8.8.8.8`). Cette configuration permet aux clients connectés d'obtenir automatiquement les paramètres réseau nécessaires pour accéder à Internet. Cliquer sur le bouton `Apply` puis sur le bouton `OK`.

#image("../asset/configure_dhcp_network.png", width: 100%) TODO

La configuration réseau est affichée dans la liste des réseaux `DHCP` configurés.

#image("../asset/configured_dhcp_network.png", width: 100%) TODO

6. Création et configuration du `NAT`

Cliquer sur le sous-menu `IP > Firewall > NAT` puis sur le bouton `New` pour ajouter une règle de _port forwarding_ qui permet aux clients du réseau local de traduire leur adresse IP privée (du réseau local `192.168.1.0/24`) en adresse IP publique. Sélectionner `ether1` comme interface de sortie et `masquerade` comme `Action` ; garder les autres paramètres par défaut. Cliquer sur le bouton `Apply` puis sur le bouton `OK`.

#image("../asset/configure_nat.png", width: 100%) TODO

La règle de `NAT` est affichée dans la liste des règles de `NAT` configurées.

#image("../asset/configured_nat.png", width: 100%) TODO

7. Configuration de `wifi1`



== Étape 2 : Capture du 4-way handshake

TODO

== Étape 3 : Exporter votre configuration

TODO

=== Export via Terminal

TODO

=== Téléchargement du fichier de configuration

TODO

== Questions

=== Question 1

TODO

=== Question 2

TODO

=== Question 3

TODO

=== Question 4

TODO

=== Question 5

TODO

