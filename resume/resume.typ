#import "@preview/note-me:0.6.0": *

// === Optimisation espace ===
#set page(margin: (x: 1.5cm, y: 1.5cm), columns: 2)
#set text(size: 8pt)
#set par(leading: 0.5em, spacing: 0.8em)
#set list(spacing: 0.3em)
#set enum(spacing: 0.3em)
#show heading: it => {
  v(0.3em, weak: true)
  it
  v(0.2em, weak: true)
}

#text(red, "")
#text(purple, $$)

= Réseau 4G

#text(red, "Evolved Packet System (EPS)"): = Réseau 4G séparé en RAN ete CN.
#text(red, "Radio Access Network (RAN)"): User Equipement (UE), communication sans fil (Air Interface), station de base evolved Node B (eNodeB).
#text(red, "Core Network (CN)"): Coeur du réseau = Evolved Packet Core (EPC), basé sur IP, plus de commutation circuit tout est packet switched.

#image("img/4g_network.png", width: 100%)

Différentes taille de cellules pour optimiser la couverture et la capacité selon l'environnement. Plus elle est petite, plus elle est déployé dans zones denses avec beaucoup d'utilisateurs concentrés.
#text(red, "Femtocell"): Usage domestique/entreprise, 8-16 users, petite portée, indoor
#text(red, "Picocell"): Entreprise et zones à forte densités, portée légèrement supérieur à Femtocell
#text(red, "Microcell/Metrocell"): Zone à forte densité et indoor, ~64 users
#text(red, "Meadowcell/Macrocell"): Zones urbaines extérieurs, 50-200 users, grande portée

= Théorie de l'information

#text(red, "Entropie"): mesure la quantité d'information moyenne (en bits) =~ le degré d'incertitude sur le prochain symbole émis #text(purple, $H(X) = −∑ p(x) · log₂(p(x))$)
#text(red, "Shannon-Hartley"): Débit maximal auquel il existe un code permettant un taux d'erreur arbitrairement faible = #text(purple, $C = B_p · log_2(1 + P_"signal"/P_"bruit")$), $B_p$ = bande passante (Hz), $P$ = puissance (Watts) ; SNR = rapport signal/bruit — plus SNR est élevé, plus la capacité C est grande
#text(red, "Théorème 1"): On peut compresser jusqu’à l’Entropie
#text(red, "Théorème 2"): Si le débit est inférieur à la capacité du canal, le taux d’erreur peut tendre vers zéro moyennant un code correcteur
#text(red, "Théorème 3"): La sécurité parfaite si : La clef est au moins aussi longue que le message, la clef est choisie uniformément au hasard et n'est utilisée qu'une seule fois

= Evolution

Naming is driven by marketing, not standards. Each generation ~10 years apart.

#table(
  columns: (auto, auto, auto, auto),
  inset: 3pt,
  stroke: 0.4pt,
  align: center,
  table.header[*Gen*][*Focus*][*Voix*][*Data*],
  [1G (1980)], [Analogique], [Circuit (CS)], [—],
  [2G (1990)], [Numérique], [Circuit (CS)], [Packet (PS)],
  [3G (2000)], [Data], [Circuit (CS)], [Packet (PS)],
  [4G (2010)], [Débit], [Packet (PS)], [Packet (PS)],
  [5G (2020)], [Latence], [Packet (PS)], [Packet (PS)],
  [6G (2030)], [Haute fréq.], [Packet (PS)], [Packet (PS)],
)

Tendances clés :
*Circuit Switched → Packet Switched*: dès la 4G, tout est IP — la voix passe par VoLTE (voix sur paquets)
*NFV / SDN*: les fonctions réseau autrefois câblées en hardware sont maintenant des logiciels virtualisés (ex. un smartphone remplace caméra, radio, GPS, lecteur…)

#image("img/evolution_triangle.png", width: 100%)

#image("img/evolution_full.png", width: 100%)

