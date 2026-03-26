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

== Analyse de la capture Wireshark

#qbox(
  [(a) Ouvrir le fichier SCTP-ADDi.pcap dans Wireshark],
)

La capture `sctp-addip.pcap` contient une communication `SCTP` de 38 paquets entre trois adresses IP différentes (`192.168.0.100`, `192.168.0.101` et `192.168.0.102`).

#align(center, image("../asset/cap_wireshark.png", width: 100%))

#qbox(
  [(b) Appliquer un filtre pour afficher uniquement les paquets SCTP : sctp],
)

L'application du filtre `sctp` ne change rien par rapport à l'affichage initial, car tous les paquets de la capture sont des paquets `SCTP`.

#align(center, image("../asset/cap_wireshark_filter_sctp.png", width: 100%))

#qbox(
  [(c) Identifier les adresses IP source et destination],
)

Les adresses IP sources sont :

- `192.168.0.100`
- `192.168.0.101`
- `192.168.0.102`

Les adresses IP destinations sont les mêmes.

#qbox(
  [(d) Repérer les différentes phases de la communication SCTP],
)

La communication `SCTP` est divisée selon les phases suivantes :

1. *_`SCTP` association establishment message flow_*

L'établissement de l'association `SCTP` se fait en quatre étapes (_4-way handshake_) et implique les paquets 1 à 4, entre les stations `192.168.0.100` et `192.168.0.101`.

#align(center, image("../asset/sctp_flow_phase1.png", width: 100%))

La station A `192.168.0.100` initie l'association en envoyant à la station B `192.168.0.101` un paquet contenant un `INIT chunk`, qui peut inclure une ou plusieurs adresses IP utilisées par l'initiateur. La station B `192.168.0.101` répond avec un paquet contenant un `INIT_ACK chunk`, qui peut également inclure une ou plusieurs adresses IP utilisées par le répondant. Les deux  `INIT chunk` et `INIT_ACK chunk` spécifient le nombre de flux sortants supportés par l'association, ainsi que le nombre maximum de flux entrants acceptés de l'autre point de terminaison.

L'association est ensuite complétée par un échange de `COOKIE ECHO/COOKIE ACK` qui spécifie une valeur de _cookie_ utilisée dans tous les échanges de données ultérieurs.

2. *_`SCTP` data transfer_*

Une fois l'association établie, les données peuvent être transférées entre les points de terminaison en utilisant des paquets `DATA chunk`. Le récepteur _acknowledges_ la réception des données avec des paquets `SACK chunk`. Les paquets 5 à 35 (sauf le paquet 34) sont impliqués dans cette phase.

#align(center, image("../asset/sctp_flow_phase2.png", width: 100%))

Les paquets `ASCONF` sont utilisés pour communiquer un changement de configuration et doivent être _acknowledgés_ par un paquet `ASCONF_ACK`. Sur l'image précédente, les paquets 6/8, 17/18 et 27/28 sont des échanges `ASCONF/ASCONF_ACK`.

Il est égalemen possible de voir des paquets `HEARTBEAT Chunks` et `HEARTBEAT ACK Chunks` qui sont utilisés pour une vérification périodique de la disponibilité des points de terminaison. Ceux-ci ne sont pas présent dans la capture.

3. *_`SCTP` association termination_*

La terminaison de l'association peut être initiée par n'importe quel point de terminaison avec un paquet contenant un `SHUTDOWN chunk`. Le point de terminaison destinataire répond avec un paquet contenant un `SHUTDOWN ACK chunk`, et le point de terminaison initiateur conclut la fermeture avec un paquet contenant un `SHUTDOWN COMPLETE chunk`. Dans la capture, on remarque que l'initiateur de la fermeture envoie deux paquets `SHUTDOWN chunk` (paquets 34 et 36) à suivre avant de recevoir un `SHUTDOWN ACK chunk` (paquet 35). Ici la numérotation des paquets est trompeur car si l'on regarde les _timestamps_, on remarque que le paquet 36 est envoyé avant le paquet 35.

#align(center, image("../asset/sctp_flow_phase3.png", width: 100%))

