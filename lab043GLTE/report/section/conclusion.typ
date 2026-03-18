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

Ce laboratoire a permis de valider la mise en œuvre complète d'un système d'authentification mutuelle conforme aux principes des réseaux 3G et LTE, confirmant le bon fonctionnement des mécanismes cryptographiques de challenge-réponse bidirectionnels. L'implémentation développée illustre l'évolution significative par rapport au GSM, avec l'introduction d'un token d'authentification permettant au client de vérifier l'identité du serveur, établissant ainsi une session doublement authentifiée avant tout échange de données.

Malgré l'utilisation d'un chiffrement XOR simplifié pour cette simulation, l'architecture mise en place démontre efficacement les principes de l'authentification mutuelle et la dérivation sécurisée de clé de session Kc. Les captures de fonctionnement présentées attestent de la réussite des échanges cryptographiques bidirectionnels et de la validation mutuelle des identités, prévenant ainsi les attaques par usurpation d'identité du réseau.

Enfin, cette étude pratique met en lumière les améliorations apportées par les générations successives de réseaux mobiles, notamment la protection contre les IMSI catchers et les faux relais qui exploitaient l'absence d'authentification du réseau dans le GSM. Elle souligne également la continuité de l'évolution vers le LTE-Advanced et la 5G, qui renforcent encore davantage ces mécanismes avec des algorithmes cryptographiques plus robustes et une meilleure protection de la vie privée. Cette expérience constitue ainsi un maillon essentiel dans la compréhension de l'évolution des architectures de sécurité des communications mobiles.