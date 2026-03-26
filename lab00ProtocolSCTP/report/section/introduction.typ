// -------------------------------------------------------------------
// Copyright © 2025 Dimitri Julmy
// License MIT
// -------------------------------------------------------------------
// Author : Dimitri Julmy <dev@dimitri-julmy.com>
// Date   : 27.11.2025
// -------------------------------------------------------------------
// Report Template - introduction.typ
// -------------------------------------------------------------------

// ---------- Imports

// Third-party

// Values

// ---------- Introduction

Le protocole `SCTP` (_Stream Control Transmission Protocol_) est un protocole de transport défini par la RFC 4960, conçu comme une alternative plus robuste à `TCP` et `UDP`. Contrairement à `TCP`, il offre nativement des fonctionnalités avancées telles que le _multihoming_, le _multi-streaming_ et une protection contre certaines attaques par déni de service. Il est notamment utilisé dans des environnements nécessitant une haute disponibilité et une tolérance aux pannes, comme les réseaux de télécommunication. Son mécanisme d'établissement de connexion en quatre étapes (_4-way handshake_) ainsi que son système de _State Cookie_ le distinguent fondamentalement de ses prédécesseurs. Ces caractéristiques en font un protocole particulièrement adapté aux infrastructures critiques et aux environnements mobiles.

Dans le cadre de ce travail pratique, nous analysons une capture Wireshark `sctp-addip.pcap` contenant 38 paquets échangés entre trois adresses IP distinctes. Cette capture illustre les trois phases principales d'une communication `SCTP` : l'établissement de l'association, le transfert de données et la fermeture de l'association. Elle met également en évidence l'extension `ADD-IP (ASCONF)`, qui permet la reconfiguration dynamique des adresses IP d'une association en cours. À travers l'analyse détaillée de chaque _chunk_, nous cherchons à comprendre le rôle et le fonctionnement de chacun des mécanismes mis en œuvre. Ce document présente ainsi une vue complète du comportement du protocole `SCTP` dans un scénario de communication réel.