*RAN* — partie radio, remplacée à chaque génération :
#text(red, "BTS / GERAN (2G)"): TDMA (partage du temps), FDMA (partage des fréquences), SDMA (partage spatial par secteurs d'antenne).
#text(red, "NodeB / UTRAN (3G)"): W-CDMA — tous les utilisateurs partagent la même fréquence, séparés par un code unique (étalement de spectre).
#text(red, "eNodeB / E-UTRAN (4G)"): OFDM — divise la bande en sous-porteuses étroites pour résister aux trajets multiples ; MIMO — plusieurs antennes en émission et réception pour augmenter le débit ; MU-MIMO — MIMO multi-utilisateurs, plusieurs UE servis simultanément.
#text(red, "gNodeB / NG-RAN (5G)"): massive MIMO, mmWave (52–71 GHz), Edge computing, V2X (véhicules connectés), NFV/SDN.
*Core Network* — évolue mais réutilise autant que possible :
#text(red, "CS Core (MSC + GMSC)"): commutation circuit — voix/SMS pour 2G/3G.
#text(red, "PS Core (SGSN + GGSN)"): commutation paquet — data pour 2G/3G.
#text(red, "EPC (MME + S-GW + P-GW)"): tout IP — 4G, plus de CS.
#text(red, "5G Core (AMF + SMF + UPF)"): cloud-native — 5G.
*Services partagés* :
#text(red, "HLR → HSS"): base de données abonnés (évolue mais reste présente).
#text(red, "IMS"): gère la voix sur IP (VoLTE) pour 4G/5G.
#text(red, "Q&M + Charging"): supervision et facturation, communs à toutes les générations.

= Contraintes

*Economique*: Time to Market, Economy of Scale, Economy of Scope, Energy optimization, Autonomy, User Centric, User Experience, Ubiquitous.
*Techniques*: Couverture globale, Convergence IP, Convergence Fixe_Mobile, Zero_Trust Security, Cross-Layring Security, Couverture Globale, Latence et Gigue, Débit, SDN, Réseaux Privés Open-RAN.

// TODO to remove if not enough space
#image("img/chart_of_elec_spectrum.png", width: 100%)

= Fréquence

#text(red, "Types d'affaiblissement du signal radio"):
*Trajet (path loss)*: le signal s'atténue avec la distance.
*Absorption*: les matériaux (murs, corps humain) absorbent l'énergie.
*Atmosphère / eau*: pics d'absorption à 60 GHz (O₂) et 180 GHz (H₂O).
*Diffraction*: le signal contourne les obstacles mais perd de l'énergie.
*Evanouissement (fading)*: interférences entre trajets multiples (multi-path).

#image("img/affaiblissement_type.png", width: 100%)

#text(red, "Path loss models"): A = affaiblissement en dB entre l'émetteur et le récepteur.
*LOS*: ligne de vue dégagée (ex. campagne), Plus la fréquence est haute → plus ça atténue, Plus la distance est grande → plus ça atténue, #text(purple, $A = 32 + 20 log(F_"MHz") + 20 log(d_"km")$)
*NLOS*: obstacles, #text(purple, $A = 32 + a dot 20 log(F_"MHz") + b dot 20 log(d_"km"), 1 < a < 2, 1 < b < 3$)

#text(red, "Frequency selection"): Trade-off entre portée, pénétration et capacité.
*Basse fréquence*: pénètre mieux les murs, portée plus grande, plus d'utilisateurs par cellule
*Haute fréquence*: atténuation élevée, se reflète sur les murs, mauvaise pénétration indoor — mais bande passante plus large → débits plus élevés

= Mobile / Wi-Fi

// TODO remove if not enough space

