/*
 * --------------------------------------------------------------------------------
 * File: /home/hezeltm/Projects/typst_template/practical_work/section/conclusion.typ
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


// ---------- Conclusion

Ce laboratoire a permis de mettre en pratique les principes du _Software-Defined Networking_ à travers un environnement _Mininet_ complet. L'analyse des captures _Wireshark_ a confirmé le comportement attendu du protocole _OpenFlow_ : initialisation via l'échange `HELLO` / `FEATURES_REPLY` / `SET_CONFIG`, apprentissage des adresses MAC par le contrôleur _POX_ via les messages `OFPT_PACKET_IN`, installation des règles de flux avec `OFPT_FLOW_MOD`, et transmission directe des paquets suivants par le _switch_ sans intervention du contrôleur.

Les échanges `ARP`, `ICMP` et `HTTP` ont illustré concrètement la séparation entre plan de contrôle et plan de données : les premiers paquets d'un flux inconnu transitent par le contrôleur, tandis que les suivants sont forwardés directement par le _switch_ grâce aux règles installées. Cette différence est particulièrement visible sur le trafic `HTTP`, où le _3-way handshake_ `TCP` matérialise la création de la _socket_, et sur `ICMP`, où tous les pings passent directement par le _switch_ dès lors que la règle de flux est en place.
