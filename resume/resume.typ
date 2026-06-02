#import "@preview/note-me:0.6.0": *

// === Optimisation espace ===
#set page(margin: (x: 1.5cm, y: 1.5cm), columns: 2)
#set text(size: 7pt)
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

= Autres

*Théorie de l'information*
#text(red, "Entropie"): mesure la quantité d'information moyenne (en bits) =~ le degré d'incertitude sur le prochain symbole émis #text(purple, $H(X) = −∑ p(x) · log₂(p(x))$)
#text(red, "Shannon-Hartley"): Débit maximal auquel il existe un code permettant un taux d'erreur arbitrairement faible = #text(purple, $C = B_p · log_2(1 + P_"signal"/P_"bruit")$), $B_p$ = bande passante (Hz), $P$ = puissance (Watts) ; SNR = rapport signal/bruit — plus SNR est élevé, plus la capacité C est grande
#text(red, "Théorème 1"): On peut compresser jusqu’à l’Entropie
#text(red, "Théorème 2"): Si le débit est inférieur à la capacité du canal, le taux d’erreur peut tendre vers zéro moyennant un code correcteur
#text(red, "Théorème 3"): La sécurité parfaite si : La clef est au moins aussi longue que le message, la clef est choisie uniformément au hasard et n'est utilisée qu'une seule fois
*Contraintes clés pour les réseaux de communication*
#text(red, "Economique"): Time to Market, Economy of Scale, Economy of Scope, Energy optimization, Autonomy, User Centric, User Experience, Ubiquitous.
#text(red, "Techniques"): Couverture globale, Convergence IP, Convergence Fixe_Mobile, Zero_Trust Security, Cross-Layring Security, Couverture Globale, Latence et Gigue, Débit, SDN, Réseaux Privés Open-RAN.
// TODO to remove if not enough space
#image("img/chart_of_elec_spectrum.png", width: 100%)
*SLA for Industry Digital Transformation* définit un SLA réseau 5G industriel selon *3 axes* :
#text(red, "Capabilities"): Bandwidth, Latency, Jitter, Packet Loss Rate, Availability, High Precise Positioning, WAN/LAN Networking
#text(red, "Operation"): DIY Operation, Self-management, Self-provisioning, Self-operation, Self-define Network, Online/Offline Order, Dedicated Network
#text(red, "Security"): Data/Signaling Protection, Isolation Level, Secure Level
*TDD / FDD*:
Les deux méthodes permettent la communication bidirectionnelle (UL = uplink mobile→antenne, DL = downlink antenne→mobile).
#text(red, "FDD (Frequency Division Duplex)"): UL et DL sur deux fréquences différentes simultanément, simple à implémenter, pas de synchronisation, nécessite un spectre paired (deux bandes séparées), ratio UL/DL fixe.
#text(red, "TDD (Time Division Duplex)"): UL et DL sur la même fréquence, synchronisation réseau obligatoire, une seule bande suffit (pas de spectre paired), Ratio UL/DL ajustable dynamiquement adapté au trafic asymétrique (ex. streaming)
#grid(
  columns: 2,
  gutter: 4pt,
  image("img/fdd.png", width: 100%), image("img/tdd.png", width: 100%),
)
#grid(
  columns: (1fr, auto),
  gutter: 4pt,
  [*Latence & Gigue*
    #text(red, "Latence (one-way)"): temps pour qu'un paquet aille de la source à la destination = la moitié du ping.
    #text(red, "RTT (Round Trip Time)"): temps aller-retour = ping complet.
    #text(red, "Gigue (Jitter)"): variation de la latence entre paquets successifs, problématique pour la voix/vidéo en temps réel.
    #text(red, "E2E Latency"): mesurée à l'interface de communication, du moment d'émission au moment de réception.],
  table(
    columns: (auto, auto),
    inset: 3pt,
    stroke: 0.4pt,
    align: center,
    table.header[*Gén.*][*Latence*],
    [1G], [n/a],
    [2G], [300–600 ms],
    [3G], [100–500 ms],
    [4G LTE], [50–100 ms],
    [4G LTE-A], [20 ms],
    [5G], [1–10 ms],
  ),
)

= Fréquence

