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

TODO

#qbox(
    [(b) Appliquer un filtre pour afficher uniquement les paquets SCTP : sctp]
)

TODO

#qbox(
    [(c) Identifier les adresses IP source et destination]
)

TODO

#qbox(
    [(d) Repérer les différentes phases de la communication SCTP]
)

TODO

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

TODO (voir exemple de format attendu)

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

TODO

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
