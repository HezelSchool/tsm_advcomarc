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

== Étape 1 : Configuration d’un login par RADIUS

#qbox(
    [En premier lieu, vous aurez besoin d’ajouter un serveur vers lequel réaliser les requêtes d’authentification.
    -  Ouvrez le menu « RADIUS ».
    - Ajouter un nouveau serveur.
      - Dans les paramètres à fournir, l’adresse IP doit être 127.0.0.1
      - Les utilisations de ce serveur seront pour les « logins » ainsi que le « Wireless »
      - Fournissez un SECRET qui devra être reporté dans le serveur RADIUS.
    - Acceptez les requêtes d’authentification en provenance du port 3799
    ]
)

Cliquer sur le menu `RADIUS` puis sur le bouton `New`. Configurer le serveur comme suit :

- Cocher l'option `login` dans la section `Service`
- Cocher l'option `wireless` dans la section `Service`
- Saisir l'adresse IP `127.0.0.1` dans le champ `Address`
- Saisir un `Secret` (ici `radius`) dans le champ `Secret`
- Garder les autres paramètres par défaut

Cliquer sur le bouton `OK` puis `Apply` pour créer le serveur RADIUS.

#align(center, image("../asset/create_radius.png", width: 100%))

Le serveur RADIUS créé apparaît dans la liste des serveurs RADIUS.

#align(center, image("../asset/radius_list.png", width: 100%))

#qbox(
    [Pour créer le serveur, ouvrez le menu « User Manager » et dans l’onglet « Router », ajoutez-en un nouveau avec les paramètres adéquats.]
)

Dans le sous-menu `User Manager > Router` et l'onglet `Router`, cliquer sur le bouton `New`. Configurer le routeur comme suit :

- Saisir la valeur `lab02_radius_router` dans le champ `Name`
- Saisir l'adresse IP `127.0.0.1` dans le champ `Address`
- Saisir le `Secret` (ici `radius`) dans le champ `Secret`
- Garder les autres paramètres par défaut

Cliquer sur le bouton `OK` puis `Apply` pour créer le routeur.

#align(center, image("../asset/create_radius_router.png", width: 100%))

Le routeur RADIUS créé apparaît dans la liste des routeurs.

#align(center, image("../asset/radius_router_list.png", width: 100%))

#qbox(
    [Toujours dans les paramètres de l’application « User Manager », ajoutez un utilisateur avec les paramètres suivant :
    - Username : labo
    - Password : labo
    - Mikrotik-Attribute : write
    N’oubliez pas d’activer le serveur RADIUS dans les « Settings ».]
)

Dans le sous-menu `User Manager > Users`, onglet `Users`, cliquer sur le bouton `New`. Configurer l'utilisateur comme suit :

- Saisir la valeur `labo` dans le champ `Username`
- Saisir la valeur `labo` dans le champ `Password`
- Cliquer sur le bouton `+` à côté de `Attributes` pour ajouter un attribut `Mikrotik-Group` avec la valeur `write`

#align(center, image("../asset/create_user.png", width: 100%))

L'utilisateur créé apparaît dans la liste des utilisateurs.

#align(center, image("../asset/list_user.png", width: 100%))

Pour activer le serveur RADIUS, aller dans le menu `User Manager > Settings`, onglet `Routers` et cliquer sur le bouton `Settings`. Cocher l'option `Enabled` et garder les autres paramètres par défaut. Cliquer sur le bouton `OK` puis `Apply` pour activer le serveur RADIUS.

#align(center, image("../asset/enable_radius.png", width: 100%))

#qbox([
    Afin que RouterOS authentifie les utilisateurs au travers de ce que l’on vient de configurer, rendez-vous dans les utilisateurs système de l’access point et activez l’authentification AAA. Testez vos logins avec une nouvelle fenêtre Winbox et observer les sessions ouvertes.
])