#grid(
  columns: (1fr, 1fr),
  gutter: 4pt,
  [#text(red, "Types d'affaiblissement du signal radio"):
    *Trajet (path loss)*: le signal s'atténue avec la distance.
    *Absorption*: les matériaux (murs, corps humain) absorbent l'énergie.
    *Atmosphère / eau*: pics d'absorption à 60 GHz (O₂) et 180 GHz (H₂O).
    *Diffraction*: le signal contourne les obstacles mais perd de l'énergie.
    *Evanouissement (fading)*: interférences entre trajets multiples (multi-path).],
  image("img/affaiblissement_type.png", width: 100%),
)

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

= GSM (2G)

#image("img/gsm_arch.png", width: 100%)
#text(red, "Global System for Mobile Communications (GSM)"): Famile de standards pour décrire les protocoles 2G (réseau numérique voix + SMS, données lentes, voix en Circuit Switched).
*RAN (Radio Access Network)*
#text(red, "Base Transceiver Station (BTS)"): antenne radio, communique avec le mobile via l'interface air.
#text(red, "Base Station Controller (BSC)"): contrôle plusieurs BTS, gère l'allocation des canaux radio et le handover.
*Core Network*
#text(red, "Mobile Switching Center (MSC)"): nœud central de commutation, route les appels voix et gère la mobilité.
#text(red, "Operation and Maintenance Center (OMC)"): supervision et maintenance du réseau.
*Bases de données*
#text(red, "Home Location Register (HLR)"): base permanente des abonnés , contient le profil, les services autorisés et la localisation courante.
#text(red, "Visitor Location Register (VLR)"): copie locale du HLR pour les abonnés présents dans la zone du MSC (évite des requêtes HLR constantes).
#text(red, "Authentication Center (AuC)"): stocke les clés d'authentification (Ki) et génère les triplets de sécurité.
#text(red, "Equipment Identity Register (EIR)"): vérifie si l'équipement (IMEI) est autorisé, volé ou défectueux.
*Mobile (UE)*
#text(red, "ME (Mobile Equipment)"): l'appareil physique, identifié par l'IMEI.
#text(red, "Subscriber Identity Module (SIM)"): carte à puce contenant les clés et identifiants de l'abonné.
#text(red, "International Mobile Equipment Identity (IMEI)"): numéro unique du terminal.
#text(red, "Subscriber Authentication Key (Ki)"): clé secrète d'authentification (jamais transmise sur le réseau).
#text(red, "International Mobile Subscriber Identity (IMSI)"): identité permanente de l'abonné (stockée dans la SIM et le HLR).
#text(red, "Temporary Mobile Subscriber Identity (TMSI)"): alias temporaire remplaçant l'IMSI sur l'interface radio (protection de la vie privée).
#text(red, "Mobile Station International Service Digital Network (MSISDN)"): le numéro de téléphone composé.
#text(red, "Location Area Identity (LAI)"): identifiant de la zone de localisation courante de l'abonné.
#text(red, "Personal Identity Number (PIN)"): code protégeant l'accès à la SIM.

= UMTS (3G)

#image("img/umts.png", width: 100%)
#text(red, "UMTS (Universal Mobile Telecommunications System)"): technologie téléphonie mobile 3G, successeur de GSM..
#text(red, "Radio Network Controller (RNC)"): remplace le BSC, contrôle plusieurs NodeB, gère handover, allocation de ressources radio et chiffrement.
#text(red, "Gateway Mobile Switching Center (GMSC)"): point de sortie du réseau vers d'autres réseaux (PSTN, autres opérateurs).
#text(red, "Serving GPRS Support Node (SGSN)"): nœud data du cœur, gère la mobilité et l'authentification pour le trafic paquet, achemine les données entre le RNC et le GGSN.
#text(red, "Gateway GPRS Support Node (GGSN)"): passerelle entre le réseau mobile et Internet, attribue les adresses IP aux mobiles et route le trafic vers l'extérieur.
#text(red, "USIM (Universal Subscriber Identity Module)"): version 3G de la SIM, supporte l'AKA (Authentication and Key Agreement) et permet l'authentification mutuelle : le terminal peut aussi authentifier le réseau (protection contre les fausses stations de base).
#text(red, "eNodeB"): station de base UMTS, connectée au RNC via l'interface Iub, gère l'interface radio WCDMA avec les terminaux.

= LTE (4G)

