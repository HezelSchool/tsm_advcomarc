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

#pagebreak()

=== Première connexion

#qbox(
    [Connecter le câble Ethernet entre votre ordinateur et le port Ethernet de l’AP MikroTik]
)

Un câble Ethernet est connecté sur le port Ethernet `ether3` de l'AP MikroTik et sur le port Ethernet de l'hôte Windows.

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

#pagebreak()

=== Interface Winbox

Une fois connecté à l'AP, nous avons accès à l'interface graphique de configuration de RouterOS. Cette interface est divisée en plusieurs sections, notamment :

- *Interfaces* : Configuration des interfaces réseau et WiFi

#image("../asset/first_connect_interfaces.png", width: 100%)

- *Wireless* : Paramètres WiFi (SSID, sécurité, canaux)

#image("../asset/first_connect_wireless.png", width: 100%)

#pagebreak()

- *IP* : Configuration IP, DHCP, routes, firewall

#align(center, image("../asset/first_connect_ip.png", width: 60%))

- *System* : Informations système, utilisateurs, logs

#image("../asset/first_connect_system.png", width: 100%)

#pagebreak()

- *Tools* : Outils de diagnostic (ping, traceroute, sniffer)

#image("../asset/first_connect_tools.png", width: 100%)

- *Files* : Gestionnaire de fichiers

#image("../asset/first_connect_files.png", width: 100%)

#pagebreak()

== Étape 1 : Création d’un WLAN sur l’AP

=== Schéma réseau cible

#qbox(
    [Vous allez créer le réseau selon la figure 1. Afin de configurer proprement le point d’accès, voici le lien vers la documentation officielle : https://help.mikrotik.com/docs/display/ROS/Getting+started]
)

Le réseau à créer est présenté dans la figure ci-dessous.

#image("../asset/network_to_create.png", width: 100%)

1. *Configuration IP/masque de sous-réseau sur le port Ethernet `1`*

Cliquer sur le sous-menu `IP > Addresses` puis sur le bouton `New` pour ajouter une nouvelle adresse IP (`10.0.0.254`) et son masque de sous-réseau à l'interface `ether1`. Cliquer sur le bouton `Apply`.

#align(center, image("../asset/configure_eth1_ip_addr_submask.png", width: 80%))

La nouvelle adresse IP est affichée dans la liste des adresses IP configurées.

#align(center, image("../asset/new_address_eth1.png", width: 60%))

2. *Création et configuration de la _Gateway_ par défaut*

Cliquer sur le sous-menu `IP > Routes` puis sur le bouton `New` pour ajouter une nouvelle route par défaut (`10.0.0.1`) via l'interface `ether1`. Remplir les champs `Gateway` avec l'adresse IP `10.0.0.1` et `Distance` avec la valeur `1`. Cliquer sur le bouton `Apply`.

#image("../asset/configure_gateway.png", width: 100%)

La nouvelle `Gateway` est affichée dans la liste des routes configurées.

#image("../asset/new_gateway.png", width: 100%)

#pagebreak()

3. *Activation du _WiFi_*

Premièrement, cliquer sur le sous-menu `System > Packages` pour activer le `package` `wifi-qcom`. Cliquer sur le bouton `Enable` puis sur le bouton `Apply Changes`.

#image("../asset/enable_wifi-qcom.png", width: 100%)

L'AP va redémarrer pour appliquer les changements. Une fois l'AP redémarré, deux entrées supplémentaires sont affichées dans la section `Wifi` et le `package` `wifi-qcom` est affiché comme étant `enabled` dans la section `System > Packages`.

#image("../asset/wifi_ok.png", width: 100%)

#pagebreak()

4. *Création et configuration du _Bridge_*

Cliquer sur le sous-menu `Bridge` puis sur le bouton `New` pour ajouter un nouveau _bridge_.

#align(center, image("../asset/create_bridge.png", width: 80%))

Dans l'onglet `Ports`, cliquer sur le bouton `Add` et ajouter les interfaces `ether2` à `ether5` ainsi que les wifi `wifi1` et `wifi2` au _bridge_. Pour chaque interface ajoutée, cliquer sur le bouton `Apply` puis sur le bouton `OK`.

#align(center, image("../asset/add_eth2_to_bridge.png", width: 100%))

#pagebreak()

La liste des ports du _bridge_ doit ressembler à l'image ci-dessous une fois la configuration terminée.

