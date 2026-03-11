/*
 * --------------------------------------------------------------------------------
 * File: /home/hezeltm/Projects/typst_template/practical_work/main.typ
 * Project: /home/hezeltm/Projects/typst_template/practical_work
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

#import "./data/styling.typ": colors
#import "./data/metadata.typ": metadata, 
#import "data/translation.typ": tr_chapters, tr_other

// ---------- General configuration of the report

// Page configuration
#set page(
  flipped: false,
  margin: (bottom: 2cm, top: 2cm, x: 1.5cm,),
  paper: "a4",
)

// Text configuration
#set text(
  font: "Roboto",
  lang: metadata.lang,
  region: "ch",
  size: 11pt,
  weight: "regular",
)

// Highlight documents links
#show link: set text(fill: blue.darken(60%))

// Bullet list configuration
#set list(
  indent: 5pt,
  spacing: 0.8em,
  body-indent:0.4em,
  marker: (
    [•],
    [◦],
    [⁃],
  ),
)

// Numbered list configuration
#set enum(
  indent: 5pt,
  spacing: 0.8em,
  body-indent:0.4em,
)

// ---------- Cover

#include "section/cover.typ"

// ---------- Page numbering & Heading formatting

#set page(
  numbering: "1/1"
)

#show heading: it => {

  // Primary Heading
  if it.level == 1 [
    #set align(center)
    #set text(
    size: 30pt,
    weight: "extrabold",
    fill: white
  )
  #block(
    fill: colors.c1,
    width: 100%,
    inset: 10pt,
    it
  )
  #v(10pt)

  // Secondary Heading
  ] else if it.level == 2 [
    #set align(left)
    #set text(
      size: 25pt,
      weight: "bold",
      fill: colors.c1,
    )
    #(it)
    #v(-17pt)
    #line(
      stroke: 2pt + colors.c1,
      length: 100%
    )
    #v(0pt)

  // Tertiary Heading
  ] else if it.level == 3 [
    #set align(left)
    #set text(
      size: 17pt,
      weight: "medium",
      fill: colors.c1
    )
    #(it)
  ]
}

// Get correct chapter traduction
#let t_chap = (:)
#for pair in tr_chapters.pairs() [
  #let k = pair.at(0)
  #let v = pair.at(1)
  #let value = if metadata.lang == "fr" { v.fr } else { v.en }
  #t_chap.insert(k, value)
]

// ---------- Introduction

#pagebreak()
= #t_chap.introduction <introduction>
#include "section/introduction.typ"

// ---------- Implementation

#pagebreak()
= #t_chap.implementation <implementation>
#include "section/implementation.typ"

// ---------- Conclusion

#pagebreak()
= #t_chap.conclusion <conclusion>
#include "section/conclusion.typ"
