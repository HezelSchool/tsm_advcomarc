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
    [(a) Ouvrir le fichier SCTP-ADDi.pcap dans Wireshark]
)

La capture `sctp-addip.pcap` contient une communication `SCTP` de 38 paquets entre trois adresses IP différentes (`192.168.0.100`, `192.168.0.101` et `192.168.0.102`).

#align(center, image("../asset/cap_wireshark.png", width: 100%))

#qbox(
    [(b) Appliquer un filtre pour afficher uniquement les paquets SCTP : sctp]
)

L'application du filtre `sctp` ne change rien par rapport à l'affichage initial, car tous les paquets de la capture sont des paquets `SCTP`.

#align(center, image("../asset/cap_wireshark_filter_sctp.png", width: 100%))

#qbox(
    [(c) Identifier les adresses IP source et destination]
)

Les adresses IP sources sont :

- `192.168.0.100`
- `192.168.0.101`
- `192.168.0.102`

Les adresses IP destinations sont les mêmes.

#qbox(
    [(d) Repérer les différentes phases de la communication SCTP]
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
- #link("https://docs.oracle.com/cd/E80921_01/html/esbc_ecz740_configuration/GUID-E6214D44-39E0-4B00-A491-06A5194CB820.htm")[Oracle Documentation - SCTP Message Flow : https://docs.oracle.com/cd/E80921_01/html/esbc_ecz740_configuration/GUID-E6214D44-39E0-4B00-A491-06A5194CB820.htm]
- #link("https://www.rfc-editor.org/rfc/rfc5061")[RFC 5061 - Stream Control Transmission Protocol (SCTP) Dynamic Address Reconfiguration : https://www.rfc-editor.org/rfc/rfc5061]

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
      - Phase de fermeture (si présente)]
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
      - Sa place dans le protocole SCTP]
)

