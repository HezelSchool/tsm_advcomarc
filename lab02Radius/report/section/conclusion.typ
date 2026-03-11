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

En conclusion, ce laboratoire a permis de démontrer l'efficacité d'un serveur _RADIUS_ pour la gestion centralisée et granulaire des accès réseau. Grâce à l'utilisation de certificats asymétriques basés sur la courbe elliptique `secp384r1` et le chiffrement asymétrique, nous avons pu établir un environnement sécurisé garantissant l'identité des utilisateurs et l'intégrité des échanges.

Les tests de connexion effectués avec l'utilisateur `labo` ont confirmé le bon fonctionnement de l'infrastructure, tant au niveau de l'authentification système que de l'accès sans fil sécurisé. Pour une mise en production réelle, l'utilisation d'une infrastructure à clés publiques (_PKI_) structurée et de modules de sécurité matériels (_HSM_) constituerait une évolution nécessaire afin de s'affranchir des certificats auto-générés et d'assurer une gestion rigoureuse du cycle de vie des identités.
