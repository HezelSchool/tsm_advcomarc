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

TODO

#qbox(
    [Pour créer le serveur, ouvrez le menu « User Manager » et dans l’onglet « Router », ajoutez-en un nouveau avec les paramètres adéquats.]
)

TODO

#qbox(
    [Toujours dans les paramètres de l’application « User Manager », ajoutez un utilisateur avec les paramètres suivant :
    - Username : labo
    - Password : labo
    - Mikrotik-Attribute : write
    N’oubliez pas d’activer le serveur RADIUS dans les « Settings ».]
)

TODO

#qbox([
    Afin que RouterOS authentifie les utilisateurs au travers de ce que l’on vient de configurer, rendez-vous dans les utilisateurs système de l’access point et activez l’authentification AAA. Testez vos logins avec une nouvelle fenêtre Winbox et observer les sessions ouvertes.
])

TODO

== Étape 2 : Configuration de l’authentification avec WPA2 Enterprise

#qbox([Pour cette étape vous aurez besoin de certificats. Afin de faciliter la création de ces derniers,voici les commandes à exécuter pour les générer.
])

#sourcecode(```sh
# Generating a Certificate Authority
/certificate
add name=advcomarc-radius-ca common-name="AdvComArc CA" key-size=secp384r1 digest-algorithm=sha384
days-valid=1825 key-usage=key-cert-sign,crl-sign
sign advcomarc-radius-ca ca-crl-host=advcomarc.mse.ch
```)

#sourcecode(```sh
# Generating a server certificate for User Manager
add name=userman-cert common-name=advcomarc.mse.ch subject-alt-name=DNS:advcomarc.mse.ch key-
size=secp384r1 digest-algorithm=sha384 days-valid=800 key-usage=tls-server
sign userman-cert ca=advcomarc-radius-ca
```)

#sourcecode(```sh
# Generating a client certificate
add name=advcomarc-client-cert common-name=advcomarc.mse.ch key-usage=tls-client days-valid=800 key-
size=secp384r1 digest-algorithm=sha384
sign advcomarc-client-cert ca=advcomarc-radius-ca
```)

#sourcecode(```sh
# Exporting the public key of the CA as well as the generated client private key and certificate for
distribution to client devices
export-certificate advcomarc-radius-ca file-name=advcomarc-radius-ca
```)

#sourcecode(```sh
# A passphrase is needed for the export to include the private key
export-certificate advcomarc-client-cert type=pkcs12 export-passphrase="keep it simple stupid"
```)

TODO

#qbox([
    Configurez le WLAN dans le menu « Wireless ».
    - Ajoutez un nouveau profil de sécurité avec qui nécessite le protocole WPA2 Enterprise avec EAP-TLS.
    - Nommez-le « radius-auth ».
    - Configurez l’un des deux WLAN pour qu’il utilise le profil adéquat
])

TODO

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

TODO

== Étape 3 : Exportez votre configuration

#qbox([
    Pour exporter votre configuration actuelle de Router OS, ouvrez un terminal à l’intérieur de Router OS et entrez la commande : export file=FILE_NAME
])

TODO

#qbox([
    Pour exporter le fichier sur votre machine :
    - Allez dans « Files »
    - Sélectionnez le fichier que vous venez de créer qui devrait avoir l’extension «.rsc »
    - Faites un clic droit sur le fichier et « Download »
])

TODO

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