+ *[Paquet 1] - Client (`192.168.0.101`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `INIT`
    - Rôle/fonction : TODO
    - Paramètres : TODO

+ *[Paquet 2] - Serveur (`192.168.0.100`) → Client (`192.168.0.101`)*
  - _Chunk_ : `INIT_ACK`
    - Rôle/fonction : TODO
    - Paramètres : TODO

+ *[Paquet 3] - Client (`192.168.0.101`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `COOKIE_ECHO`
    - Rôle/fonction : TODO
    - Paramètres : TODO

+ *[Paquet 4] - Serveur (`192.168.0.100`) → Client (`192.168.0.101`)*
  - _Chunk_ : `COOKIE_ACK`
    - Rôle/fonction : TODO
    - Paramètres : TODO

+ *[Paquet 5] - Client (`192.168.0.101`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `DATA`
    - Rôle/fonction : TODO
    - Paramètres : TODO

+ *[Paquet 6] - Client (`192.168.0.101`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `ASCONF`
    - Rôle/fonction : TODO
    - Paramètres : TODO

+ *[Paquet 7] - Serveur (`192.168.0.100`) → Client (`192.168.0.101`)*
  - _Chunk_ : `SACK`
    - Rôle/fonction : TODO
    - Paramètres : TODO

+ *[Paquet 8] - Serveur (`192.168.0.100`) → Client (`192.168.0.101`)*
  - _Chunk_ : `ASCONF_ACK`
    - Rôle/fonction : TODO
    - Paramètres : TODO

+ *[Paquet 9] - Serveur (`192.168.0.100`) → Client (`192.168.0.101`)*
  - _Chunk_ : `DATA`
    - Rôle/fonction : TODO
    - Paramètres : TODO

+ *[Paquet 10] - Client (`192.168.0.101`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `SACK`
    - Rôle/fonction : TODO
    - Paramètres : TODO

+ *[Paquet 11] - Client (`192.168.0.101`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `DATA`
    - Rôle/fonction : TODO
    - Paramètres : TODO

+ *[Paquet 12] - Serveur (`192.168.0.100`) → Client (`192.168.0.101`)*
  - _Chunk_ : `SACK`
    - Rôle/fonction : TODO
    - Paramètres : TODO
  - _Chunk_ : `DATA`
    - Rôle/fonction : TODO
    - Paramètres : TODO

+ *[Paquet 13] - Serveur (`192.168.0.100`) → Client (`192.168.0.101`)*
  - _Chunk_ : `DATA`
    - Rôle/fonction : TODO
    - Paramètres : TODO

+ *[Paquet 14] - Client (`192.168.0.101`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `SACK`
    - Rôle/fonction : TODO
    - Paramètres : TODO

+ *[Paquet 15] - Serveur (`192.168.0.100`) → Client (`192.168.0.101`)*
  - _Chunk_ : `DATA`
    - Rôle/fonction : TODO
    - Paramètres : TODO

+ *[Paquet 16] - Client (`192.168.0.101`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `DATA`
    - Rôle/fonction : TODO
    - Paramètres : TODO

+ *[Paquet 17] - Client (`192.168.0.101`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `ASCONF`
    - Rôle/fonction : TODO
    - Paramètres : TODO

+ *[Paquet 18] - Serveur (`192.168.0.100`) → Serveur (`192.168.0.102`)*
  - _Chunk_ : `ASCONF_ACK`
    - Rôle/fonction : TODO
    - Paramètres : TODO

+ *[Paquet 19] - Client (`192.168.0.101`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `DATA`
    - Rôle/fonction : TODO
    - Paramètres : TODO

+ *[Paquet 20] - Serveur (`192.168.0.100`) → Client (`192.168.0.101`)*
  - _Chunk_ : `SACK`
    - Rôle/fonction : TODO
    - Paramètres : TODO

+ *[Paquet 21] - Client (`192.168.0.101`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `SACK`
    - Rôle/fonction : TODO
    - Paramètres : TODO

+ *[Paquet 22] - Client (`192.168.0.101`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `DATA`
    - Rôle/fonction : TODO
    - Paramètres : TODO

+ *[Paquet 23] - Serveur (`192.168.0.100`) → Serveur (`192.168.0.102`)*
  - _Chunk_ : `DATA`
    - Rôle/fonction : TODO
    - Paramètres : TODO

+ *[Paquet 24] - Serveur (`192.168.0.100`) → Serveur (`192.168.0.102`)*
  - _Chunk_ : `DATA`
    - Rôle/fonction : TODO
    - Paramètres : TODO

+ *[Paquet 25] - Client (`192.168.0.101`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `SACK`
    - Rôle/fonction : TODO
    - Paramètres : TODO

+ *[Paquet 26] - Serveur (`192.168.0.100`) → Serveur (`192.168.0.102`)*
  - _Chunk_ : `DATA`
    - Rôle/fonction : TODO
    - Paramètres : TODO

+ *[Paquet 27] - Serveur (`192.168.0.102`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `ASCONF`
    - Rôle/fonction : TODO
    - Paramètres : TODO

+ *[Paquet 28] - Serveur (`192.168.0.100`) → Serveur (`192.168.0.102`)*
  - _Chunk_ : `ASCONF_ACK`
    - Rôle/fonction : TODO
    - Paramètres : TODO

+ *[Paquet 29] - Serveur (`192.168.0.102`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `DATA`
    - Rôle/fonction : TODO
    - Paramètres : TODO

+ *[Paquet 30] - Serveur (`192.168.0.100`) → Serveur (`192.168.0.102`)*
  - _Chunk_ : `SACK`
    - Rôle/fonction : TODO
    - Paramètres : TODO

+ *[Paquet 31] - Serveur (`192.168.0.102`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `DATA`
    - Rôle/fonction : TODO
    - Paramètres : TODO

+ *[Paquet 32] - Serveur (`192.168.0.102`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `SACK`
    - Rôle/fonction : TODO
    - Paramètres : TODO

+ *[Paquet 33] - Serveur (`192.168.0.102`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `DATA`
    - Rôle/fonction : TODO
    - Paramètres : TODO

+ *[Paquet 34] - Serveur (`192.168.0.100`) → Serveur (`192.168.0.102`)*
  - _Chunk_ : `SHUTDOWN`
    - Rôle/fonction : TODO
    - Paramètres : TODO

+ *[Paquet 35] - Serveur (`192.168.0.100`) → Serveur (`192.168.0.102`)*
  - _Chunk_ : `SACK`
    - Rôle/fonction : TODO
    - Paramètres : TODO

+ *[Paquet 36] - Serveur (`192.168.0.102`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `SHUTDOWN_ACK`
    - Rôle/fonction : TODO
    - Paramètres : TODO

+ *[Paquet 37] - Serveur (`192.168.0.100`) → Serveur (`192.168.0.102`)*
  - _Chunk_ : `SHUTDOWN`
    - Rôle/fonction : TODO
    - Paramètres : TODO

+ *[Paquet 38] - Serveur (`192.168.0.100`) → Serveur (`192.168.0.102`)*
  - _Chunk_ : `SHUTDOWN_COMPLETE`
    - Rôle/fonction : TODO
    - Paramètres : TODO

== Questions

#qbox(
    [1. Quelle est la différence principale entre le handshake SCTP (4-way) et le handshake TCP (3-way) ?]
)

TODO

#qbox(
    [2. Pourquoi SCTP utilise-t-il un cookie lors de l’établissement de connexion ?]
)

TODO

#qbox(
    [3. Quel est l’avantage du SACK par rapport à un ACK classique ?]
)

TODO

#qbox(
    [4. Dans quel contexte l’extension ADD-IP (ASCONF) est-elle utile ?]
)

TODO