#align(center, image("../asset/bridge_all_ports.png", width: 100%))

Finalement, cliquer sur le sous-menu `IP > Addresses` puis sur le bouton `New` pour configurer la nouvelle adresse IP du _bridge_ (`192.168.1.1/24`). Sauvegarder la configuration en cliquant sur le bouton `Apply` puis sur le bouton `OK`.

#align(center, image("../asset/configure_bridge_ip_addr.png", width: 80%))

L'adresse IP du _bridge_ est affichée dans la liste des adresses IP configurées. On remarque que cette configuration crée ainsi un réseau local `192.168.1.0`.

#align(center, image("../asset/listed_bridge.png", width: 70%))

#pagebreak()

5. *Création et configuration du service `DHCP`*

Afin d'attribuer automatiquement les adresses IP aux clients connectés au réseau local, nous configurons le service `DHCP` sur l'AP. Cliquer sur le sous-menu `IP > DHCP Server` puis sur le bouton `New`. Nous gardons les paramètres par défaut et changeons uniquement le champ `interface` en sélectionnant `bridge1`. Cliquer sur le bouton `Apply` puis sur le bouton `OK`.

#image("../asset/create_dhcp.png", width: 100%)

Le service `DHCP` est affiché dans la liste des serveurs `DHCP` configurés.

#image("../asset/listed_dhcp.png", width: 100%)

#pagebreak()

Dans l'onglet `Networks`, cliquer sur le bouton `New` pour associer le réseau `192.168.1.0/24/` à la _default gateway_ `192.168.1.1` et au serveur `DNS` de Google (`8.8.8.8`). Cette configuration permet aux clients connectés d'obtenir automatiquement les paramètres réseau nécessaires pour accéder à Internet. Cliquer sur le bouton `Apply` puis sur le bouton `OK`.

#image("../asset/configure_dhcp_network.png", width: 100%)

La configuration réseau est affichée dans la liste des réseaux `DHCP` configurés.

#image("../asset/listed_dhcp_network.png", width: 100%)

#pagebreak()

6. *Création et configuration du `NAT`*

Cliquer sur le sous-menu `IP > Firewall > NAT` puis sur le bouton `New` pour ajouter une règle de _port forwarding_ qui permet aux clients du réseau local de traduire leur adresse IP privée (du réseau local `192.168.1.0/24`) en adresse IP publique. Sélectionner `ether1` comme interface de sortie et `masquerade` comme `Action` ; garder les autres paramètres par défaut. Cliquer sur le bouton `Apply` puis sur le bouton `OK`.

#image("../asset/configure_nat.png", width: 100%)

La règle de `NAT` est affichée dans la liste des règles de `NAT` configurées.

#image("../asset/listed_nat.png", width: 100%)

#pagebreak()

7. *Configuration de `wifi1`*

Dans le sous-menu `WiFi`, double-cliquer sur l'interface `wifi1` pour accéder à sa configuration. Dans l'onglet `Configuration`, attribuer la valeur `MyWifi` au champ `SSID`.

#image("../asset/wifi1_ssid.png", width: 100%)

Puis dans l'onglet `Security`, appuyer sur le bouton adjacent au champ `Authentication Types` et sélectionner les protocoles `WPA2-PSK` et `WPA3-PSK`. Ajouter un mot de passe dans le champ `Passphrase` (ici `MyWifiPassword`). Cliquer sur le bouton `Apply` puis sur le bouton `OK` pour valider la configuration.

#align(center, image("../asset/wifi_security.png", width: 90%))

9. *Connexion à Internet*

D'un point de vue physique, l'AP est connecté à Internet (via mon routeur personnel) via l'interface `2.5G` et connecter à un hôte Windows via l'interface `ether3`.

Sur le laptop (`Arch OS`), nous pouvons afficher les réseaux WiFi disponibles et constater que le réseau `MyWifi` est bien détecté.

#sourcecode(```bash
nmcli device wifi list
# Output
IN-USE  BSSID              SSID                     MODE   CHAN  RATE           SECURITY
        D4:01:C3:FA:9A:3D  MyWifi                   Infra  136   1170 Mbit/s    WPA2 WPA3