Sources :
- #link(
    "https://docs.oracle.com/cd/E80921_01/html/esbc_ecz740_configuration/GUID-E6214D44-39E0-4B00-A491-06A5194CB820.htm",
  )[Oracle Documentation - SCTP Message Flow : https://docs.oracle.com/cd/E80921_01/html/esbc_ecz740_configuration/GUID-E6214D44-39E0-4B00-A491-06A5194CB820.htm]
- #link(
    "https://www.rfc-editor.org/rfc/rfc5061",
  )[RFC 5061 - Stream Control Transmission Protocol (SCTP) Dynamic Address Reconfiguration : https://www.rfc-editor.org/rfc/rfc5061]

== Diagramme de séquence

#qbox(
  [Dessiner un diagramme en flèche (diagramme de séquence) montrant :
    - L’émetteur à gauche, le récepteur à droite
    - Chaque paquet représenté par une flèche avec :
      - Le numéro du paquet
      - Le ou les types de chunks contenus
      - Une brève description du rôle du paquet
    - Les différentes phases clairement identifiées :
      - Phase d’établissement de l’association (4-way handshake)
      - Phase de transfert de données
      - Phase de fermeture (si présente)
  ],
)

Le diagramme de séquence ci-dessous illustre la phase d'établissement de l'association `SCTP` entre les stations.

#align(center, image("../asset/seq_diag_phase1.svg", width: 100%))

Le diagramme de séquence ci-dessous illustre la phase de transfert de données `SCTP` entre les stations.

#align(center, image("../asset/seq_diag_phase2.svg", width: 100%))

Le diagramme de séquence ci-dessous illustre la phase de fermeture de l'association `SCTP` entre les stations.

#align(center, image("../asset/seq_diag_phase3.svg", width: 100%))

== Analyse détaillée des chunks

#qbox(
  [Pour chaque paquet identifié, indiquer :
    1. Le numéro du paquet dans la capture
    2. La direction (Client → Serveur ou Serveur → Client)
    3. Les chunks présents dans le paquet
    4. Pour chaque chunk, expliquer :
      - Son rôle et sa fonction
      - Les paramètres importants qu’il contient
      - Sa place dans le protocole SCTP
  ],
)