#image("img/4g_network.png", width: 100%)
#text(red, "Evolved Packet System (EPS)"): = Réseau 4G séparé en RAN et CN.
#text(red, "Radio Access Network (RAN)"): User Equipement (UE), communication sans fil (Air Interface), station de base evolved Node B (eNodeB).
#text(red, "Core Network (CN)"): Coeur du réseau = Evolved Packet Core (EPC), basé sur IP, plus de commutation circuit tout est packet switched.
*Taille de cellules* Différentes tailles pour optimiser la couverture et la capacité selon l'environnement. Plus elle est petite, plus elle est déployé dans zones denses avec beaucoup d'utilisateurs concentrés.
#text(red, "Femtocell"): Usage domestique/entreprise, 8-16 users, petite portée, indoor
#text(red, "Picocell"): Entreprise et zones à forte densités, portée légèrement supérieur à Femtocell
#text(red, "Microcell/Metrocell"): Zone à forte densité et indoor, ~64 users
#text(red, "Meadowcell/Macrocell"): Zones urbaines extérieurs, 50-200 users, grande portée

#image("img/lte_arch.png", width: 100%)
#text(red, "Long Term Evolution (LTE)"): technologie 4G, évolution de l'UMTS, tout IP, plus rapide et plus efficace que les générations précédentes.
*E-UTRAN (Radio)*
#text(red, "eNodeB"): station de base 4G, gère l'interface radio avec l'UE et communique directement entre eNodeB voisins pour les handovers.
*EPC — Control Plane*
#text(red, "MME (Mobility Management Entity)"): nœud de signalisation principal, authentification, gestion de la mobilité et des sessions, pagination.
#text(red, "HSS (Home Subscriber Server)"): remplace le HLR, base de données des abonnés et clés de sécurité.
#text(red, "PCRF (Policy Charging Rules Function)"): définit les règles de QoS et de facturation en temps réel, décide la priorité de chaque flux.
#text(red, "OCS (Online Charging System)"): facturation prepaid en temps réel,peut couper ou adapter le service si le crédit est épuisé.
*EPC — User Plane*
#text(red, "S-GW (Serving Gateway)"): passerelle data côté RAN, route les paquets entre eNodeB et P-GW, ancrage local lors des handovers.
#text(red, "P-GW (Packet Gateway)"): passerelle vers Internet, attribue les adresses IP, applique les règles définies par le PCRF.
*Protocoles*
#text(red, "AS (Access Stratum)"): protocoles entre UE et eNodeB (interface radio).
#text(red, "NAS (Non-Access Stratum)"): protocoles entre UE et MME (mobilité, authentification), transparent au eNodeB.
*Sécurité LTE*: Réutilise l'AKA (Authentication and Key Agreement) d'UMTS, hiérarchie de clés étendue, protection renforcée du backhaul.
*QoS — QCI (QoS Class Identifier)*: en cas de congestion radio, les flux sont priorisés par QCI.
#text(red, "GBR (Guaranteed Bit Rate)"): bande passante réservée — utilisé pour voix/vidéo temps réel.
#text(red, "non-GBR (Best Effort)"): pas de garantie — utilisé pour internet, email.
Priorités : VoLTE signaling (1er, QCI 5) → voix (QCI 1) → gaming/V2X (QCI 3) → vidéo live (QCI 2) → vidéo buffered (QCI 4) → internet (QCI 6–9).

= 5G