*       A4:CE:DA:97:BF:10  eef-35723                Infra  100   540 Mbit/s     WPA2 WPA3
        A0:B5:49:8C:48:10  WN-8C4810                Infra  100   540 Mbit/s     WPA2
        50:E0:39:68:2F:22  Sunrise_Wi-Fi_682F21     Infra  36    540 Mbit/s     WPA2 WPA3
        82:E0:39:68:2F:25  --                       Infra  36    540 Mbit/s     WPA2
        82:E0:39:68:2F:27  --                       Infra  36    540 Mbit/s     WPA2
        CC:D4:2E:49:50:58  Salt_2GHz_0FC479_2.4GHz  Infra  52    1170 Mbit/s    WPA2
```)

Malheureusement, la première tentative de connexion au réseau `MyWifi` échoue.

#sourcecode(```bash
nmcli device wifi connect MyWifi password "MyWifiPassword"
# Output
Error: Connection activation failed: IP configuration could not be reserved (no available address, timeout, etc.).
```)

Après avoir vérifié chaque étape présentée ci-dessus, nous avons constaté que le problème venait de la configuration du serveur `DHCP`. En effet, le champ `Address Pool` était configuré avec la valeur `static - only`. Cette configuration empêche le serveur `DHCP` d'attribuer des adresses IP dynamiques aux clients connectés. Pour résoudre ce problème, nous avons changé la valeur du champ `Address Pool` en `dhcp_pool0`. Pour obtenir cette configuration, nous avons dû recréer le serveur `DHCP` en passant par l'action `DHCP Setup` au lieu du bouton `New`.

#image("../asset/correct_dhcp.png", width: 100%)

Après avoir appliqué les changements, nous avons pu nous connecter au réseau `MyWifi` et `ping` l'adresse `google.com` pour vérifier la connectivité.

#sourcecode(```bash
nmcli device wifi connect MyWifi password "MyWifiPassword"
# Output
Device 'wlp97s0' successfully activated with '1c468c4d-2edd-4dfd-a325-9e4416a8a7f8'.

ping google.com
# Output
PING google.com (2a00:1450:400a:1009::65) 56 data bytes
64 bytes from ii-in-f101.1e100.net (2a00:1450:400a:1009::65): icmp_seq=1 ttl=113 time=9.56 ms
64 bytes from ii-in-f101.1e100.net (2a00:1450:400a:1009::65): icmp_seq=2 ttl=113 time=10.4 ms
64 bytes from ii-in-f101.1e100.net (2a00:1450:400a:1009::65): icmp_seq=3 ttl=113 time=18.9 ms
64 bytes from ii-in-f101.1e100.net (2a00:1450:400a:1009::65): icmp_seq=4 ttl=113 time=8.59 ms
```)

#pagebreak()

== Étape 2 : Capture du 4-way handshake

#qbox(
    [Pour cette étape, capturez les différents échanges entre l’AP/serveur et un hôte. Enregistrez-les dans un fichier pcap. Pour cela, il est recommandé d’utiliser aircrack-ng, wireshark ou à l’aide de l’outil dans Router OS (Tools-> Packet sniffer).]
)

Nous avons d'abord essayé de capturer le _4-way handshake_ entre l'AP et le _laptop_ `Arch OS` à l'aide des outils `Wireshark` (sur le _laptop_) et/ou du _packet sniffer_ de l'AP. À chaque tentative, nous n'avons pas réussi à obtenir les paquets du _4-way handshake_ (en filtrant sur le protocol `eapol`).

Nous soupconnons que le problème vient du fait que la carte WiFi du _laptop_ et celle de l'AP ne sont pas capable de communiquer en mode _monitor_. Nous avons donc utilisé l'outil `aircrack-ng` depuis le _laptop_ `Arch OS` pour capturer le _4-way handshake_ entre l'AP et un smartphone `Android`.

1. *Passer la carte _WiFi_ en mode _monitor_*

Identifier l'interface _WiFi_ du _laptop_. Dans notre cas, il s'agit de l'interface `wlp97s0`.

#sourcecode(```sh
iw dev
# Output
phy#0
	Unnamed/non-netdev interface
		wdev 0x2
		addr 2c:98:11:78:e8:ed
		type P2P-device
		txpower 3.00 dBm
	Interface wlp97s0
		ifindex 2
		wdev 0x1
		addr 2c:98:11:78:e8:ed
		ssid HezelPhone
		type managed
		channel 153 (5765 MHz), width: 40 MHz, center1: 5755 MHz
		txpower 3.00 dBm
		multicast TXQ:
			qsz-byt	qsz-pkt	flows	drops	marks	overlmt	hashcol	tx-bytes	tx-packets
			0	0	0	0	0	0	0	0		0