+ *[Paquet 1] - Client (`192.168.0.101`) → Serveur (`192.168.0.100`)*

  - _Chunk_ : `INIT` (1)
    - Rôle/fonction : utilisé pour initier une association `SCTP` entre deux points de terminaison
    - Paramètres fixes :
      - `Source Port` : port source du _sender_ de l'`INIT` paquet
      - `Destination Port` : port destination du _receiver_ de l'`INIT` paquet
      - `Verification Tag` :  utilisé par le _receiver_ du paquet pour valider l'identité du _sender_ de ce paquet. La valeur de ce champ doit être identique à la valeur du champ `Initiate Tag` reçue
      - `Checksum` : _checksum_ du paquet
      - `Initiate Tag` : _tag_ de vérification utilisé pour identifier l'association ; présent dans le champ `Verification Tag` de tous les paquets `SCTP` du _receiver_ de l'`INIT` paquet.
      - `Advertised Receiver Window Credit` : taille en _bytes_ du _buffer_ alloué par le _sender_ de  l'`INIT` pour cette fenêtre de réception
      - `Number of Outbound Streams` : nombre de flux sortants que le _sender_ de l'`INIT` souhaite créer dans cette association
      - `Number of Inbound Streams` : nombre de flux entrants que le _sender_ de l'`INIT` souhaite créer dans cette association
      - `Initial TSN` : définit le numéro de séquence initial que le _sender_ de l'`INIT` souhaite utiliser pour cette association
    - Paramètres variables :
      - `IPv4 Address` : contient une adresse IPv4 du _sender_ de l'`INIT`
      - `IPv6 Address` : contient une adresse IPv6 de _sender_ de l'`INIT`
      - `Cookie Preservative` : utiliser pour suggérer au récepteur de l'INIT une durée de vie plus longue pour le _State Cookie_
      - `Reserved for ECN Capable` : réservé pour une future utilisation avec _Explicit Congestion Notification_ (_ECN_)
      - `Host Name Address` : contient le nom d'hôte _DNS_ du _sender_ de l'`INIT`
      - `Supported Address Types` : liste des types d'adresses supportés par l'initiateur
    - Remarque.s :
      - le champ `Verification Tag` contient la valeur `0x00000000` pour les paquets `INIT`
    - Sources :
      - #link(
          "https://datatracker.ietf.org/doc/html/rfc4960#section-3.3.2",
        )[RFC 4960 - Stream Control Transmission Protocol : https://datatracker.ietf.org/doc/html/rfc4960#section-3.3.2]
      - #link(
          "https://en.wikipedia.org/wiki/SCTP_packet_structure",
        )[Wikipedia - SCTP packet structure : https://en.wikipedia.org/wiki/SCTP_packet_structureS]
      - #link(
          "https://datatracker.ietf.org/doc/html/rfc4960#section-3.1",
        )[IBM Documentation - SCTP Common Header Field Descriptions
          : https://datatracker.ietf.org/doc/html/rfc4960#section-3.1]

#align(center, image("../asset/p1.png", width: 100%))

+ *[Paquet 2] - Serveur (`192.168.0.100`) → Client (`192.168.0.101`)*
  - _Chunk_ : `INIT_ACK`
    - Rôle/fonction : utilisé pour _acknowledge_ l'initiation d'une association `SCTP`
    - Paramètres fixes :
      - `Source Port` : port source du _sender_ de l'`INIT_ACK` paquet
      - `Destination Port` : port destination du _receiver_ de l'`INIT_ACK`
      - `Verification Tag` :  utilisé par le _receiver_ du paquet pour valider l'identité du _sender_ de ce paquet. La valeur de ce champ doit être identique à la valeur du champ `Initiate Tag` de l'`INIT` paquet
      - `Checksum` : _checksum_ du paquet
      - `Initiate Tag` : _tag_ de vérification utilisé pour identifier l'association ; présent dans le champ `Verification Tag` de tous les paquets `SCTP` du _receiver_ de l'`INIT_ACK` paquet.
      - `Advertised Receiver Window Credit` : taille en _bytes_ du _buffer_ alloué par le _sender_ de l'`INIT_ACK` pour cette fenêtre de réception
      - `Number of Outbound Streams` : nombre de flux sortants que le _sender_ de l'`INIT_ACK` souhaite créer dans cette association
      - `Number of Inbound Streams` : nombre de flux entrants que le _sender_ de l'`INIT_ACK` souhaite créer dans cette association
      - `Initial TSN` : définit le numéro de séquence initial que le _sender_ de l'`INIT_ACK` souhaite utiliser pour cette association
    - Paramètres variables :
      - `State Cookie` :  contient un _Message Authentication Code_ (_MAC_), un _timestamp_ de création du _cookie_, la durée de vie du _cookie_ et les informations nécessaires pour établir l'association. Le _MAC_ est calculé par le serveur à partir d'une clé secrète connue uniquement de lui.
      - `IPv4 Address` : contient une adresse IPv4 du _sender_ de l'`INIT_ACK`
      - `IPv6 Address` : contient une adresse IPv6 de _sender_ de l'`INIT_ACK`
      - `Unrecognized Parameter` : rapport des paramètres d'`INIT` non reconnus par le _receiver_ de l'`INIT` paquet
      - `Reserved for ECN Capable` : réservé pour une future utilisation avec _Explicit Congestion Notification_ (_ECN_)
      - `Host Name Address` : contient le nom d'hôte _DNS_ du _sender_ de l'`INIT_ACK`
    - Remarque.s :
      - le champ `Verification Tag` du paquet contient la valeur du champ `Initiate Tag` de l'`INIT` paquet
    - Sources :
      - #link(
          "https://datatracker.ietf.org/doc/html/rfc4960#section-3.3.3",
        )[RFC 4960 - Stream Control Transmission Protocol : https://datatracker.ietf.org/doc/html/rfc4960#section-3.3.3]
      - #link(
          "https://en.wikipedia.org/wiki/SCTP_packet_structure",
        )[Wikipedia - SCTP packet structure : https://en.wikipedia.org/wiki/SCTP_packet_structureS]
      - #link(
          "https://www.ibm.com/docs/en/aix/7.2.0?topic=protocol-sctp-association-startup-shutdown",
        )[IBM Documentation - SCTP association startup and shutdown : https://www.ibm.com/docs/en/aix/7.2.0?topic=protocol-sctp-association-startup-shutdown]
      - #link(
          "https://www.rfc-editor.org/rfc/rfc4960#section-3.2.2",
        )[RFC 4960 - Reporting of Unrecognized Parameters : https://www.rfc-editor.org/rfc/rfc4960#section-3.2.2
        ]

#align(center, image("../asset/p2.png", width: 100%))

