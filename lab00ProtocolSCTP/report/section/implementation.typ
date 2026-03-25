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
    - Rôle/fonction : Initialisation d'une association SCTP
    - Paramètres : Initiate Tag, Initial TSN, Nombre de flux entrants/sortants, a_rwnd (Window size)

+ *[Paquet 2] - Serveur (`192.168.0.100`) → Client (`192.168.0.101`)*
  - _Chunk_ : `INIT_ACK`
    - Rôle/fonction : Répond à la demande d'initialisation et fournit un cookie cryptograhique
    - Paramètres : Initiate Tag serveur, cookie, a_rwnd

+ *[Paquet 3] - Client (`192.168.0.101`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `COOKIE_ECHO`
    - Rôle/fonction : renvoie le cookie pour prouver l'authenticité de la demande
    - Paramètres : Cookie

+ *[Paquet 4] - Serveur (`192.168.0.100`) → Client (`192.168.0.101`)*
  - _Chunk_ : `COOKIE_ACK`
    - Rôle/fonction : Confirme la validité du cookie et l'association est donc établie
    - Paramètres : Aucun

+ *[Paquet 5] - Client (`192.168.0.101`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `DATA`
    - Rôle/fonction : Envoie de données
    - Paramètres : TSN (=0) 

+ *[Paquet 6] - Client (`192.168.0.101`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `ASCONF`
    - Rôle/fonction : Modification d'adresse pour cette association
    - Paramètres : Paramètres d'adresse, numéro de séquence

+ *[Paquet 7] - Serveur (`192.168.0.100`) → Client (`192.168.0.101`)*
  - _Chunk_ : `SACK`
    - Rôle/fonction : Accuse de reception des données
    - Paramètres : TSN Ack (=0), Arwnd

+ *[Paquet 8] - Serveur (`192.168.0.100`) → Client (`192.168.0.101`)*
  - _Chunk_ : `ASCONF_ACK`
    - Rôle/fonction : Accuse la prise en compte de la modification d'adresse
    - Paramètres : numéro de séquence

+ *[Paquet 9] - Serveur (`192.168.0.100`) → Client (`192.168.0.101`)*
  - _Chunk_ : `DATA`
    - Rôle/fonction : Envoie de données
    - Paramètres : TSN (=0)

+ *[Paquet 10] - Client (`192.168.0.101`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `SACK`
    - Rôle/fonction : Accuse de réception les données
    - Paramètres : TSN Ack (=0), Arwnd

+ *[Paquet 11] - Client (`192.168.0.101`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `DATA`
    - Rôle/fonction : Envoie de données
    - Paramètres : TSN (=1)

+ *[Paquet 12] - Serveur (`192.168.0.100`) → Client (`192.168.0.101`)*
  - _Chunk_ : `SACK`
    - Rôle/fonction : TSN Ack (=1), Arwnd
    - Paramètres : Accuse de reception les données
  - _Chunk_ : `DATA`
    - Rôle/fonction : TSN (=1)
    - Paramètres : Envoie de données

+ *[Paquet 13] - Serveur (`192.168.0.100`) → Client (`192.168.0.101`)*
  - _Chunk_ : `DATA`
    - Rôle/fonction : Envoie de données
    - Paramètres : TSN (=2)

+ *[Paquet 14] - Client (`192.168.0.101`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `SACK`
    - Rôle/fonction : Accuse de réception les données
    - Paramètres : TSN Ack (=2), Arwnd

+ *[Paquet 15] - Serveur (`192.168.0.100`) → Client (`192.168.0.101`)*
  - _Chunk_ : `DATA`
    - Rôle/fonction : Envoie de données
    - Paramètres : TSN (=3)

+ *[Paquet 16] - Client (`192.168.0.101`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `DATA`
    - Rôle/fonction : Envoie de données
    - Paramètres : TSN (=2)

+ *[Paquet 17] - Client (`192.168.0.101`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `ASCONF`
    - Rôle/fonction : Demande de modification d'adresse pour cette association
    - Paramètres : Paramètres d'adresse, numéro de séquence

+ *[Paquet 18] - Serveur (`192.168.0.100`) → Client (`192.168.0.102`)*
  - _Chunk_ : `ASCONF_ACK`
    - Rôle/fonction : Accuse la prise en compte de la modification d'adresse
    - Paramètres : numéro de séquence

+ *[Paquet 19] - Client (`192.168.0.101`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `DATA`
    - Rôle/fonction : Envoie de données
    - Paramètres : TSN (=3)

+ *[Paquet 20] - Serveur (`192.168.0.100`) → Client (`192.168.0.101`)*
  - _Chunk_ : `SACK`
    - Rôle/fonction : Accuse de réception les données
    - Paramètres : TSn Ack (=3), Arwnd

+ *[Paquet 21] - Client (`192.168.0.101`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `SACK`
    - Rôle/fonction : Accuse de réception les données
    - Paramètres : TSN (=3), Arwnd

+ *[Paquet 22] - Client (`192.168.0.101`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `DATA`
    - Rôle/fonction : Envoie de données
    - Paramètres : TSN (=4)

+ *[Paquet 23] - Serveur (`192.168.0.100`) → Client (`192.168.0.102`)*
  - _Chunk_ : `DATA`
    - Rôle/fonction : Envoie de données
    - Paramètres : TSN (=4)

+ *[Paquet 24] - Serveur (`192.168.0.100`) → Client (`192.168.0.102`)*
  - _Chunk_ : `DATA`
    - Rôle/fonction : Envoie de données
    - Paramètres : TSN (=5)

+ *[Paquet 25] - Client (`192.168.0.101`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `SACK`
    - Rôle/fonction : Accuse de réception les données
    - Paramètres : TSN Ack (=5), Arwnd

+ *[Paquet 26] - Serveur (`192.168.0.100`) → Client (`192.168.0.102`)*
  - _Chunk_ : `DATA`
    - Rôle/fonction : Envoie de données
    - Paramètres : TSN (=6)

+ *[Paquet 27] - Client (`192.168.0.102`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `ASCONF`
    - Rôle/fonction : Demande de modification d'adresse pour cette association
    - Paramètres : Paramètres d'adresse, numéro de séquence

+ *[Paquet 28] - Serveur (`192.168.0.100`) → Client (`192.168.0.102`)*
  - _Chunk_ : `ASCONF_ACK`
    - Rôle/fonction : Accuse la prise en compte de la modification d'adresse
    - Paramètres : numéro de séquence

+ *[Paquet 29] - Client (`192.168.0.102`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `DATA`
    - Rôle/fonction : Envoie de données
    - Paramètres : TSN (=5)

+ *[Paquet 30] - Serveur (`192.168.0.100`) → Client (`192.168.0.102`)*
  - _Chunk_ : `SACK`
    - Rôle/fonction : Accuse de réception les données
    - Paramètres : TSN Ack (=5)

+ *[Paquet 31] - Client (`192.168.0.102`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `DATA`
    - Rôle/fonction : Envoie de données
    - Paramètres : TSN (=6)

+ *[Paquet 32] - Client (`192.168.0.102`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `SACK`
    - Rôle/fonction : Accuse de réception les données
    - Paramètres : TSN Ack (=6)

+ *[Paquet 33] - Client (`192.168.0.102`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `DATA`
    - Rôle/fonction : Envoie de données
    - Paramètres : TSN (=7)

+ *[Paquet 34] - Serveur (`192.168.0.100`) → Client (`192.168.0.102`)*
  - _Chunk_ : `SHUTDOWN`
    - Rôle/fonction : Initialisation de la fermeture de l'association
    - Paramètres : TSN Ack (dernier reçu avec succès)

+ *[Paquet 35] - Serveur (`192.168.0.100`) → Client (`192.168.0.102`)*
  - _Chunk_ : `SACK`
    - Rôle/fonction : Accuse de réception les données
    - Paramètres : TSN Ack (=7)

+ *[Paquet 36] - Client (`192.168.0.102`) → Serveur (`192.168.0.100`)*
  - _Chunk_ : `SHUTDOWN_ACK`
    - Rôle/fonction : Confirmation de la réception de la demande de fermeture
    - Paramètres : Aucun

+ *[Paquet 37] - Serveur (`192.168.0.100`) → Client (`192.168.0.102`)*
  - _Chunk_ : `SHUTDOWN`
    - Rôle/fonction : Répétition de la demande de fermeture
    - Paramètres : TSN Ack

+ *[Paquet 38] - Serveur (`192.168.0.100`) → Client (`192.168.0.102`)*
  - _Chunk_ : `SHUTDOWN_COMPLETE`
    - Rôle/fonction : Validation de la fermeture de l'association
    - Paramètres : Aucun

== Questions

#qbox(
    [1. Quelle est la différence principale entre le handshake SCTP (4-way) et le handshake TCP (3-way) ?]
)

Outre le fait que SCTP comporte une étape supplémentaire, la différence majeure réside dans le moment où le serveur alloue ses ressources. Avec TCP, cette allocation se fait dès la réception du SYN. En revanche, avec SCTP, le serveur n'alloue ses ressources qu'à la réception du COOKIE_ECHO, une fois que le client a prouvé sa légitimité.

#qbox(
    [2. Pourquoi SCTP utilise-t-il un cookie lors de l’établissement de connexion ?]
)

SCTP utilise un cookie pour pallier les vulnérabilités de TCP face aux attaques par déni de service, comme le SYN Flood, qui visent à saturer et faire planter le serveur. Ce cookie agit comme un mécanisme de sécurité : le serveur n'alloue sa mémoire qu'après avoir reçu un COOKIE_ECHO valide, évitant ainsi de gaspiller des ressources pour des requêtes illégitimes.

#qbox(
    [3. Quel est l’avantage du SACK par rapport à un ACK classique ?]
)

Le principal avantage du SACK est l'optimisation de la bande passante grâce à l'élimination des retransmissions inutiles. Avec un ACK, la perte d'un paquet entraîne souvent la retransmission de celui-ci ainsi que de tous les paquets l'ayant suivi. Le SACK, en revanche, permet d'indiquer précisément les paquets manquants et ceux bien reçus, limitant ainsi le renvoi aux seules données perdues.

#qbox(
    [4. Dans quel contexte l’extension ADD-IP (ASCONF) est-elle utile ?]
)

L'extension ADD-IP est particulièrement utile pour gérer le multihoming et la mobilité, car elle permet de modifier dynamiquement les adresses IP d'une association en cours sans l'interrompre. Concrètement, si l'interface principale d'un serveur tombe en panne, le chunk ASCONF permet de basculer sur une autre adresse IP. De même, si un téléphone passe d'une connexion Wi-Fi à un réseau 4G/5G, cette extension assurera la continuité de la communication.