```)

Pour éviter de potentiels interférences, désactiver l'application `NetworkManager` qui gère les connexions réseau sur le _laptop_.

#sourcecode(```sh
sudo systemctl stop NetworkManager
```)

Activer le mode _monitor_ sur l'interface `wlp97s0`. L'_output_ de cette commande indique les programmes pouvant interférer dans notre processus. Cette action "crée" une nouvelle interface `wlp97s0mon` pour le _monitoring_.

#sourcecode(```sh
sudo airmon-ng start wlp97s0
# Output
PHY	Interface	Driver		Chipset

phy0	wlp97s0		mt7921e		MEDIATEK Corp. MT7922 802.11ax PCI Express Wireless Network Adapter
		(mac80211 monitor mode vif enabled for [phy0]wlp97s0 on [phy0]wlp97s0mon)
		(mac80211 station mode vif disabled for [phy0]wlp97s0)
```)

Vérifier la création de l'interface de _monitoring_ `wlp97s0mon`. On peut voir que le type de l'interface est `monitor` dans l'_output_ de la commande.

#sourcecode(```sh
iw dev
# Output
phy#0
	Interface wlp97s0mon
		ifindex 3
		wdev 0x3
		addr 2c:98:11:78:e8:ed
		type monitor
		channel 10 (2457 MHz), width: 20 MHz (no HT), center1: 2457 MHz
