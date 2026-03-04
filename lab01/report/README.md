# Template Report

| <!-- --> | <!-- --> |
|-|-|
| **Author** | Dimitri Julmy |
| **Mail** | dev@dimitri-julmy.com |
| **Date** | 27.11.2025 |

## Report Structure

* **assets** : Contains various report resources (appendices, images, schematics, UML diagrams, etc.)
* **bibliography** : Contains the “.bib” bibliography file and a template on how to make correct references.
* **sections** : Contains the various chapters of the report.
* **datas** : Contains styling and report data, mainly in the form of dictionaries or “.csv” files.
* **main.typ** : Main files of the report that includes all sections.

## How to Use

Simply respect the report structure :

* Put and organise your resources in the assests folder.
* Remove the unwanted sections from the sections folder and their respectiv import in the main.typ file.
* Add your customs sections in the sections folder and their respectiv import in the main.typ file.

Use the values folder to add you customs data :

* Use dictionnaries to structure data that will be used multiple times in the remport (like author.s, supervisor.s, glossary's term.s, etc.) or if those values need automated processing (used in for loop for example).
* Use ".csv" file instead of dictionnaries if those data are used in anothers Typst document.

## Guide for report redaction

Just take a look at : [Guide de rédaction de rapports pour les étudiants]("https://dev.to/supcik/guide-de-redaction-de-rapports-pour-les-etudiants-2g2k")

Chapter explanations are already included in the corresponding chapters, so **don't forget to remove them!**

Key points of the redaction guide :

* Avoid structuring your report along a time axis. The order of the chapters does not represent the evolution of your project over time.
* Make sure you don't leave any chapters on their own. If, for example, you have a chapter 1.4.1, but no chapter 1.4.2, then it's not worth splitting chapter 1.4. Rename chapter 1.4 if necessary, or add a chapter 1.4.2.
* For websites, specify the date on which you read the information. To prevent content from disappearing, you can quote URLs using the Internet Archive's “WayBack Machine”.
* Write the document in a continuous flow, without paying attention to spelling or grammar. The idea is to put the ideas in the report in a logical sequence. Don't look for perfect turns of phrase, just write your thoughts as quickly as possible.
* Then make a second pass through your report and take care of the form. Read each paragraph and correct any mistakes.
* The purpose of the report is to document your work, and there's no point in using complicated sentences. Keep it simple, but don't neglect the form.
* Don't use “I/we”, avoid passive sentences. For example:
  * "Nous avons choisi un langage de programmation adapté au problème".
  * "Un langage de programmation adapté au problème a été choisi".
  * "Une comparaison sur différents critères a permis de choisir un langage de programmation adapté au problème".
* Write in the present tense.
* Explain the “why” of things; Avoid "Il est clair que", "il va de soi que", "il faut que", etc.
* Use positive forms for sentences ; Avoid “Malheureusement".
* Avoid "S'occuper de".
* Begin each chapter or sub-chapter with a short introduction.