#table(
  columns: (auto, auto, auto, auto, auto),
  inset: 3pt,
  stroke: 0.4pt,
  align: center,
  table.header[*Standard*][*Nom*][*Fréq.*][*Débit max*][*Portée max*],
  [802.11a], [Wi-Fi 1], [5 GHz], [54 Mbps], [~120 m],
  [802.11b], [Wi-Fi 2], [2.4 GHz], [11 Mbps], [~140 m],
  [802.11g], [Wi-Fi 3], [2.4 GHz], [54 Mbps], [~140 m],
  [802.11n], [Wi-Fi 4], [2.4/5 GHz], [600 Mbps], [~250 m],
  [802.11ac], [Wi-Fi 5], [5 GHz], [1 Gbps], [~300 m],
  [802.11ac Wave2], [Wi-Fi 5 v2], [5 GHz], [3.47 Gbps], [10 m],
  [802.11ad], [WiGig], [60 GHz], [7 Gbps], [~10 m],
  [802.11af], [White-Fi], [2.4/5 GHz], [26.7–569 Mbps], [1000 m],
  [802.11ah], [HaLow], [2.4/5 GHz], [347 Mbps], [1000 m],
  [802.11ax], [Wi-Fi 6], [2.4/5 GHz], [10 Gbps], [~300 m],
  [802.11ay], [WiGig 2], [60 GHz], [100 Gbps], [300–500 m],
  [802.11az], [Sensing], [60 GHz], [localisation], [$<$1 m],
)

= TDD / FDD

Les deux méthodes permettent la communication bidirectionnelle (UL = uplink mobile→antenne, DL = downlink antenne→mobile).
#text(red, "FDD (Frequency Division Duplex)"): UL et DL sur deux fréquences différentes simultanément, simple à implémenter, pas de synchronisation, nécessite un spectre paired (deux bandes séparées), ratio UL/DL fixe
#text(red, "TDD (Time Division Duplex)"): UL et DL sur la même fréquence, synchronisation réseau obligatoire, une seule bande suffit (pas de spectre paired), Ratio UL/DL ajustable dynamiquement → adapté au trafic asymétrique (ex. streaming)

#image("img/fdd.png", width: 100%)
#image("img/tdd.png", width: 100%)

= Latence & Gigue

#text(red, "Latence (one-way)"): temps pour qu'un paquet aille de la source à la destination = la moitié du ping.
#text(red, "RTT (Round Trip Time)"): temps aller-retour = ping complet.
#text(red, "Gigue (Jitter)"): variation de la latence entre paquets successifs, problématique pour la voix/vidéo en temps réel.
#text(red, "E2E Latency"): mesurée à l'interface de communication, du moment d'émission au moment de réception.

#table(
  columns: (auto, auto),
  inset: 3pt,
  stroke: 0.4pt,
  align: center,
  table.header[*Génération*][*Latence*],
  [1G], [non pertinente],
  [2G], [300–600 ms],
  [3G], [100–500 ms],
  [4G LTE], [50–100 ms],
  [4G LTE-A], [20 ms],
  [5G], [1–10 ms],
)

= GSM

#text(red, "GSM (Global System for Mobile Communications)"): Standard 2G (1991) — réseau numérique voix + SMS, données lentes, voix en Circuit Switched.
#image("img/gsm_arch.png", width: 100%)
*RAN (Radio Access Network)*
#text(red, "BTS"): antenne radio, communique avec le mobile via l'interface air.
#text(red, "BSC"): contrôle plusieurs BTS, gère l'allocation des canaux radio et le handover.
*Core Network*
#text(red, "MSC"): nœud central de commutation, route les appels voix et gère la mobilité.
#text(red, "GMSC"): passerelle vers le réseau téléphonique fixe (PSTN).
*Bases de données*
#text(red, "HLR"): base permanente des abonnés , contient le profil, les services autorisés et la localisation courante.
#text(red, "VLR"): copie locale du HLR pour les abonnés présents dans la zone du MSC (évite des requêtes HLR constantes).
#text(red, "AuC"): stocke les clés d'authentification (Ki) et génère les triplets de sécurité.
#text(red, "EIR"): vérifie si l'équipement (IMEI) est autorisé, volé ou défectueux.
#text(red, "OMC"): supervision et maintenance du réseau.
*Mobile (UE)*
#text(red, "ME (Mobile Equipment)"): l'appareil physique, identifié par l'*IMEI* (numéro unique du terminal).
#text(red, "SIM"): carte à puce contenant les clés et identifiants de l'abonné.
#text(red, "Ki"): clé secrète d'authentification (jamais transmise sur le réseau).
#text(red, "IMSI"): identité permanente de l'abonné (stockée dans la SIM et le HLR).
#text(red, "TMSI"): alias temporaire remplaçant l'IMSI sur l'interface radio (protection de la vie privée).
#text(red, "MSISDN"): le numéro de téléphone composé.
#text(red, "LAI"): identifiant de la zone de localisation courante de l'abonné.
#text(red, "PIN"): code protégeant l'accès à la SIM.
#text(red, "UMTS (Universal Mobile Telecommunications System)"): Standard 3G (2001) même cœur que GSM, voix toujours CS, data en PS.
#image("img/umts.png", width: 100%)
#text(red, "RNC (Radio Network Controller)"): remplace le BSC, contrôle plusieurs NodeB, gère handover, allocation de ressources radio et chiffrement.
#text(red, "SGSN (Serving GPRS Support Node)"): nœud data du cœur, gère la mobilité et l'authentification pour le trafic paquet, achemine les données entre le RNC et le GGSN.
#text(red, "GGSN (Gateway GPRS Support Node)"): passerelle entre le réseau mobile et Internet, attribue les adresses IP aux mobiles et route le trafic vers l'extérieur.