```)

2. *_Scan_ des réseaux _WiFi_*

Utiliser la commande ci-dessous pour scanner les réseaux _WiFi_ disponibles.

#sourcecode(```sh
sudo airodump-ng --band abg wlp97s0mon
```)

L'image ci-dessous est un exemple de résultat de la commande précédente, la _MAC Address_ n'apparaît donc pas dans la liste. TODO refaire capture avec MAC Adresse de l'AP

#image("../asset/airodump-ng.png", width: 100%)

3. *Capturer le traffic du réseau*

TODO refaire avec le vrai réseau
Pour capturer le traffic du réseau _WiFi_ de l'AP, utiliser la commande ci-dessous. Le canal 

#sourcecode(```sh
sudo airodump-ng -c 136 --bssid D4:01:C3:FA:9A:3A -w handshake wlp97s0mon
# Output
TODO
```)

4. *Forcer la reconnexion des clients*

Utiliser la commande suivante pour forcer la déconnexion des clients au réseau.

#sourcecode(```sh
sudo aireplay-ng --deauth 5 -a D4:01:C3:FA:9A:3A wlp97s0mon
# Output
TODO
```)

5. *Effectuer le _4-way handshake_*

Finallement, se connecter avec le _smartphone_ `Android` sur le réseau `MyWifi`. Sur le _laptop_ `Arch OS`, stopper la capture du réseau. Les fichiers de captures générés sont les suivants :

- `handshake-01.cap`
- `handshake-01.csv`
- `handshake-01.kismet.csv`
- `handshake-01.kismet.netxml`
- `handshake-01.log.csv`

Ces fichiers de captures sont disponibles dans le #link("TODO")[_repository_ GitHub du projet: TODO]

TODO faire l'analyse de la capture

== Étape 3 : Exporter votre configuration

=== Export via Terminal

#qbox(
    [
        1. Ouvrir le terminal RouterOS : New Terminal
        2. Entrer la commande d’export : /export file=config-labXX (Remplacer XX par votre numéro de groupe)
        3. Vérifier la création du fichier : /file print
    ]
)

La procédure de téléchargement du fichier de configuration est disponible #link("https://academy.socialwifi.com/en/hardware-and-installation/setup-faqs/how-to-export-configuration-from-a-mikrotik-device/")[sur le site de SocialWiFi: https://academy.socialwifi.com/en/hardware-and-installation/setup-faqs/how-to-export-configuration-from-a-mikrotik-device/].

Cliquer sur le sous-menu `New Terminal` puis entrer la commande suivante :

#sourcecode(```bash
export file=config-lab01
```)

#image("../asset/save_config_terminal.png", width: 100%)

Ensuite, cliquer sur le sous-menu `Files` pour vérifier que le fichier `config-lab01.rsc` a bien été créé.

#image("../asset/file_backup.png", width: 100%)

=== Téléchargement du fichier de configuration

#qbox(
    [
        1. Aller dans Files
        2. Localiser le fichier config-labXX.rsc
        3. Clic droit sur le fichier
        4. Sélectionner « Download »
        5. Sauvegarder le fichier sur votre ordinateur
        Note : Le fichier .rsc contient toute la configuration de votre RouterOS en format texte.
    ]
)

Télécharger le fichier de configuration en effectuant un clic droit sur le fichier `config-lab01.rsc` puis en sélectionnant l'option `Download`. Le fichier de configuration est disponible dans le #link("https://github.com/HezelTm/tsm_advcomarc/blob/main/lab01/config-lab01.rsc")[_repository_ GitHub du projet: https://github.com/HezelTm/tsm_advcomarc/blob/main/lab01/config-lab01.rsc].

#image("../asset/download_config.png", width: 100%)

== Questions

=== Question 1

#qbox(
    [Dans quel menu peut-on trouver les informations concernant le matériel ainsi que les paquets installés sur l’appareil ?]
)

La liste des _packages_ installés sur l'appareil est disponible dans le menu `System > Packages`.

TODO capture

Il est également possible d'obtenir des informations sur les _packages_ installés via le terminal en utilisant la commande suivante : 

#sourcecode(```sh
/system package print
# Output
TODO
```)

Les informations matérielles de l'AP (_CPU_, mémoire, etc.) sont disponibles dans les menus : 

- `System > Resources`

TODO capture

- `System > Routerboard`

TODO capture

Il est également possible d'obtenir des informations matérielles via le terminal en utilisant la commande suivante :

#sourcecode(```sh
/system resource print
# Output
TODO
```)


=== Question 2

#qbox([Quelles sont les différentes manières de réinitialiser la configuration de l’appareil ?])

Comme déjà expliquer précédemment dans le rapport (voir section "Première connexion"), il est possible de faire un _reset_ physique en suivant les étapes ci-desssous :

1. Débrancher l'alimentation de l'AP.
2. Maintenir le bouton de réinitialisation enfoncé.
3. Rebrancher l'alimentation tout en maintenant le bouton de réinitialisation enfoncé jusqu'à ce que les LED clignotent.
4. Relâcher le bouton de réinitialisation.

Il est également possible de faire un _reset_ en ligne de commande en utilisant la commande suivante :

#sourcecode(```sh
/system reset-configuration
```)

Via l'interface graphique, on peut également effectuer un _reset_ en naviguant dans le menu `System > Reset Configuration`. Cette interface permet de remettre à zéro la configuration de l'appareil.

TODO capture

TODO :

- Différences entre les méthodes
— Options disponibles (keep/remove default config)
- ypes d’informations disponibles

=== Question 3

#qbox([Dans quel menu peut-on trouver les informations concernant le matériel ?])

Comme déjà expliqué précédemment dans le rapport (voir section "Question 1"), les informations matérielles de l'AP sont disponibles dans les menus :

- `System > Resources`
- `System > Routerboard`

Il est également possible d'obtenir des informations matérielles via le terminal en utilisant la commande suivante :

#sourcecode(```sh
/system resource print
# Output
TODO
```)

TODO : types d’informations disponibles

=== Question 4

#qbox([Expliquez la capture Wireshark. Comment s’assurer que vous avez bien capturé le 4-way hand-shake ?])

TODO

Réponse attendue :
— Description des 4 messages EAPOL
— Rôle de chaque message
— Éléments à identifier dans Wireshark (ANonce, SNonce, MIC, GTK)
— Critères de validation d’une capture complète
— Captures d’écran annotées de Wireshark

=== Question 5

#qbox([Quelle est la faiblesse de la sécurité WPA2-PSK ? Par quoi la remplacer ?])

TODO

Réponse attendue :
— Vulnérabilités de WPA2-PSK :
— Attaques par dictionnaire sur le 4-way handshake capturé
— Faiblesse liée aux mots de passe simples
— Partage du même PSK entre tous les utilisateurs
— Vulnérabilité KRACK (Key Reinstallation Attack)
— Solutions de remplacement :
— WPA3-SAE (Simultaneous Authentication of Equals)
— WPA2-Enterprise avec RADIUS (802.1X)
— Protection contre les attaques par force brute
— Authentification individuelle par utilisateur