Dans le sous-menu `System > Users`, onglet `Users`, sélectionner l'utilisateur `system default user` et cliquer sur le bouton `AAA`. Cocher l'option `Use RADIUS` et garder les autres paramètres par défaut. Cliquer sur le bouton `Apply`.

#align(center, image("../asset/activate_aaa.png", width: 100%))

Pour tester les _logins_, ouvrir une nouvelle fenêtre `Winbox` et se connecter à l'AP en utilisant les crédits de connexion `labo` (_Username_: `labo`, _Password_: `labo`).

#align(center, image("../asset/login_labo.png", width: 100%))

Nous pouvons observer que l'utilisateur `labo` est connecté à l'AP.

#align(center, image("../asset/logged_labo.png", width: 100%))

On peut également vérifier les sessions ouvertes dans le sous-menu `User Manager > Sessions`, où l'on peut voir que l'utilisateur `labo` est connecté.

#align(center, image("../asset/labo_session.png", width: 100%))


== Étape 2 : Configuration de l’authentification avec WPA2 Enterprise

#qbox([Pour cette étape vous aurez besoin de certificats. Afin de faciliter la création de ces derniers,voici les commandes à exécuter pour les générer.
])

Nous exécutons les commandes suivantes dans le terminal de l'AP pour générer les certificats (_Certificate Authority_, _Certificate User Manager_ et _Certificate Client_) nécessaires à l'authentification _WPA2 Enterprise_.