+ *[Paquet 3] - Client (`192.168.0.101`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `COOKIE_ECHO`
    - Rôle/fonction : utilisé pour répondre à un `INIT_ACK` paquet. Ce _chunk_ ne fait que renvoyer le _State Cookie_ reçu dans le `INIT_ACK` paquet
    - Paramètres fixes :
      - `Source Port` : port source du _sender_ de l'`COOKIE_ECHO` paquet
      - `Destination Port` : port destination du _receiver_ de l'`COOKIE_ECHO`
      - `Verification Tag` :  utilisé par le _receiver_ du paquet pour valider l'identité du _sender_ de ce paquet. La valeur de ce champ doit être identique à la valeur du champ `Initiate Tag` de l'`INIT_ACK` paquet
      - `Checksum` : _checksum_ du paquet
      - `Cookie` : contient le _State Cookie_ reçu dans le `INIT_ACK` paquet
    - Paramètres variables : aucun
    - Remarque.s :
      - le champ `Verification Tag` du paquet contient la valeur du champ `Initiate Tag` de l'`INIT_ACK` paquet
      - le champ `Cookie` contient la même valeur que le champ `State Cookie` du `INIT_ACK` paquet
    - Sources :
      - #link(
          "https://datatracker.ietf.org/doc/html/rfc4960#section-3.3.11",
        )[RFC 4960 - Stream Control Transmission Protocol : https://datatracker.ietf.org/doc/html/rfc4960#section-3.3.11]
      - #link(
          "https://www.ibm.com/docs/en/aix/7.2.0?topic=protocol-sctp-association-startup-shutdown",
        )[IBM Documentation - SCTP association startup and shutdown : https://www.ibm.com/docs/en/aix/7.2.0?topic=protocol-sctp-association-startup-shutdown]
      - #link(
          "https://en.wikipedia.org/wiki/SCTP_packet_structure",
        )[Wikipedia - SCTP packet structure : https://en.wikipedia.org/wiki/SCTP_packet_structureS]

#align(center, image("../asset/p3.png", width: 100%))

+ *[Paquet 4] - Serveur (`192.168.0.100`) → Client (`192.168.0.101`)*
  - _Chunk_ : `COOKIE_ACK`
    - Rôle/fonction : utilisé pour _acknowledge_ la réception d'un `COOKIE_ECHO` paquet et ainsi compléter l'établissement de l'association `SCTP`
    - Paramètres fixes :
      - `Source Port` : port source du _sender_ de l'`COOKIE_ACK` paquet
      - `Destination Port` : port destination du _receiver_ de l'`COOKIE_ACK`
      - `Verification Tag` :  utilisé par le _receiver_ du paquet pour valider l'identité du _sender_ de ce paquet. La valeur de ce champ doit être identique à la valeur du champ `Initiate Tag` de l'`INIT_ACK` paquet
      - `Checksum` : _checksum_ du paquet
    - Paramètres variables : aucun
    - Remarque.s :
      - le champ `Verification Tag` du paquet contient la valeur du champ `Initiate Tag` de l'`INIT_ACK` paquet
    - Sources :
      - #link(
          "https://datatracker.ietf.org/doc/html/rfc4960#section-3.3.12",
        )[RFC 4960 - Stream Control Transmission Protocol : https://datatracker.ietf.org/doc/html/rfc4960#section-3.3.12]
      - #link(
          "https://www.ibm.com/docs/en/aix/7.2.0?topic=protocol-sctp-association-startup-shutdown",
        )[IBM Documentation - SCTP association startup and shutdown : https://www.ibm.com/docs/en/aix/7.2.0?topic=protocol-sctp-association-startup-shutdown]
      - #link(
          "https://en.wikipedia.org/wiki/SCTP_packet_structure",
        )[Wikipedia - SCTP packet structure : https://en.wikipedia.org/wiki/SCTP_packet_structureS]

#align(center, image("../asset/p4.png", width: 100%))

+ *[Paquet 5] - Client (`192.168.0.101`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `DATA`
    - Rôle/fonction : utilisé pour transférer des données entre les points de terminaison d'une association `SCTP`
    - Paramètres fixes :
      - `Source Port` : port source du _sender_ du paquet `DATA`
      - `Destination Port` : port destination du _receiver_ du paquet `DATA`
      - `Verification Tag` : utilisé par le _receiver_ du paquet pour valider l'identité du _sender_ du paquet `DATA`
      - `Checksum` : _checksum_ du paquet
      - `I-Bit` : _(I)mmediate bit_ : si égal à `1`, indique que le _sender_ du paquet `DATA` souhaite que le _receiver_ du paquet lui envoie un `SACK` immédiatement après la réception de ce paquet `DATA`
      - `U-Bit` : _(U)nordered bit_ : si égal à `1`, indique que c'est un paquet de données non ordonné et donc qu'il n'y a pas de numéro de `Stream Sequence Number` assigné à ce paquet (le _receiver_ doit ignorer le champ `Stream Sequence Number` dans ce cas)
      - `B-Bit` : _(B)eginning fragment bit_ : si égal à `1`, indique que c'est le premier fragment d'un message utilisateur
      - `E-Bit` : _(E)nding fragment bit_ : si égal à `1`, indique que c'est le dernier fragment d'un message utilisateur
      - `Transmission Sequence Number (relative)` (`TSN`) : numéro de séquence de transmission relatif à ce paquet `DATA` dans l'association `SCTP`
      - `Transmission Sequence Number (absolute)` (`TSN`) : numéro de séquence de transmission absolu à ce paquet `DATA` dans l'association `SCTP`
      - `Stream Identifier` (`SID`) :  identifiant du flux auquel ce paquet `DATA` appartient
      - `Stream Sequence Number` (`SSN`) : numéro de séquence du paquet `DATA` dans le flux auquel il appartient
      - `Payload Protocol Identifier` : spécifie un protocole de couche supérieure (application) pour ce paquet `DATA`
      - `User Data` : données de l'application transportées par ce paquet `DATA`
    - Paramètres variables : aucun
    - Remarque.s :
      - Le champ `Verification Tag` du paquet contient la valeur du champ `Initiate Tag` de l'`INIT_ACK` paquet
      - Le champ `TSN` est à `0` (premier paquet `DATA` de l'association)
      - Le champ `SID` est à `0` (premier flux de l'association)
      - Le champ `SSN` est à `0` (premier paquet `DATA` du flux)
      - Le champ `Payload Protocol Identifier` est à `0` (pas de protocole de couche supérieure spécifié)
    - Sources :
      - #link(
          "https://datatracker.ietf.org/doc/html/rfc4960#section-3.3.1",
        )[RFC 4960 - Stream Control Transmission Protocol : https://datatracker.ietf.org/doc/html/rfc4960#section-3.3.1]
      - #link(
          "https://en.wikipedia.org/wiki/SCTP_packet_structure",
        )[Wikipedia - SCTP packet structure : https://en.wikipedia.org/wiki/SCTP_packet_structureS]
      - #link(
          "https://www.rfc-editor.org/rfc/rfc7053",
        )[RFC 7053 - SACK-IMMEDIATELY Extension for the Stream Control Transmission Protocol : https://www.rfc-editor.org/rfc/rfc7053]

#align(center, image("../asset/p5.png", width: 100%))

+ *[Paquet 6] - Client (`192.168.0.101`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `ASCONF`
    - Rôle/fonction : utilsé pour communiquer une demande de changement de configuration qui doit être _acknowledge_.
    - Paramètres fixes :
      - `Source Port` : port source du _sender_ du paquet `ASCONF`
      - `Destination Port` : port destination du _receiver_ du paquet `ASCONF`
      - `Verification Tag` : utilisé par le _receiver_ du paquet pour valider l'identité du _sender_ du paquet `ASCONF`
      - `Checksum` : _checksum_ du paquet
      - `Sequence Number` : numéro de séquence permettant d'identifier de manière unique chaque paquet `ASCONF` dans une association `SCTP`
      - `Address Parameter` : indique l'adresse IP concernée par la demande de changement de configuration
      - `ASCONF Parameter` : indique le type de changement de configuration demandé (ajout ou suppression d'une adresse IP, changement de l'adresse IP principale)
    - Paramètres variables : aucun
    - Remarque.s :
      - Le champ `Verification Tag` du paquet contient la valeur du champ `Initiate Tag` de l'`INIT_ACK` paquet
      - Le champ `Sequence Number` du paquet est à `0xa1104d8a` (premier paquet `ASCONF` de l'association)
      - Le champ `Address Parameter` du paquet contient l'adresse IP `192.168.0.101`
      - Le champ `ASCONF Parameter ` est nommé "_Add IP address parameter_" et indique que le changement de configuration demandé est l'ajout de l'adresse IPv4 `192.168.0.102`
    - Sources :
      - #link(
          "https://www.rfc-editor.org/rfc/rfc5061#section-4.1.1",
        )[RFC 5061 - Stream Control Transmission Protocol (SCTP) Dynamic Address Reconfiguration : https://www.rfc-editor.org/rfc/rfc5061#section-4.1.1]
      - #link(
          "https://en.wikipedia.org/wiki/SCTP_packet_structure",
        )[Wikipedia - SCTP packet structure : https://en.wikipedia.org/wiki/SCTP_packet_structure]

#align(center, image("../asset/p6.png", width: 100%))

+ *[Paquet 7] - Serveur (`192.168.0.100`) → Client (`192.168.0.101`)*
  - _Chunk_ : `SACK`
    - Rôle/fonction : utilisé pour _acknowledge_ la réception de paquets `DATA` et informer le _sender_ de l'écart dans les séquences des paquets `DATA` reçus (`TSN`)
    - Paramètres fixes :
      - `Source Port` : port source du _sender_ du paquet `SACK`
      - `Destination Port` : port destination du _receiver_ du paquet `SACK`
      - `Verification Tag` : utilisé par le _receiver_ du paquet pour valider l'identité du _sender_ du paquet `SACK`
      - `Checksum` : _checksum_ du paquet
      - `Cumulative TSN Ack (relative)` : contient le numéro de séquence de transmission relatif du dernier paquet `DATA` reçu en séquence avant écart
      - `Cumulative TSN Ack (absolute)` : contient le numéro de séquence de transmission absolu du dernier paquet `DATA` reçu en séquence avant écart
      - `Advertised Receiver Window Credit` (`a_rwnd`) : mise à jour de la taille en _bytes_ du _buffer_ alloué par le _sender_ du paquet `SACK` pour la fenêtre de réception
      - `Number of Gap Ack Blocks` : nombre de blocs d'`acknowledgment` d'écart dans les séquences des paquets `DATA` reçus
      - `Number of Duplicate TSNs` : indique le nombre de numéros de séquence de transmission de paquets `DATA` reçus plus d'une fois
    - Paramètres variables : aucun
    - Remarque.s :
      - Le champ `Verification Tag` du paquet contient la valeur du champ `Initiate Tag` de l'`INIT` paquet
      - Le champ `Cumulative TSN Ack (relative)` du paquet est à `0` (le dernier paquet `DATA` reçu ; paquet 5)
      - Le champ `Number of Gap Ack Blocks` du paquet est à `0` (pas d'écart dans les séquences des paquets `DATA` reçus)
      - Le champ `Number of Duplicate TSNs` du paquet est à `0` (pas de numéros de séquence de transmission de paquets `DATA` reçus plus d'une fois)
    - Sources :
      - #link(
          "https://datatracker.ietf.org/doc/html/rfc4960#section-3.3.4",
        )[RFC 4960 - Stream Control Transmission Protocol : https://datatracker.ietf.org/doc/html/rfc4960#section-3.3.4]
      - #link(
          "https://en.wikipedia.org/wiki/SCTP_packet_structure",
        )[Wikipedia - SCTP packet structure : https://en.wikipedia.org/wiki/SCTP_packet_structureS]

#align(center, image("../asset/p7.png", width: 100%))

+ *[Paquet 8] - Serveur (`192.168.0.100`) → Client (`192.168.0.101`)*
  - _Chunk_ : `ASCONF_ACK`
    - Rôle/fonction : indique le succès ou l'échec de la demande de changement de configuration communiquée par un paquet `ASCONF`
    - Paramètres fixes :
      - `Source Port` : port source du _sender_ du paquet `ASCONF_ACK`
      - `Destination Port` : port destination du _receiver_ du paquet `ASCONF_ACK`
      - `Verification Tag` : utilisé par le _receiver_ du paquet pour valider l'identité du _sender_ du paquet `ASCONF_ACK`
      - `Checksum` : _checksum_ du paquet
      - `Sequence Number` : numéro de séquence permettant d'identifier de manière unique chaque paquet `ASCONF_ACK` dans une association `SCTP`
    - Paramètres variables : aucun
    - Remarque.s :
      - Le champ `Verification Tag` du paquet contient la valeur du champ `Initiate Tag` de l'`INIT` paquet
      - Le champ `Sequence Number` du paquet est à `0xa1104d8` (correspondant au champ `Sequence Number` du paquet `ASCONF` du paquet 6)
    - Sources :
      - #link(
          "https://www.rfc-editor.org/rfc/rfc5061#section-4.2.5",
        )[RFC 5061 - Stream Control Transmission Protocol (SCTP) Dynamic Address Reconfiguration : https://www.rfc-editor.org/rfc/rfc5061#section-4.2.5]
      - #link(
          "https://en.wikipedia.org/wiki/SCTP_packet_structure",
        )[Wikipedia - SCTP packet structure : https://en.wikipedia.org/wiki/SCTP_packet_structureS]

#align(center, image("../asset/p8.png", width: 100%))

+ *[Paquet 9] - Serveur (`192.168.0.100`) → Client (`192.168.0.101`)*
  - _Chunk_ : `DATA`, voir paquet 5 pour les détails

+ *[Paquet 10] - Client (`192.168.0.101`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `SACK`, voir paquet 7 pour les détails

+ *[Paquet 11] - Client (`192.168.0.101`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `DATA`, voir paquet 5 pour les détails

+ *[Paquet 12] - Serveur (`192.168.0.100`) → Client (`192.168.0.101`)*
  - _Chunk_ : `SACK`, voir paquet 7 pour les détails
  - _Chunk_ : `DATA`, voir paquet 5 pour les détails

+ *[Paquet 13] - Serveur (`192.168.0.100`) → Client (`192.168.0.101`)*
  - _Chunk_ : `DATA`, voir paquet 5 pour les détails

+ *[Paquet 14] - Client (`192.168.0.101`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `SACK`, voir paquet 7 pour les détails

+ *[Paquet 15] - Serveur (`192.168.0.100`) → Client (`192.168.0.101`)*
  - _Chunk_ : `DATA`, voir paquet 5 pour les détails

+ *[Paquet 16] - Client (`192.168.0.101`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `DATA`, voir paquet 5 pour les détails

+ *[Paquet 17] - Client (`192.168.0.101`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `ASCONF`, voir paquet 6 pour les détails

+ *[Paquet 18] - Serveur (`192.168.0.100`) → Serveur (`192.168.0.102`)*
  - _Chunk_ : `ASCONF_ACK`, voir paquet 8 pour les détails

+ *[Paquet 19] - Client (`192.168.0.101`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `DATA`, voir paquet 5 pour les détails

+ *[Paquet 20] - Serveur (`192.168.0.100`) → Client (`192.168.0.101`)*
  - _Chunk_ : `SACK`, voir paquet 7 pour les détails

+ *[Paquet 21] - Client (`192.168.0.101`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `SACK`, voir paquet 7 pour les détails

+ *[Paquet 22] - Client (`192.168.0.101`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `DATA`, voir paquet 5 pour les détails

+ *[Paquet 23] - Serveur (`192.168.0.100`) → Serveur (`192.168.0.102`)*
  - _Chunk_ : `DATA`, voir paquet 5 pour les détails

+ *[Paquet 24] - Serveur (`192.168.0.100`) → Serveur (`192.168.0.102`)*
  - _Chunk_ : `DATA`, voir paquet 5 pour les détails

+ *[Paquet 25] - Client (`192.168.0.101`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `SACK`, voir paquet 7 pour les détails

+ *[Paquet 26] - Serveur (`192.168.0.100`) → Serveur (`192.168.0.102`)*
  - _Chunk_ : `DATA`, voir paquet 5 pour les détails

+ *[Paquet 27] - Serveur (`192.168.0.102`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `ASCONF`, voir paquet 6 pour les détails

+ *[Paquet 28] - Serveur (`192.168.0.100`) → Serveur (`192.168.0.102`)*
  - _Chunk_ : `ASCONF_ACK`, voir paquet 8 pour les détails

+ *[Paquet 29] - Serveur (`192.168.0.102`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `DATA`, voir paquet 5 pour les détails

+ *[Paquet 30] - Serveur (`192.168.0.100`) → Serveur (`192.168.0.102`)*
  - _Chunk_ : `SACK`, voir paquet 7 pour les détails

+ *[Paquet 31] - Serveur (`192.168.0.102`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `DATA`, voir paquet 5 pour les détails

+ *[Paquet 32] - Serveur (`192.168.0.102`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `SACK`, voir paquet 7 pour les détails

+ *[Paquet 33] - Serveur (`192.168.0.102`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `DATA`, voir paquet 5 pour les détails

+ *[Paquet 34] - Serveur (`192.168.0.100`) → Client (`192.168.0.102`)*
  - _Chunk_ : `SHUTDOWN`
    - Rôle/fonction : TODO
    - Paramètres fixes : TODO
    - Paramètres variables : TODO
    - Sources :
      //- #link("")[RFC 4960 - Stream Control Transmission Protocol : ]
      - #link(
          "https://en.wikipedia.org/wiki/SCTP_packet_structure",
        )[Wikipedia - SCTP packet structure : https://en.wikipedia.org/wiki/SCTP_packet_structureS]

+ *[Paquet 35] - Serveur (`192.168.0.100`) → Serveur (`192.168.0.102`)*
  - _Chunk_ : `SACK`, voir paquet 7 pour les détails

+ *[Paquet 36] - Client (`192.168.0.102`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `SHUTDOWN_ACK`
    - Rôle/fonction : TODO
    - Paramètres fixes : TODO
    - Paramètres variables : TODO
    - Sources :
      //- #link("")[RFC 4960 - Stream Control Transmission Protocol : ]
      - #link(
          "https://en.wikipedia.org/wiki/SCTP_packet_structure",
        )[Wikipedia - SCTP packet structure : https://en.wikipedia.org/wiki/SCTP_packet_structureS]

+ *[Paquet 37] - Serveur (`192.168.0.100`) → Client (`192.168.0.102`)*
  - _Chunk_ : `SHUTDOWN`
    - Rôle/fonction : voir paquet 34 pour les détails

+ *[Paquet 38] - Serveur (`192.168.0.100`) → Client (`192.168.0.102`)*
  - _Chunk_ : `SHUTDOWN_COMPLETE`
    - Rôle/fonction : TODO
    - Paramètres fixes : TODO
    - Paramètres variables : TODO
    - Sources :
      //- #link("")[RFC 4960 - Stream Control Transmission Protocol : ]
      - #link(
          "https://en.wikipedia.org/wiki/SCTP_packet_structure",
        )[Wikipedia - SCTP packet structure : https://en.wikipedia.org/wiki/SCTP_packet_structureS]

== Questions

#qbox(
  [1. Quelle est la différence principale entre le handshake SCTP (4-way) et le handshake TCP (3-way) ?],
)

Outre le fait que SCTP comporte une étape supplémentaire, la différence majeure réside dans le moment où le serveur alloue ses ressources. Avec TCP, cette allocation se fait dès la réception du SYN. En revanche, avec SCTP, le serveur n'alloue ses ressources qu'à la réception du COOKIE_ECHO, une fois que le client a prouvé sa légitimité.

#qbox(
  [2. Pourquoi SCTP utilise-t-il un cookie lors de l’établissement de connexion ?],
)

SCTP utilise un cookie pour pallier les vulnérabilités de TCP face aux attaques par déni de service, comme le SYN Flood, qui visent à saturer et faire planter le serveur. Ce cookie agit comme un mécanisme de sécurité : le serveur n'alloue sa mémoire qu'après avoir reçu un COOKIE_ECHO valide, évitant ainsi de gaspiller des ressources pour des requêtes illégitimes.

#qbox(
  [3. Quel est l’avantage du SACK par rapport à un ACK classique ?],
)

Le principal avantage du SACK est l'optimisation de la bande passante grâce à l'élimination des retransmissions inutiles. Avec un ACK, la perte d'un paquet entraîne souvent la retransmission de celui-ci ainsi que de tous les paquets l'ayant suivi. Le SACK, en revanche, permet d'indiquer précisément les paquets manquants et ceux bien reçus, limitant ainsi le renvoi aux seules données perdues.

#qbox(
  [4. Dans quel contexte l’extension ADD-IP (ASCONF) est-elle utile ?],
)

L'extension ADD-IP est particulièrement utile pour gérer le multihoming et la mobilité, car elle permet de modifier dynamiquement les adresses IP d'une association en cours sans l'interrompre. Concrètement, si l'interface principale d'un serveur tombe en panne, le chunk ASCONF permet de basculer sur une autre adresse IP. De même, si un téléphone passe d'une connexion Wi-Fi à un réseau 4G/5G, cette extension assurera la continuité de la communication.
