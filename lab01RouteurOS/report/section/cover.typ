/*
 * --------------------------------------------------------------------------------
 * File: /home/hezeltm/Projects/typst_template/practical_work/section/cover.typ
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

#import "../data/styling.typ": colors
#import "../data/metadata.typ" : metadata, authors
#import "../data/translation.typ": tr_cover

// ----- Logos

// Entity Logo
#let logo_path = "/asset/logos/" + str(metadata.logo)
#align(
  center,
  image(logo_path, width: 50%)
)
#v(17pt)

// ----- Primary title

#v(80pt)
#set align(center)
#text(
  fill: colors.c1,
  size: 40pt,
  weight: "extrabold",
)[#metadata.name]\
#set line(length: 100%)
#stack(line(stroke: 2pt + colors.c1))

// ----- Secondary title

#v(40pt)
#text(
  fill: colors.c1,
  size: 23pt,
  weight: "bold",
)[#metadata.course]\

// ----- Authors

#v(40pt)
#text(
  fill: black,
  size: 18pt,
)[
  Group AR-2 : 
  #for a in authors {
    a.firstname + " " + a.lastname
    if a != authors.last() {", "}
  }
]\
#text(
  fill: colors.c1,
  size: 18pt,
)[-]

// ----- Metadata


#text(
  fill: black,
  size: 13pt,
)[#metadata.entity (#metadata.entity_acronym)]\
#text(
  fill: black,
  size: 13pt,
)[#metadata.section (#metadata.section_acronym)]\
#text(
  fill: black,
  size: 13pt,
)[#metadata.profil (#metadata.profil_acronym)]\

// ----- Dates

#v(180pt)
#align(
  left,
  table(
    columns: (20%, 80%),
    stroke: none,
    inset: 3pt,
    align: left + horizon,
    [Repository URI], [#link(metadata.git_url)[#metadata.git_url]],
    [Creation date], [#metadata.date_creation.display()],
    [Submission date], [#datetime.today().display()],
  )
)