#sourcecode(```sh
# Generating a Certificate Authority
/certificate
add name=advcomarc-radius-ca common-name="AdvComArc CA" key-size=secp384r1 digest-algorithm=sha384 days-valid=1825 key-usage=key-cert-sign,crl-sign
sign advcomarc-radius-ca ca-crl-host=advcomarc.mse.ch
print
```)

#align(center, image("../asset/cert1.png", width: 100%))

#sourcecode(```sh
# Generating a server certificate for User Manager
/certificate
add name=userman-cert common-name=advcomarc.mse.ch subject-alt-name=DNS:advcomarc.mse.ch key-size=secp384r1 digest-algorithm=sha384 days-valid=800 key-usage=tls-server
sign userman-cert ca=advcomarc-radius-ca
print
```)

#align(center, image("../asset/cert2.png", width: 100%))

#sourcecode(```sh
# Generating a client certificate
/certificate
add name=advcomarc-client-cert common-name=advcomarc.mse.ch key-usage=tls-client days-valid=800 key-size=secp384r1 digest-algorithm=sha384
sign advcomarc-client-cert ca=advcomarc-radius-ca
print
```)

#align(center, image("../asset/cert3.png", width: 100%))

#sourcecode(```sh
# Exporting the public key of the CA as well as the generated client private key and certificate for distribution to client devices
/certificate
export-certificate advcomarc-radius-ca file-name=advcomarc-radius-ca
```)

#align(center, image("../asset/export_ca_pubk.png", width: 100%))

#sourcecode(```sh
# A passphrase is needed for the export to include the private key
/certificate
export-certificate advcomarc-client-cert type=pkcs12 export-passphrase="12345678"
```)

#align(center, image("../asset/include_passphrase.png", width: 100%))

On peut vérifier que les certificats ont été créés dans le menu `System > Certificates`.

#align(center, image("../asset/list_cert.png", width: 100%))

#qbox([
    Configurez le WLAN dans le menu « Wireless ».
    - Ajoutez un nouveau profil de sécurité avec qui nécessite le protocole WPA2 Enterprise avec EAP-TLS.
    - Nommez-le « radius-auth ».
    - Configurez l’un des deux WLAN pour qu’il utilise le profil adéquat
])

Dans le sous-menu `WiFi > Security`, cliquer sur le bouton `New`. Configurer un nouveau profil de sécurité comme suit :

- Saisir la valeur `radius-auth` dans le champ `Name`
- Sélectionner `WPA2 EAP` dans le champ `Authentication Types`
- Dans l'onglet `EAP`:
  - Sélectionner `TLS` dans le champ `EAP Methods`
  - Sélectionner `verify certificate` dans le champ `EAP Certificate Mode`
  - Sélectionner le certificat `userman-cert` dans le champ `EAP TLS Certificate`

Cliquer sur le bouton `OK` puis `Apply` pour créer le profil de sécurité.

#align(center, image("../asset/eap_sec.png", width: 100%))

#align(center, image("../asset/wifi_sec.png", width: 100%))

Le profil de sécurité créé apparaît dans la liste des profils de sécurité.

#align(center, image("../asset/list_wifi_sec.png", width: 100%))

Finalement, dans le menu `WiFi`, double-cliquer sur l'entré `wifi1` pour le configurer.  Dans l'onglet `Security`, sélectionner le profil de sécurité `radius-auth` dans le champ `Security`. Cliquer sur le bouton `Apply` puis `OK` pour appliquer les changements.

#align(center, image("../asset/apply_wifi_sec.png", width: 100%))

#qbox([
    A partir d’ici, on doit indiquer à notre serveur RADIUS que nous allons utiliser TLS pour l’authentification des utilisateurs.
    - Ouvrez le menu "User Manager"
    - Dans le menu system et dans certificates, activez les options crl-download et crl-use
    - Fournissez le certificat adéquat dans le champ correspondant.
    - Créez ensuite un nouveau groupe d’utilisateur dans le RADIUS.
      - Nommez le auth-by-cert
      - Autorisez uniquement le protocole EAP-TLS pour ce groupe.
    - Créez un second groupe d’utilisateurs
      - Nommez le auth-with-passwd
      - Autorisez pour ce groupe les protocoles EAP-TLS ainsi que EAP-PEAP
      - Autorisez également l’authentification en interne par MSCHAPv2
    - Ajoutez l’utilisateur labo dans le groupe adéquat.
    - Enfin, vérifiez que vous arrivez à vous authentifier sur le WLAN sécurisé en WPA2 Enterprise depuis un appareil externe
])

Dans le sous-menu `System > Certificates`, cliquer sur le bouton `Settings`. Cocher les options `CRL Download` et `Use CRL`. Cliquer sur le bouton `Apply` puis `OK` pour appliquer les changements.

#align(center, image("../asset/crl_download_crl_use.png", width: 100%))

Dans le sous-menu `User Manager > Routers`, cliquer sur le bouton `Settings`. Dans le champ `RadSec Certificate`, sélectionner le certificat `userman-cert`. Cliquer sur le bouton `Apply` puis `OK` pour appliquer les changements.

#align(center, image("../asset/radsec_cert.png", width: 100%))

Dans le sous-menu `User Manager > User Groups`, créer deux nouveaux groupes d'utilisateurs en cliquant sur le bouton `New` et en configurant les groupes comme suit :

- Groupe `auth-by-cert` :
  - Saisir la valeur `auth-by-cert` dans le champ `Name`
  - Cocher l'option `EAP TLS` dans la section `Outer Auths`
  - Créer le groupe en cliquant sur le bouton `Apply` puis `OK`

#align(center, image("../asset/auth_by_cert.png", width: 100%))

- Groupe `auth-with-passwd` :
    - Saisir la valeur `auth-with-passwd` dans le champ `Name`
    - Cocher les options `EAP TLS`, `EAP PEAP`, `MSCHAP2`, `EAP TTLS` et `EAP MSCHAP2` dans la section `Outer Auths`
    - Cocher l'option `PEAP MSCHAP2` ET `TTLS MSCHAP2` dans la section `Inner Auths`
    - Créer le groupe en cliquant sur le bouton `Apply` puis `OK`

#align(center, image("../asset/auth_with_pwd.png", width: 100%))

Les groupes d'utilisateurs créés apparaissent dans la liste des groupes d'utilisateurs.

#align(center, image("../asset/list_user_group.png", width: 100%))

Dans le sous-menu `User Manager > Users`, double-cliquer sur l'utilisateur `labo`. Dans le champ `Group`, sélectionner le groupe `auth-with-passwd`. Cliquer sur le bouton `Apply` puis `OK` pour appliquer les changements.

#align(center, image("../asset/group_labo.png", width: 100%))

TODO test connection.

#sourcecode(```sh
sudo mv ~/Downloads/cert_export_advcomarc-client-cert.p12 /etc/ca-certificates/trust-source/anchors/
sudo mv ~/Downloads/advcomarc-radius-ca.crt /etc/ca-certificates/trust-source/anchors/
sudo update-ca-trust