*Objectifs 5G* (IMT-2020) :
#grid(
  columns: (1fr, 1fr),
  gutter: 4pt,
  [
    - \>10 Gbps débit crête
    - 100 Mbps partout (ubiquitous)
    - 10 000× plus de trafic que 4G
    - 100× plus d'appareils que 4G
  ],
  [
    - \<1 ms latence radio
    - Ultra-fiabilité (URLLC)
    - 10 ans autonomie batterie (IoT)
    - M2M ultra low cost
  ],
)
*3 cas d'usage* (triangle 5G) :
#text(red, "eMBB (enhanced Mobile Broadband)"): haut débit amélioré — 4K/3D, AR/VR, cloud, Gbps en mobilité.
#text(red, "URLLC (Ultra-Reliable Low-Latency Communications)"): ultra-fiable et faible latence — voiture autonome, automation industrielle/V2X.
#text(red, "mMTC (massive Machine Type Communications)"): connectivité massive IoT — smart home, smart city, capteurs, M2M, 10 ans de batterie.
*SA vs NSA* :
#text(red, "5G NSA (Non-Standalone)"): radio 5G (gNB) + core 4G (EPC) — déploiement rapide, ne libère pas tout le potentiel 5G.
#text(red, "5G SA (Standalone)"): radio 5G + 5G Core dédié — plein potentiel : ultra-low latency, network slicing, cloud-native.
#image("img/5g_network.png", width: 100%)
#image("img/5g_2.png", width: 100%)
*5G Core — Control Plane* :
#text(red, "AMF (Access & Mobility Function)"): remplace le MME — registration, connection, reachability, mobility management. Interface N2 (gNB) et N1 (UE).
#text(red, "SMF (Session Management Function)"): gestion des sessions PDU, allocation IP, QoS SLAs, roaming, charging, lawful intercept. Interface N4 (UPF).
#text(red, "AUSF (Authentication Server Function)"): remplace l'AuC — authentification des UE.
#text(red, "UDM (Unified Data Management)"): remplace le HSS — base abonnés avec UDC (User Data Convergence). Séparé en UDM + UDR (stockage) + UDSF.
#text(red, "PCF (Policy Control Function)"): remplace le PCRF — politiques de QoS et facturation.
#text(red, "NSSF (Network Slice Selection Function)"): sélection du slice réseau approprié pour chaque UE.
#text(red, "NEF (Network Exposure Function)"): exposition sécurisée des fonctions réseau aux applications tierces.
#text(red, "NRF (NF Repository Function)"): registre des fonctions réseau (service discovery).
*5G Core — User Plane* :
#text(red, "UPF (User Plane Function)"): remplace S-GW + P-GW — routage des paquets, application des QoS, reporting usage. Interface N3 (gNB) et N6 (DN/Internet).
*RAN 5G* :
#text(red, "gNB (gNodeB)"): divisé en CU (Central Unit) + DU (Distributed Unit) — ORAN Split 7.2 entre radio et DU, Midhaul (Split 2) entre DU et CU.
#text(red, "SBI (Service-Based Interface)"): architecture 5G Core orientée services — chaque NF expose une API REST, remplace les interfaces point-à-point.
*Interfaces N* : N1 (UE↔AMF), N2 (gNB↔AMF), N3 (gNB↔UPF), N4 (SMF↔UPF), N6 (UPF↔Internet/DN).
#image("img/private_5g.png", width: 100%)
*Réseau privé 5G* : tout logiciel sur COTS HW (hardware standard) — DU + CU + Packet Core déployés on-premise, connectés à un DN privé.

= Evolution

