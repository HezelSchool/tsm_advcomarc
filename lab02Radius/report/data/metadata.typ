/*
 * --------------------------------------------------------------------------------
 * File: /home/hezeltm/Projects/typst_template/practical_work/data/metadata.typ
 * Project: /home/hezeltm/Projects/typst_template/practical_work/data
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


// ---------- Metadata

#let metadata = (
  lang: "en",
  logo: "logo_hes-so.png",
  type: "Report",
  scope: "Scope",
  name: "Lab02 - Mise en place d'un serveur RADIUS",
  course: "TSM - Advanced Communication Architecture",
  git_url: "https://gitlab-url.com",
  date_creation: datetime(year: 2026, month: 03, day: 09),
  date_due: datetime.today(),
  entity: "University of Applied Sciences and Arts of Western Switzerland",
  entity_acronym: "HES-SO",
  section : "Master of Science in Engineering",
  section_acronym: "MSE",
  profil: "Information and cyber security",
  profil_acronym: "ICS",
  locality: "Lausanne",
)

// ---------- Persons

#let authors = (
  (
    firstname: "Dimitri",
    lastname: "Julmy",
    gender: "m",
    locality: "Fribourg",
  ),
  (
    firstname: "Dylan",
    lastname: "Flotte",
    gender: "m",
    locality: "Lausanne",
  )
)
