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

Ce laboratoire a permis de mettre en place un environnement d'émulation réseau complet basé sur _EVE-NG_ et des routeurs _Arista vEOS_, entièrement déployé par des scripts _Python_ automatisés. La topologie en anneau de quatre routeurs avec ses huit hôtes _VPCS_ a été construite et câblée de manière programmatique via l'_API REST_ et _SFTP_. Les tests de connectivité intra-_LAN_ ont été concluants (4/4 pings réussis), ce qui confirme la validité du câblage virtuel et de la configuration des hôtes. En revanche, la convergence _OSPF_ n'a pas pu être obtenue, et les pings inter-_LAN_ ont échoué dans leur intégralité (0/12). La principale limitation identifiée réside dans la lenteur extrême de l'émulation _TCG_ (sans _KVM_), qui rend l'application de la configuration _EOS_ difficile à orchestrer de manière fiable.

Ce travail met en lumière les contraintes pratiques liées à l'utilisation d'_EVE-NG Community_ sans accélération matérielle : des temps de démarrage proches d'une heure par routeur et une _API REST_ incomplète pour le câblage des interfaces. La comparaison avec _GNS3_ suggère que ce dernier offrirait une expérience plus fluide pour des labs mono-utilisateur nécessitant une interaction rapide. Sur le plan méthodologique, l'approche d'automatisation adoptée — construction du fichier `.unl` en mémoire et déploiement via _SFTP_, s'est révélée robuste et reproductible. Les outils _Arista_ tels que `pyeapi` et `eAPI` restent des pistes prometteuses pour pousser la configuration sans dépendre du mécanisme de `startup-config` d'_EVE-NG_. Ce laboratoire constitue une introduction solide aux enjeux d'automatisation et de programmabilité des réseaux dans un contexte _SDN_ réel.