nmcli con add type wifi ifname wlp97s0 con-name test-radius ssid MyWifi \
wifi-sec.key-mgmt wpa-eap 802-1x.eap peap 802-1x.phase2-auth mschapv2 \
802-1x.ca-cert /etc/ca-certificates/trust-source/anchors/advcomarc-radius-ca.crt \
802-1x.client-cert /etc/ca-certificates/trust-source/anchors/cert_export_advcomarc-client-cert.p12 \
802-1x.private-key-password "MyWifiPassword" \
802-1x.identity "labo" 802-1x.password "labo"

nmcli con up test-radius & sudo journalctl -fu NetworkManager
```)

== Étape 3 : Exportez votre configuration

#qbox([
    Pour exporter votre configuration actuelle de Router OS, ouvrez un terminal à l’intérieur de Router OS et entrez la commande : export file=FILE_NAME
])

La procédure de téléchargement du fichier de configuration est disponible #link("https://academy.socialwifi.com/en/hardware-and-installation/setup-faqs/how-to-export-configuration-from-a-mikrotik-device/")[sur le site de SocialWiFi: https://academy.socialwifi.com/en/hardware-and-installation/setup-faqs/how-to-export-configuration-from-a-mikrotik-device/].

Cliquer sur le sous-menu `New Terminal` puis entrer la commande suivante :

#sourcecode(```bash
export file=config-lab02
```)

#align(center, image("../asset/save_config_terminal.png", width: 65%)) TODO

Ensuite, cliquer sur le sous-menu `Files` pour vérifier que le fichier `config-lab02.rsc` a bien été créé.

#align(center, image("../asset/file_backup.png", width: 65%)) TODO

#qbox([
    Pour exporter le fichier sur votre machine :
    - Allez dans « Files »
    - Sélectionnez le fichier que vous venez de créer qui devrait avoir l’extension «.rsc »
    - Faites un clic droit sur le fichier et « Download »
])

Télécharger le fichier de configuration en effectuant un clic droit sur le fichier `config-lab01.rsc` puis en sélectionnant l'option `Download`. Le fichier de configuration est disponible dans le #link("https://github.com/HezelTm/tsm_advcomarc/tree/main/lab01/annexe")[_repository_ GitHub du projet: https://github.com/HezelTm/tsm_advcomarc/tree/main/lab01/annexe].

#image("../asset/download_config.png", width: 100%) TODO

== Questions

=== Question 1

#qbox([
    Avec vos mots, expliquez l’utilité de RADIUS ?
])

TODO

=== Question 2

#qbox([
    Quel est le type de chiffrement utilisé pour les certificats qui ont été générés ? Quelle est la taille de la clé ?
])

TODO

=== Question 3

#qbox([
    Pour quelle(s) raison(s) avons-nous besoin de certificats dans EAP-TLS ?
])

TODO

=== Question 4

#qbox([
    Ou peut-on vérifier les utilisateurs qui ont des sessions ouvertes dans le RADIUS ?
])

TODO

=== Question 5

#qbox[(
    Dans le cas d’une mise en production de notre AP dans un open space. On souhaite éviter l’utilisation de certificats autogénérés. Quelles sont les opérations additionnelles ?
)]

TODO
