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

Ce laboratoire a permis de valider la mise en œuvre complète d'un système d'authentification GSM, confirmant le bon fonctionnement des algorithmes cryptographiques A3 et A8, ainsi que l'établissement d'un canal de communication sécurisé entre le client et le serveur. L'implémentation développée illustre les mécanismes fondamentaux de génération de RAND, de calcul de SRES et de dérivation de la clé de session Kc, permettant ainsi de comprendre concrètement les protocoles d'authentification des réseaux mobiles 2G.

Malgré la simplicité du chiffrement par XOR utilisé dans cette simulation, l'architecture mise en place démontre efficacement les principes de l'authentification unidirectionnelle et du transfert sécurisé de données. Les captures de fonctionnement présentées attestent de la réussite de l'échange cryptographique entre les deux entités et de la validité de la session établie.

Enfin, cette étude pratique met en perspective les limitations inhérentes aux systèmes GSM, notamment la vulnérabilité du chiffrement A5/1 et l'absence d'authentification mutuelle dans les premières versions du protocole. Elle souligne l'importance de l'évolution vers les standards 3G (UMTS) et 4G (LTE) qui ont introduit des mécanismes d'authentification bidirectionnelle et des algorithmes cryptographiques plus robustes. Cette expérience constitue ainsi une base solide pour appréhender les architectures de sécurité des communications mobiles modernes et leur évolution historique.