= LTE (4G)

#image("img/lte_arch.png", width: 100%)
*E-UTRAN (Radio)*
#text(red, "eNodeB"): station de base 4G, gère l'interface radio avec l'UE et communique directement entre eNodeB voisins pour les handovers.
*EPC — Control Plane*
#text(red, "MME (Mobility Management Entity)"): nœud de signalisation principal, authentification, gestion de la mobilité et des sessions, pagination.
#text(red, "HSS (Home Subscriber Server)"): remplace le HLR, base de données des abonnés et clés de sécurité.
#text(red, "PCRF (Policy Charging Rules Function)"): définit les règles de QoS et de facturation en temps réel — décide la priorité de chaque flux (ex. VoLTE prioritaire sur YouTube).
#text(red, "OCS (Online Charging System)"): facturation prepaid en temps réel — peut couper ou adapter le service si le crédit est épuisé.
*EPC — User Plane*
#text(red, "S-GW (Serving Gateway)"): passerelle data côté RAN, route les paquets entre eNodeB et P-GW, ancrage local lors des handovers.
#text(red, "P-GW (Packet Gateway)"): passerelle vers Internet, attribue les adresses IP, applique les règles définies par le PCRF.
*Protocoles*
#text(red, "AS (Access Stratum)"): protocoles entre UE et eNodeB (interface radio).
#text(red, "NAS (Non-Access Stratum)"): protocoles entre UE et MME (mobilité, authentification), transparent au eNodeB.
*Sécurité LTE*: Réutilise l'AKA (Authentication and Key Agreement) d'UMTS, hiérarchie de clés étendue, protection renforcée du backhaul.

*QoS — QCI (QoS Class Identifier)* : en cas de congestion radio, les flux sont priorisés par QCI.
#text(red, "GBR (Guaranteed Bit Rate)"): bande passante réservée — utilisé pour voix/vidéo temps réel.
#text(red, "non-GBR (Best Effort)"): pas de garantie — utilisé pour internet, email.
Priorités : VoLTE signaling (1er, QCI 5) → voix (QCI 1) → gaming/V2X (QCI 3) → vidéo live (QCI 2) → vidéo buffered (QCI 4) → internet (QCI 6–9).

= SLA for Industry Digital Transformation

Définit un SLA réseau 5G industriel selon *3 axes* :
*Capabilities*: Bandwidth, Latency, Jitter, Packet Loss Rate, Availability, High Precise Positioning, WAN/LAN Networking
*Operation*: DIY Operation → Self-management → Self-provisioning → Self-operation → Self-define Network → Online/Offline Order → Dedicated Network
*Security*: Data/Signaling Protection → Isolation Level → Secure Level

= IMS Architecture

#text(red, "IMS (IP Multimedia Subsystem)"): couche middleware au-dessus du réseau IP qui fournit des services multimédia (voix, vidéo, messagerie) indépendamment du type d'accès (LTE, Wi-Fi, DSL…).

#image("img/ims_arch.png", width: 100%)
#image("img/ims_network.png", width: 100%)