Naming is driven by marketing, not standards. Each generation ~10 years apart.
Tendances clés :
*Circuit Switched → Packet Switched*: dès la 4G, tout est IP, la voix passe par VoLTE (voix sur paquets)
*NFV / SDN*: les fonctions réseau autrefois câblées en hardware sont maintenant des logiciels virtualisés (ex. un smartphone remplace caméra, radio, GPS, lecteur…)
#grid(
  columns: (auto, 1fr),
  gutter: 4pt,
  table(
    columns: (auto, auto, auto, auto),
    inset: 3pt,
    stroke: 0.4pt,
    align: center,
    table.header[*Gen*][*Focus*][*Voix*][*Data*],
    [1G (1980)], [Analogique], [CS], [—],
    [2G (1990)], [Numérique], [CS], [PS],
    [3G (2000)], [Data], [CS], [PS],
    [4G (2010)], [Débit], [PS], [PS],
    [5G (2020)], [Latence], [PS], [PS],
    [6G (2030)], [Haute fréq.], [PS], [PS],
  ),
  image("img/evolution_triangle.png", width: 100%),
)
#image("img/evolution_full.png", width: 100%)
*RAN* (technologie d'accès radio, remplacée à chaque génération) :
#text(red, "BTS / GERAN (2G)"): TDMA (temps), FDMA (fréquences), SDMA (secteurs d'antenne).
#text(red, "NodeB / UTRAN (3G)"): W-CDMA — même fréquence pour tous, séparation par code unique (étalement de spectre).
#text(red, "eNodeB / E-UTRAN (4G)"): OFDM (sous-porteuses étroites, résiste aux trajets multiples), MIMO / MU-MIMO (antennes multiples, multi-utilisateurs).
#text(red, "gNodeB / NG-RAN (5G)"): massive MIMO, mmWave (52–71 GHz), Edge computing, V2X, NFV/SDN.
*Core Network* (évolue par strates, réutilise autant que possible) :
#text(red, "CS Core (MSC + GMSC)"): commutation circuit — voix/SMS 2G/3G.
#text(red, "PS Core (SGSN + GGSN)"): commutation paquet — data 2G/3G.
#text(red, "EPC (MME + S-GW + P-GW)"): tout-IP — 4G, plus de CS.
#text(red, "5G Core (AMF + SMF + UPF)"): cloud-native, séparation control/user plane — 5G.
*Services transverses* : HLR → HSS (abonnés), IMS (VoLTE), OCS/Charging (facturation).
*Migration 4G > 5G*:
#image("img/4g_network.png", width: 100%)

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

= TCP/UDP/SCTP/MPTCP

*Motivation* : migration PSTN → packet, signalisation téléphonique, ni TCP ni UDP n'est adapté.
#text(red, "TCP"): fiable, orienté bytes, mais head-of-line blocking, pas de multi-homing, vulnérable DoS (SYN flood).
#text(red, "UDP"): orienté messages, mais sans fiabilité, sans contrôle de congestion ni de flux.
*SCTP (Stream Control Transmission Protocol)*: combine le meilleur des deux.
#text(red, "Fiable"): acquittements, retransmissions comme TCP.
#text(red, "Orienté messages"): préserve les frontières de messages (contrairement à TCP).
#text(red, "Multi-homing"): une association peut utiliser plusieurs adresses IP, bascule automatique en cas de panne d'un chemin.
#text(red, "Multi-streaming"): plusieurs flux indépendants dans une association — perte sur un flux ne bloque pas les autres (élimine le head-of-line blocking inter-streams).
#text(red, "Sécurité"): handshake 4-way avec mécanisme cookie (INIT > INIT-ACK > COOKIE-ECHO > COOKIE-ACK) — protège contre les attaques SYN flood.
#text(red, "Shutdown"): 3-way (SHUTDOWN > SHUTDOWN-ACK > SHUTDOWN-CMPL), pas d'état half-closed contrairement à TCP.
*Chunks SCTP* (unités de données atomiques, plusieurs peuvent être bundlés dans un même paquet) :
#text(red, "INIT"): initie une association — Verification Tag = 0x0, déclare Initiate Tag, a_rwnd (fenêtre réception), nb flux IN/OUT, Initial TSN.
#text(red, "INIT_ACK"): répond à l'INIT — contient le State Cookie (MAC + timestamp + durée de vie, calculé par le serveur avec une clé secrète) — le serveur reste stateless jusqu'au COOKIE_ECHO (protection DoS).
#text(red, "COOKIE_ECHO"): renvoie le State Cookie reçu dans l'INIT_ACK pour prouver la validité du client.
#text(red, "COOKIE_ACK"): confirme la réception du COOKIE_ECHO — association établie.
#text(red, "DATA"): transporte les données — identifié par TSN (global), SID (flux), SSN (séquence dans le flux), bits B/E (début/fin de fragment), I (SACK immédiat), U (non ordonné).
#text(red, "SACK (Selective ACK)"): acquitte les DATA via Cumulative TSN Ack, signale les écarts (Gap Ack Blocks) et les doublons — plus précis que le ACK TCP.
#text(red, "ASCONF / ASCONF_ACK"): reconfiguration dynamique des adresses IP d'une association active (RFC 5061 ADD-IP) — permet d'ajouter/supprimer une adresse ou changer l'adresse principale sans couper l'association.
#text(red, "HEARTBEAT / HEARTBEAT_ACK"): vérification périodique de la disponibilité de chaque chemin — détecte les pannes et déclenche le basculement sur un chemin alternatif.
*Identifiants clés* :
#text(red, "TSN (Transmission Sequence Number)"): numéro de séquence global à l'association — garantit la livraison fiable indépendamment du flux.
#text(red, "SSN (Stream Sequence Number)"): numéro de séquence local à un flux — garantit l'ordre dans un stream sans bloquer les autres.
#text(red, "Verification Tag"): tag inclus dans chaque paquet (sauf INIT où il vaut 0x0) — valide l'identité de l'émetteur et lie le paquet à l'association.
*MPTCP (Multipath TCP)* — extension de TCP standard, transparent pour les applications.
#text(red, "Transferts transparents"): bascule d'un chemin à l'autre sans couper la connexion TCP — ex. Apple utilise MPTCP sur iPhone (Wi-Fi → 4G sans interruption).
#text(red, "Sélection du meilleur chemin"): choix dynamique selon latence, pertes, coût, bande passante.
#text(red, "Agrégation"): utilisation simultanée de plusieurs chemins pour cumuler les débits — ex. Wi-Fi + 4G en même temps.
*Établissement MPTCP* :
*Connexion principale* : SYN (MP_CAPABLE + clé client) → SYN/ACK (MP_CAPABLE + clé serveur) → ACK (les deux clés).
*Ajout de sous-flux* : SYN (MP_JOIN + token) → SYN/ACK (MP_JOIN + HMAC serveur) → ACK (HMAC client) — HMAC authentifie l'ajout sans nouveau handshake complet.
#text(red, "Paquet MPTCP"): header TCP standard + option MPTCP (Type, Length, Subtype, Version, Flags, données spécifiques au subtype) + Payload — rétrocompatible avec les middleboxes qui ignorent les options TCP inconnues.
*SIP vs H.323*
#text(red, "SIP"): encodage texte, transport TCP/UDP/SCTP, négociation des capacités via SDP (simple), sécurité via protocoles IETF, supporte IM — flexible et extensible.
#text(red, "H.323"): encodage binaire, TCP uniquement, négociation via H.245 (riche mais complexe), sécurité moyenne, pas d'IM.
#text(red, "UAC (User Agent Client)"): entité SIP qui initie les requêtes.
#text(red, "UAS (User Agent Server)"): entité SIP qui reçoit et répond aux requêtes.

= DIAMETER / RADIUS

*Contexte* : Diameter remplace MAP (mobilité/AAA) et CAP (prepaid CAMEL) dans les réseaux modernes — MAP/CAP → Diameter, ISUP/INAP → SIP.
#text(red, "RADIUS (Remote Authentication Dial-In User Service)"): protocole AAA client-serveur sur UDP, centralisé, scalable — Authentication (vérifier identité), Authorization (droits/ressources), Accounting (suivi sessions, facturation, roaming). Ports : auth 1812, accounting 1813.
#text(red, "Diameter"): successeur de RADIUS sur TCP/SCTP, rétrocompatible (AVP codes 1–255 et command codes 0–255 réutilisés) — corrige toutes les limitations de RADIUS.
*Diameter vs RADIUS*
#table(
  columns: (auto, 1fr, 1fr),
  inset: 3pt,
  stroke: 0.4pt,
  align: left,
  table.header[*Critère*][*Diameter*][*RADIUS*],
  [Transport], [TCP + SCTP (orienté connexion)], [UDP (sans connexion)],
  [Sécurité], [Hop-to-Hop + End-to-End], [Hop-to-Hop seulement],
  [Agents], [Relay, Proxy, Redirect, Translation], [Support implicite],
  [Négociation cap.], [Oui (applications + sécurité)], [Non],
  [Peer Discovery], [Statique + dynamique], [Statique seulement],
  [Msg serveur initié], [Oui (re-auth, terminaison)], [Non],
  [Taille max AVP], [16 777 215 octets], [255 octets],
  [Vendor-specific], [Messages + attributs], [Attributs seulement],
)
*Diameter — protocole et structure*
#text(red, "Transport"): clients Diameter MUST support SCTP ou TCP, serveurs/agents MUST support SCTP ET TCP.
#text(red, "Sécurité"): TLS et IPSec — ordre de sélection : IPSec → SCTP/TCP → TLS après négociation.
#text(red, "Message Header"): Version, Length, Flags (R=Request, P=Proxiable, E=Error, T=Re-transmitted), Command Code, Application-ID, Hop-by-Hop ID, End-to-End ID.
#text(red, "AVP (Attribute-Value Pair)"): unité de données Diameter — AVP Code, Flags, Vendor-ID (optionnel), Data.
#text(red, "Result-Code AVP (268)"): présent dans toute réponse Diameter — 1xxx (Info), 2xxx (Succès), 3xxx (Erreurs protocole), 4xxx (Transitoires), 5xxx (Permanentes).
*EAP / WPA2 Enterprise (RADIUS)*
#text(red, "EAP-TLS"): authentification mutuelle forte par certificats — le client et le serveur s'authentifient réciproquement via PKI (CA commune).
#text(red, "WPA2 Enterprise"): Wi-Fi sécurisé via RADIUS + EAP — chaque utilisateur a ses propres credentials, contrairement à WPA2 PSK (clé partagée).
#text(red, "PKI en production"): éviter les certificats auto-signés — utiliser une CA reconnue (interne ou externe), HSM pour stocker les clés privées, procédures de révocation (CRL).

