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

Ce travail pratique a permis d'analyser en détail le fonctionnement du protocole `SCTP` à travers l'étude d'une capture _Wireshark_ réelle. Les trois phases principales de la communication établissement de l'association, transfert de données et fermeture ont été examinées _chunk_ par _chunk_, mettant en lumière la richesse et la complexité du protocole. L'analyse du _4-way handshake_ et du mécanisme de _State Cookie_ a notamment illustré comment `SCTP` se protège efficacement contre les attaques par déni de service. Le rôle du `SACK` dans l'optimisation des retransmissions a également été mis en évidence, démontrant la supériorité de ce mécanisme face à un `ACK` classique. Ces observations confirment que `SCTP` a été conçu avec des exigences de fiabilité et de performance bien supérieures à celles de `TCP`.

L'extension `ADD-IP (ASCONF)` constitue sans doute l'apport le plus remarquable observé dans cette capture, en permettant la reconfiguration dynamique des adresses IP sans interrompre l'association. Les échanges `ASCONF/ASCONF-ACK` entre les trois adresses IP ont illustré concrètement des cas d'usage réels tels que l'ajout d'une adresse, le changement d'adresse primaire et la suppression d'une adresse. Cette capacité de reconfiguration à la volée fait de `SCTP` un protocole particulièrement adapté aux environnements mobiles et aux infrastructures multi-interfaces. Au-delà de l'aspect technique, ce travail a permis de développer une méthodologie d'analyse de captures réseau rigoureuse et structurée. Il démontre ainsi l'intérêt d'étudier les protocoles de transport à travers des cas concrets plutôt que de manière purement théorique.