*Couches IMS :*
#text(red, "Access Layer"): réseaux d'accès hétérogènes — GSM/GERAN, UMTS/UTRAN, WLAN, xDSL, CDMA, PSTN.
#text(red, "Session Control Layer"): cœur IMS — gestion des sessions SIP.
#text(red, "P-CSCF (Proxy)"): premier point de contact de l'UE dans IMS, transfère les requêtes SIP.
#text(red, "I-CSCF (Interrogating)"): point d'entrée du réseau IMS, interroge le HSS pour trouver le S-CSCF.
#text(red, "S-CSCF (Serving)"): nœud central — gère les sessions, l'enregistrement et applique les services.
#text(red, "MGCF (Media Gateway Control Function)"): contrôle la passerelle vers le PSTN (réseau téléphonique).
#text(red, "MGW (Media Gateway)"): convertit les flux media entre IP et PSTN.
#text(red, "MRF (Media Resource Function)"): gère les ressources media (conférences, annonces).
#text(red, "HSS"): base de données abonnés IMS (profils, authentification).
#text(red, "Service Layer"): serveurs d'applications — SIP AS, Parlay/OSA (APIs ouvertes vers les AS).
#text(red, "Application Layer"): services finaux — conférence, partage de ressources, broadcasting, jeux…
*Protocoles* : *SIP* (signalisation sessions), *Diameter* (AAA entre HSS et CSCF), *H.248* (contrôle MGW).

= VoLTE

#text(red, "VoLTE (Voice over LTE)"): transport de la voix sur le réseau 4G LTE en tout-IP via IMS — au lieu d'un circuit dédié, la voix est un flux paquet SIP comme les données.
#image("img/volte_1.png", width: 100%)
*Avantages* : HD Voice, établissement d'appel rapide (~0.25s), coexistence voix+data sur la même connexion LTE.
#image("img/volte_2.png", width: 100%)
*Chaîne de bout en bout* :
#text(red, "1. UE (SIP-enabled)"): smartphone avec SIP User Agent — gère la signalisation SIP.
#text(red, "2. LTE Network"): transport radio + EPC — achemine les paquets voix/signalisation.
#text(red, "3. IMS Core"): traite la signalisation SIP, gère la session d'appel.
#text(red, "4. Voice Core / PSTN"): si l'appelé est sur le réseau fixe ou une autre génération.
*Identités IMS dans la UICC* :
#text(red, "UICC (Universal Integrated Circuit Card)"): successeur de la SIM pour IMS, contient IMPI et IMPU.
#text(red, "IMPI (IMS Private User Identity)"): identité permanente et privée de l'abonné IMS — jamais transmise sur le réseau, utilisée uniquement pour l'authentification.
#text(red, "IMPU (IMS Public User Identity)"): identité publique de l'abonné IMS — adresse SIP ou tel-URI utilisée pour joindre l'abonné (équivalent du numéro de téléphone).
*Drivers clés d'IMS* : Access agnostic (fonctionne sur LTE, Wi-Fi, DSL…), services indépendants du réseau, architecture ouverte, multi-device, vendor independent.

*Changements réseau pour supporter VoLTE* :
#text(red, "SGW/PGW"): activer bearers dédiés (QCI 1 et 5), pool IP IMS, routage vers P-CSCF.
#text(red, "MME"): configurer SRVCC, sélection gateway IMS, politique de paging VoLTE, validation QCI 1 et 5.
#text(red, "MSS/MSC"): lien SRVCC, routage IP vers MGW/IMS, codec commun entre réseau voix et IMS.
#text(red, "SRVCC (Single Radio Voice Call Continuity)"): transfère un appel VoLTE vers un appel circuit 2G/3G sans le couper quand l'UE sort de la couverture LTE.

= IPCAN

#text(red, "IP-CAN (IP Connectivity Access Network)"): réseau qui fournit la connectivité IP entre l'UE et le cœur IMS — peut être LTE, Wi-Fi, DSL ou câble. C'est ce qui rend IMS *access-agnostic* : le même cœur IMS/SIP fonctionne quel que soit le type d'accès.
#text(red, "Media Gateway (MGW)"): convertit les flux media entre le réseau IP et le PSTN — nécessaire quand l'appelé est sur le réseau téléphonique fixe.

#image("img/ipcan.png", width: 100%)
