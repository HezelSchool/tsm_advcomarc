#import "@preview/note-me:0.6.0": *

// === Optimisation espace ===
#set page(margin: (x: 1.5cm, y: 1.5cm), columns: 2)
#set text(size: 6pt)
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

#text(red, "TDMA"): TODO
#text(red, "Roaming"): TODO

= Autres

#text(red, "Entropie"): mesure la quantité d'information moyenne (en bits) =~ le degré d'incertitude sur le prochain symbole émis #text(purple, $H(X) = −∑ p(x) · log₂(p(x))$)
#text(red, "Shannon-Hartley"): Débit maximal auquel il existe un code permettant un taux d'erreur arbitrairement faible = #text(purple, $C = B_p · log_2(1 + P_"signal"/P_"bruit")$), $B_p$ = bande passante (Hz), $P$ = puissance (Watts) ; SNR = rapport signal/bruit — plus SNR est élevé, plus la capacité C est grande
#text(red, "Théorème 1"): On peut compresser jusqu’à l’Entropie
#text(red, "Théorème 2"): Si le débit est inférieur à la capacité du canal, le taux d’erreur peut tendre vers zéro moyennant un code correcteur
#text(red, "Théorème 3"): La sécurité parfaite si : La clef est au moins aussi longue que le message, la clef est choisie uniformément au hasard et n'est utilisée qu'une seule fois
#text(red, "Contraintes Economique"): Time to Market, Economy of Scale, Economy of Scope, Energy optimization, Autonomy, User Centric, User Experience, Ubiquitous.
#text(red, "Contraintes Techniques"): Couverture globale, Convergence IP, Convergence Fixe_Mobile, Zero_Trust Security, Cross-Layring Security, Couverture Globale, Latence et Gigue, Débit, SDN, Réseaux Privés Open-RAN.
// TODO to remove if not enough space
#image("img/chart_of_elec_spectrum.png", width: 100%)
#text(red, "SLA for Industry Digital Transformation"): définit un SLA réseau 5G industriel selon 3 axes : *Capabilities*: Bandwidth, Latency, Jitter, Packet Loss Rate, Availability, High Precise Positioning, WAN/LAN Networking *Operation*: DIY Operation, Self-management, Self-provisioning, Self-operation, Self-define Network, Online/Offline Order, Dedicated Network *Security*: Data/Signaling Protection, Isolation Level, Secure Level
#text(red, "FDD (Frequency Division Duplex)"): Permet la communication bidirectionnelle (UL = uplink mobile→antenne, DL = downlink antenne→mobile), UL et DL sur deux fréquences différentes simultanément, simple à implémenter, pas de synchronisation, nécessite un spectre paired (deux bandes séparées), ratio UL/DL fixe.
#text(red, "TDD (Time Division Duplex)"): Permet la communication bidirectionnelle, UL et DL sur la même fréquence, synchronisation réseau obligatoire, une seule bande suffit (pas de spectre paired), Ratio UL/DL ajustable dynamiquement adapté au trafic asymétrique (ex. streaming)
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
#text(red, "SIP (Session Initiation Protocol)"): protocole de signalisation inspiré de HTTP/SMTP pour établir, modifier et terminer des sessions multimédia (VoIP, vidéo, IM). Encodage texte lisible (INVITE, BYE, ACK...), transport TCP/UDP/SCTP. Délègue la description des paramètres media (codecs, ports) à SDP. Sécurité via TLS (signalisation) + SRTP (media). Architecture pair-à-pair avec serveurs optionnels (proxy, registrar). Flexible, extensible, standard moderne.
#text(red, "H.323"): standard ITU-T (1996) plus ancien pour VoIP d'entreprise. Encodage binaire ASN.1 (compact mais illisible), TCP uniquement. Négociation via H.245 (capabilities exchange très riche mais complexe à implémenter). Pas de messagerie instantanée. Sécurité limitée. Présent dans les systèmes legacy (Cisco, Polycom).
#text(red, "UAC (User Agent Client)"): entité SIP qui initie les requêtes (ex: l'appelant envoie INVITE).
#text(red, "UAS (User Agent Server)"): entité SIP qui reçoit et répond aux requêtes (ex: l'appelé répond 200 OK). Un endpoint est généralement les deux à la fois (User Agent = UAC + UAS).

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

= AMPS (1G)

#text(red, "Advanced Mobile Phone Service (AMPS)"): première génération de système téléphonie moderne à cellule. *Aucune sécurité* : identification via ESN (Electronic Serial Number) + CTN (Cellular Telephone Number) en clair, communications analogiques non chiffrées. Vulnérabilités : écoute passive (eavesdropping) et clonage de mobile.

= GSM (2G)

#image("img/gsm_arch.png", width: 100%)
#text(red, "Global System for Mobile Communications (GSM)"): Famile de standards pour décrire les protocoles 2G (réseau numérique voix + SMS, données lentes, voix en Circuit Switched). Basée sur TDMA radio access et PCM trunking. Utilise SS7 signaling *Securité*: Authentication et encryption => vise à donnée confidentialité et anonymité avec une authentification cliente forte pour protéger les opérateurs contre fraudeurs. Prévenir opérateur compromette la sécurité d'un autre opérateur par inadvertance ou sous pression concurentielle.
#text(red, "Signalling System #7 (SS7)"): suite de protocoles utilisée par les opérateurs télécom pour communiquer entre eux. modèle de confiance mutuelle entre opérateurs, *aucune authentification intégrée*. Accès achetable pour quelques centaines de dollars/mois, nombreux hubs SS7 non sécurisés sur le web.
#text(red, "RAN (Radio Access Network)"): TODO. *Composé de*: BTS, BSC.
#text(red, "Base Transceiver Station (BTS)"): antenne radio, communique avec le mobile via l'interface air. *Stocke*: Kc, A5.
#text(red, "Base Station Controller (BSC)"): contrôle plusieurs BTS, gère l'allocation des canaux radio et le handover.
#text(red, "Core Network (CN)"): partie fixe du réseau GSM, gère la commutation, la mobilité, l'authentification et les bases de données abonnés. *Composé de*: MSC, OMC.
#text(red, "Mobile Switching Center (MSC)"): nœud central de commutation, route les appels voix et gère la mobilité.
#text(red, "Operation and Maintenance Center (OMC)"): supervision et maintenance du réseau.
#text(red, "Home Location Register (HLR) (Database)"): base permanente des abonnés , contient le profil, les services autorisés et la localisation courante. *Stocke*: IMSI, Ki, A3, A8
#text(red, "Visitor Location Register (VLR) (Database)"): copie locale du HLR pour les abonnés présents dans la zone du MSC (évite des requêtes HLR constantes). *Stocke*: IMSI, TMSI, Kc, RAND, SRES.
#text(red, "Authentication Center (AuC) (Database)"): génère les triplets de sécurité. *Stocke*: IMSI, Ki, A3, A8.
#text(red, "Equipment Identity Register (EIR) (Database)"): vérifie si l'équipement (IMEI) est autorisé, volé ou défectueux.
#text(red, "User Equipement (UE)"): terminal mobile de l'abonné, combine le matériel physique et la carte SIM. *Composé de*: ME, SIM, IMEI, Ki, IMSI, TMSI, MSISDN, LAI, PTN.
#text(red, "Mobile Equipment (ME)"): l'appareil physique, identifié par l'IMEI.
#text(red, "Subscriber Identity Module (SIM)"): carte à puce contenant les clés et identifiants de l'abonné. *Smart Card*: single chip avec OS, File System et Applications, appartient à l'opérateur. *Spec*: 8 bit CPU, 16 K ROM, 256 bytes RAM, 4K EEPROM, Cost: \$5. *Technology*: ISO 7816, Card size, contact layout, electrical characteristics, I/O Protocols: byte/block based, File Structure. *Stocke*: IMSI, TMSI, Kc, Ki, A3, A8, A5.
#text(red, "International Mobile Equipment Identity (IMEI)"): numéro unique du terminal.
#text(red, "Subscriber Authentication Key (Ki)"): clé secrète partagée 128 bits pour l'authentification de l'abonné par l'opérateur, jamais transmise sur le réseau. *Stockée dans*: la SIM de l'abonné (appartient à l'opérateur, donc de confiance) et le HLR du réseau home de l'abonné.
#text(red, "International Mobile Subscriber Identity (IMSI)"): identité permanente de l'abonné (stockée dans la SIM et le HLR), max 15 chiffres. *Composé de*: MCC + MNC + NMSI. *MCC (Mobile Country Code)*: identifie le pays (228 = Suisse). *MNC (Mobile Network Code)*: identifie l'opérateur (ex. 01 = Swisscom). *NMSI (Network Mobile Subscriber Identity)*: identifie l'abonné chez cet opérateur.
#text(red, "Temporary Mobile Subscriber Identity (TMSI)"): alias temporaire remplaçant l'IMSI sur l'interface radio (confidentialité), attribué par le VLR (4 bytes, sauf FFFF). Associé à un IMSI et à une Location Area : le couple (TMSI, LAI) remplace l'IMSI et permet une identification unique.
#text(red, "Mobile Station International Service Digital Network (MSISDN)"): le numéro de téléphone composé.
#text(red, "Location Area Identity (LAI)"): identifiant de la zone de localisation courante de l'abonné, diffusé régulièrement par la BTS sur le BCCH. LAI = CC + MNC + LAC (Location Area Code). Exemples MCC: 228 Suisse (01=Swisscom, 02=Sunrise, 03=Orange), 262 Allemagne (07=Viag Interkom).
#text(red, "Personal Identity Number (PIN)"): code protégeant l'accès à la SIM.
#text(red, "Cell Identifier (CI)"): max 2×8 bits, identifie une cellule. LAI+CI identifie de manière unique une cellule au niveau international.
#text(red, "Mobile Station Roaming Number (MSRN)"): numéro d'acheminement temporaire (conforme E.164) alloué par le VLR, permet aux commutateurs d'atteindre le MSC où se trouve un mobile en roaming lors d'un appel entrant.
#image("img/gsm_auth.png", width: 100%)
#text(red, "GSM Authentication"): protocole challenge-response entre le mobile (SIM) et l'opérateur, tous deux connaissant Ki. (1) L'opérateur envoie un challenge *RAND* (128 bits) au mobile. (2) La SIM calcule *SRES* = A3(Ki, RAND) et *Kc* = A8(Ki, RAND), renvoie SRES. (3) L'opérateur calcule son propre SRES et compare : si égaux → abonné authentifié. (4) Kc (64 bits) sert ensuite à chiffrer les données via A5. Ki ne transite jamais sur le réseau.
#image("img/a3_a8.png", width: 100%)
#text(red, "A3 (authentification)"): fonction implémentée sur la SIM, prend RAND (128 bits) + Ki (128 bits) → *SRES* (32 bits). Choix de l'algo laissé à l'opérateur, indépendant du matériel.
#text(red, "A8 (session key)"): fonction implémentée sur la SIM, prend RAND (128 bits) + Ki (128 bits) → *Kc* (64 bits). Jamais rendu public.
#text(red, "COMP128"): implémentation combinée de A3+A8 (fonction de hachage à clé), produit 128 bits : SRES (32 bits) + Kc (*54 bits effectifs*, 10 bits mis à zéro — affaiblissement intentionnel).
#image("img/a5.png", width: 100%)
#text(red, "A5 (chiffrement radio)"): chiffrement par flot (stream cipher), implémenté en hardware, design jamais rendu public (fuité à Ross Anderson et Bruce Schneier). Prend *Kc* (64 bits) + *Fn* (numéro de trame, 22 bits) → keystream 114 bits, XORé avec les données (blocs de 114 bits). *Variantes*: A5/1 (forte, Europe), A5/2 (faible, export), A5/3 (basée sur KASUMI, utilisée en 3G).
#image("img/attack_extract_key_from_sim.png", width: 100%)
#text(red, "Attack Extracting key from SIM"): *Goal*: extraire Ki de la SIM pour la cloner. *Principe cardinal*: les bits intermédiaires du calcul doivent être statistiquement indépendants des entrées, sorties et données sensibles. *Idée*: trouver une violation de ce principe via des canaux auxiliaires (side channels) dont les signaux dépendent de Ki  *Méthode*: exploiter la dépendance statistique entre ces signaux et Ki.
#text(red, "Attack fake BS (IMSI Catcher)"): fausse station de base qui se fait passer pour une vraie BTS. Exploite le fait que GSM n'authentifie que le mobile (pas le réseau) : le téléphone se connecte automatiquement au signal le plus fort. *Conséquences*: capture des IMSI/TMSI, interception des appels, forçage du chiffrement A5/2 (faible) voire désactivation du chiffrement. *Outils*: tiSRP, OpenBTS. Utilisé par les forces de l'ordre mais aussi par des attaquants.
#image("img/ss7_attack_1.png", width: 100%)
#image("img/ss7_attack_2.png", width: 100%)
#text(red, "Attack: Location Tracking using SS7"): exploite l'absence d'authentification SS7 pour localiser un abonné. *Étape 1*: envoyer `sendRoutingInfoForSM` au HLR → réponse avec l'IMSI + adresse du MSC/VLR courant. *Étape 2*: envoyer `provideSubscriberInfo` au MSC → le MSC page le mobile et répond avec le Cell ID. LAI+CI permet de localiser géographiquement l'abonné. Des services en ligne permettent cette localisation automatiquement.
#image("img/attack_ssl_dos.png")
#text(red, "Attack: SS7 Denial of Service"): une fois IMSI et adresse VLR obtenus, l'attaquant peut modifier les données de l'abonné (aucune vérification chez la plupart des opérateurs). En envoyant `insertSubscriberData`, `deleteSubscriberData` ou `cancelLocation` au VLR, il peut contrôler la disponibilité des services : désactiver les appels sortants, couper la connectivité, etc.
#image("img/sms_1.png", width: 100%)
#image("img/sms_2.png", width: 100%)
#text(red, "Attack: SS7 SMS Interception (Man-in-the-Middle)"): attaque similaire à un MITM, intercepte les SMS (ex. codes 2FA). *Setup (étape 1)*: (A) l'attaquant enregistre le MSISDN de la victime sur un faux MSC via SS7 → (B) le vrai HLR met à jour la localisation vers le faux MSC → (C) le vrai HLR demande au vrai MSC de libérer la mémoire. *Hijacking (étape 2)*: la banque envoie un SMS → le SMS-C demande la localisation au HLR → le HLR répond avec l'adresse du faux MSC → le SMS-C achemine le SMS vers l'attaquant.

= UMTS (3G)

#image("img/umts.png", width: 100%)
#text(red, "UMTS (Universal Mobile Telecommunications System)"): technologie téléphonie mobile 3G, successeur de GSM. Réutilise les principes de sécurité GSM (module hardware amovible, chiffrement radio, protection identité) mais corrige ses failles : *USIM* remplace la SIM (authentification mutuelle), confiance limitée au réseau visité, clés/données d'auth ne transitent plus en clair, chiffrement obligatoire, *intégrité des données* ajoutée. Corrige aussi les attaques par fausse station de base.
#text(red, "Radio Network Controller (RNC)"): remplace le BSC, contrôle plusieurs NodeB, gère handover, allocation de ressources radio et chiffrement.
#text(red, "Gateway Mobile Switching Center (GMSC)"): point de sortie du réseau vers d'autres réseaux (PSTN, autres opérateurs).
#text(red, "Serving GPRS Support Node (SGSN)"): nœud data du cœur, gère la mobilité et l'authentification pour le trafic paquet, achemine les données entre le RNC et le GGSN.
#text(red, "Gateway GPRS Support Node (GGSN)"): passerelle entre le réseau mobile et Internet, attribue les adresses IP aux mobiles et route le trafic vers l'extérieur.
#text(red, "USIM (Universal Subscriber Identity Module)"): version 3G de la SIM, supporte l'AKA (Authentication and Key Agreement) et permet l'authentification mutuelle : le terminal peut aussi authentifier le réseau (protection contre les fausses stations de base).
#text(red, "eNodeB"): station de base UMTS, connectée au RNC via l'interface Iub, gère l'interface radio WCDMA avec les terminaux.
#image("img/umts_auth.png", width: 100%)
#text(red, "UMTS AKA — Flux général"): protocole à 3 parties (Mobile/USIM, Réseau visité, Home Env./HLR). (1) Home Env. génère vecteurs d'auth et les envoie au réseau visité. (2) Réseau visité envoie RAND || AUTN au mobile. (3) Mobile vérifie AUTN → *réseau authentifié*. (4) Mobile envoie RES. (5) Réseau compare RES=XRES → *mobile authentifié*. (6) Les deux dérivent CK et IK. K ne quitte jamais la SIM ni le HLR.
#image("img/gen_auth_vector_hn.png", width: 100%)
#text(red, "UMTS AKA — Génération des vecteurs"): le HLR calcule via f1-f5(K, RAND, SQN) : *MAC*=f1 (authenticité), *XRES*=f2 (vérif mobile), *CK*=f3 (chiffrement), *IK*=f4 (intégrité), *AK*=f5 (masquage SQN). Construit *AUTN = (SQN ⊕ AK) || AMF || MAC* : SQN masqué par AK pour la vie privée, MAC prouve l'authenticité du réseau. Vecteur complet : AV = RAND || XRES || CK || IK || AUTN.
#image("img/user_auth_usim.png", width: 100%)
#text(red, "UMTS AKA — Vérification côté mobile"): le mobile recalcule AK=f5(K,RAND), démasque SQN=(SQN⊕AK)⊕AK, vérifie MAC=f1(K,...) → réseau authentique. Vérifie que SQN est dans la plage valide (anti-replay). Calcule RES=f2, CK=f3, IK=f4.
#text(red, "MILENAGE (dia 47)"): implémentation de référence 3GPP des fonctions f1-f5, basée sur AES (Rijndael). Opérateur-spécifique mais MILENAGE fourni comme exemple standard.
#image("img/signal_integrity_protection.png", width: 100%)
#image("img/f9.png", width: 100%)
#text(red, "f9 — Intégrité signalisation"): protège les messages de signalisation NAS/RRC. f9(IK, COUNT, FRESH, MESSAGE, DIRECTION) → MAC-I 32 bits. Basé sur KASUMI (dérivé de MISTY1) pour UIA1, AES-CMAC pour UIA2.
#image("img/f8.png", width: 100%)
#text(red, "f8 — Chiffrement"): chiffrement par flot des données. f8(CK, COUNT-C, BEARER, DIRECTION, LENGTH) → keystream XORé avec les données (blocs 114 bits). Basé sur KASUMI.

= LTE (4G)

#image("img/4g_network.png", width: 100%)
#text(red, "LTE — Sécurité"): Réutilise l'AKA (Authentication and Key Agreement) d'UMTS avec une hiérarchie de clés étendue. Permet des clés plus longues et offre une protection renforcée du backhaul. *Principaux apports*: réutilisation AKA UMTS, hiérarchie de clés étendue, possibilité de clés plus longues, meilleure protection du backhaul.
#text(red, "Backhaul"): liaison réseau entre la station de base (eNodeB) et le cœur du réseau (EPC). En LTE, ce lien est protégé par IPsec car il transite souvent sur des liaisons non dédiées (fibre, micro-ondes) pouvant être exposées.
#text(red, "Evolved Packet System (EPS)"): = Réseau 4G séparé en RAN et CN.
#text(red, "Radio Access Network (RAN)"): User Equipement (UE), communication sans fil (Air Interface), station de base evolved Node B (eNodeB).
#text(red, "Core Network (CN)"): Coeur du réseau = Evolved Packet Core (EPC), basé sur IP, plus de commutation circuit tout est packet switched.
#text(red, "Taille de cellules")Différentes tailles pour optimiser la couverture et la capacité selon l'environnement. Plus elle est petite, plus elle est déployé dans zones denses avec beaucoup d'utilisateurs concentrés.
#text(red, "Femtocell"): Usage domestique/entreprise, 8-16 users, petite portée, indoor
#text(red, "Picocell"): Entreprise et zones à forte densités, portée légèrement supérieur à Femtocell
#text(red, "Microcell/Metrocell"): Zone à forte densité et indoor, ~64 users
#text(red, "Meadowcell/Macrocell"): Zones urbaines extérieurs, 50-200 users, grande portée
#image("img/lte_arch.png", width: 100%)
#text(red, "Long Term Evolution (LTE)"): technologie 4G, évolution de l'UMTS, tout IP, plus rapide et plus efficace que les générations précédentes.
#text(red, "E-UTRAN (Radio)"): Evolved Universal Terrestrial Radio Access Network, partie radio du réseau LTE. Gère l'interface air entre l'UE et le réseau, sans contrôleur centralisé (RNC supprimé vs UMTS). *Composé de*: eNodeB.
#text(red, "eNodeB"): station de base 4G, gère l'interface radio avec l'UE et communique directement entre eNodeB voisins pour les handovers.
#text(red, "EPC — Control Plane"): Plan de contrôle de l'EPC, gère la signalisation, l'authentification, la mobilité et les politiques. Aucune donnée utilisateur ne transite ici. *Composé de*: MME, HSS, PCRF, OCS.
#text(red, "MME (Mobility Management Entity)"): nœud de signalisation principal, authentification, gestion de la mobilité et des sessions, pagination.
#text(red, "HSS (Home Subscriber Server)"): remplace le HLR, base de données des abonnés et clés de sécurité.
#text(red, "PCRF (Policy Charging Rules Function)"): définit les règles de QoS et de facturation en temps réel, décide la priorité de chaque flux.
#text(red, "OCS (Online Charging System)"): facturation prepaid en temps réel,peut couper ou adapter le service si le crédit est épuisé.
#text(red, "EPC — User Plane"): Plan de données de l'EPC, achemine les paquets IP entre l'UE et Internet. Séparé du control plane pour des raisons de performance et de scalabilité. *Composé de*: S-GW, P-GW.
#text(red, "S-GW (Serving Gateway)"): passerelle data côté RAN, route les paquets entre eNodeB et P-GW, ancrage local lors des handovers.
#text(red, "P-GW (Packet Gateway)"): passerelle vers Internet, attribue les adresses IP, applique les règles définies par le PCRF.
#text(red, "AS (Access Stratum)"): protocoles entre UE et eNodeB (interface radio).
#text(red, "NAS (Non-Access Stratum)"): protocoles entre UE et MME (mobilité, authentification), transparent au eNodeB.
#text(red, "QoS — QCI (QoS Class Identifier)"): en cas de congestion radio, les flux sont priorisés par QCI.
#text(red, "GBR (Guaranteed Bit Rate)"): bande passante réservée — utilisé pour voix/vidéo temps réel.
#text(red, "non-GBR (Best Effort)"): pas de garantie — utilisé pour internet, email.
Priorités : VoLTE signaling (1er, QCI 5) → voix (QCI 1) → gaming/V2X (QCI 3) → vidéo live (QCI 2) → vidéo buffered (QCI 4) → internet (QCI 6–9).
#image("img/lte_auth.png", width: 100%)
#text(red, "LTE Authentication (EPS-AKA)"): similaire à UMTS AKA mais avec une hiérarchie de clés étendue. (1) UE envoie IMSI au MME. (2) MME envoie IMSI + SN id (Serving Network ID) au HSS. (3) HSS exécute EPS AKA (K, RAND, SQN, SN ID) → génère AUTN\_hss, XRES, *K\_ASME*. (4) MME envoie RAND || AUTN à l'UE. (5) UE exécute EPS AKA côté mobile → génère AUTN\_UE, RES, K\_ASME. (6) UE envoie RES au MME. *Vérifications*: AUTN\_UE = AUTN\_hss (réseau authentifié), RES = XRES (mobile authentifié). *K\_ASME (Key Access Security Management Entity)*: clé racine LTE dérivée avec le SN ID, de laquelle sont dérivées toutes les clés de chiffrement et d'intégrité. *Algorithmes LTE (128 bits)*: chiffrement EEA: 128-EEA0 (NULL), 128-EEA1 (SNOW 3G), 128-EEA2 (AES) ; intégrité EIA: 128-EIA1 (SNOW 3G), 128-EIA2 (AES). Deux algos obligatoires dès le départ : SNOW 3G (issu d'UMTS) et AES (NIST FIPS 197).

= 5G

#text(red, "Objectifs 5G (IMT-2020)"):
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
#text(red, "Triangle 5G"): 3 cas d'usage (triangle 5G):
*eMBB (enhanced Mobile Broadband*: haut débit amélioré — 4K/3D, AR/VR, cloud, Gbps en mobilité.
*URLLC (Ultra-Reliable Low-Latency Communications)*: ultra-fiable et faible latence — voiture autonome, automation industrielle/V2X.
*mMTC (massive Machine Type Communications)*: connectivité massive IoT — smart home, smart city, capteurs, M2M, 10 ans de batterie.
#text(red, "SA vs NSA")
*5G NSA (Non-Standalone)*: radio 5G (gNB) + core 4G (EPC) — déploiement rapide, ne libère pas tout le potentiel 5G.
*5G SA (Standalone)*: radio 5G + 5G Core dédié — plein potentiel : ultra-low latency, network slicing, cloud-native.
#image("img/5g_network.png", width: 100%)
#image("img/5g_2.png", width: 100%)
#text(red, "5G Core — Control Plane"): gère la signalisation, l'authentification, la mobilité et les politiques. Architecture orientée services (SBI), chaque fonction expose une API REST. *Composé de*: AMF, SMF, AUSF, UDM, PCF, NSSF, NEF, NRF.
#text(red, "AMF (Access & Mobility Function)"): remplace le MME — registration, connection, reachability, mobility management. Interface N2 (gNB) et N1 (UE).
#text(red, "SMF (Session Management Function)"): gestion des sessions PDU, allocation IP, QoS SLAs, roaming, charging, lawful intercept. Interface N4 (UPF).
#text(red, "AUSF (Authentication Server Function)"): remplace l'AuC — authentification des UE.
#text(red, "UDM (Unified Data Management)"): remplace le HSS — base abonnés avec UDC (User Data Convergence). Séparé en UDM + UDR (stockage) + UDSF.
#text(red, "PCF (Policy Control Function)"): remplace le PCRF — politiques de QoS et facturation.
#text(red, "NSSF (Network Slice Selection Function)"): sélection du slice réseau approprié pour chaque UE.
#text(red, "NEF (Network Exposure Function)"): exposition sécurisée des fonctions réseau aux applications tierces.
#text(red, "NRF (NF Repository Function)"): registre des fonctions réseau (service discovery).
#text(red, "5G Core — User Plane"): achemine les paquets IP entre l'UE et Internet, séparé du control plane pour la performance et le slicing. *Composé de*: UPF.
#text(red, "UPF (User Plane Function)"): remplace S-GW + P-GW — routage des paquets, application des QoS, reporting usage. Interface N3 (gNB) et N6 (DN/Internet).
#text(red, "RAN 5G"): partie radio du réseau 5G, sans contrôleur centralisé, gère l'interface air entre l'UE et le core. *Composé de*: gNB, SBI.
#text(red, "gNB (gNodeB)"): divisé en CU (Central Unit) + DU (Distributed Unit) — ORAN Split 7.2 entre radio et DU, Midhaul (Split 2) entre DU et CU.
#text(red, "SBI (Service-Based Interface)"): architecture 5G Core orientée services — chaque NF expose une API REST, remplace les interfaces point-à-point.
#text(red, "Interfaces N"): N1 (UE↔AMF), N2 (gNB↔AMF), N3 (gNB↔UPF), N4 (SMF↔UPF), N6 (UPF↔Internet/DN).
#image("img/private_5g.png", width: 100%)
#text(red, "Réseau privé 5G"): tout logiciel sur COTS HW (hardware standard) — DU + CU + Packet Core déployés on-premise, connectés à un DN privé.
#image("img/5g_sec_1.png", width: 100%)
#image("img/5g_sec_2.png", width: 100%)
#text(red, "Sécurité 5G — 5G AKA"): acteurs : *AMF/SEAF* (contrôle d'accès core), *AUSF* (authentification), *UDM/ARPF/SIDF* (base abonnés + Ki). Phase 1 (initiation): UE envoie *SUCI* (identité chiffrée, remplace IMSI en clair) ou 5G-GUTI. Phase 2 (auth): échange RAND || AUTN || ngKSI, UE calcule RES, MME vérifie → dérive *K\_AUSF* → *K\_SEAF* → *K\_AMF* → clés NAS/RRC/UP.
#text(red, "SUCI (Subscriber Concealed Identifier)"): remplace l'IMSI en clair — IMSI chiffré avec la clé publique de l'opérateur, protège la vie privée contre les IMSI catchers.
#text(red, "Hiérarchie de clés 5G"): K → CK/IK → K\_AUSF → K\_SEAF → K\_AMF → K\_NASint/K\_NASenc (signalisation NAS) → K\_gNB → K\_RRCint/K\_RRCenc (radio) + K\_UPint/K\_UPenc (user plane).
#text(red, "Comparaison 3G/4G/5G"): intégrité: f9/KASUMI → EIA/SNOW3G+AES → NIA/AES-CMAC+ZUC+HMAC-SHA256. Chiffrement: f8/KASUMI → EEA → NEA/AES+ZUC+SNOW3G. Protection user plane: Non (3G) → Oui (4G/5G). Anonymat: IMSI clair (3G) → GUTI (4G) → SUCI chiffré (5G). Crypto-agilité: faible → moyenne → forte (post-quantique préparé).

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

#text(red, "Evolution Securité"):
#table(
  columns: (auto, auto, auto, auto),
  inset: 3pt,
  stroke: 0.4pt,
  align: left,
  table.header[*Aspect*][*3G (UMTS)*][*4G (LTE)*][*5G (NR)*],
  [Intégrité], [f9/KASUMI], [EIA: SNOW3G, AES], [NIA: AES-CMAC, ZUC, HMAC-SHA256],
  [Chiffrement], [f8/KASUMI], [EEA: SNOW3G, AES], [NEA: AES, ZUC, SNOW3G],
  [Clés], [K unique], [K+K\_ASME], [K+K\_AMF, K\_gNB...],
  [Protection UP], [Non], [Oui], [Oui],
  [Crypto-agilité], [Non], [Moyenne], [Forte (post-quantique)],
  [Algos modulables], [Non], [Partiel], [Oui (dynamique)],
  [Anonymat], [IMSI clair], [GUTI], [SUCI (chiffré)],
)

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

#text(red, "Motivation SCTP/MPTCP"): migration PSTN → packet, signalisation téléphonique, ni TCP ni UDP n'est adapté.
#text(red, "TCP"): fiable, orienté bytes, mais head-of-line blocking, pas de multi-homing, vulnérable DoS (SYN flood).
#text(red, "UDP"): orienté messages, mais sans fiabilité, sans contrôle de congestion ni de flux.
#text(red, "SCTP"): combine le meilleur des deux.
*Fiable*: acquittements, retransmissions comme TCP.
*Orienté messages*: préserve les frontières de messages (contrairement à TCP).
*Multi-homing*: une association peut utiliser plusieurs adresses IP, bascule automatique en cas de panne d'un chemin.
*Multi-streaming*: plusieurs flux indépendants dans une association, perte sur un flux ne bloque pas les autres (élimine le head-of-line blocking inter-streams).
*Sécurité*: handshake 4-way avec mécanisme cookie (INIT > INIT-ACK > COOKIE-ECHO > COOKIE-ACK) — protège contre les attaques SYN flood.
*Shutdown*: 3-way (SHUTDOWN > SHUTDOWN-ACK > SHUTDOWN-CMPL), pas d'état half-closed contrairement à TCP.
*Chunks SCTP*: unités de données atomiques, plusieurs peuvent être bundlés dans un même paquet. *INIT*: initie une association — Verification Tag = 0x0, déclare Initiate Tag, a_rwnd (fenêtre réception), nb flux IN/OUT, Initial TSN.
*INIT_ACK*: répond à l'INIT — contient le State Cookie (MAC + timestamp + durée de vie, calculé par le serveur avec une clé secrète) — le serveur reste stateless jusqu'au COOKIE_ECHO (protection DoS).
*COOKIE_ECHO*: renvoie le State Cookie reçu dans l'INIT_ACK pour prouver la validité du client. *COOKIE_ACK*: confirme la réception du COOKIE_ECHO — association établie.
*DATA*: transporte les données — identifié par TSN (global), SID (flux), SSN (séquence dans le flux), bits B/E (début/fin de fragment), I (SACK immédiat), U (non ordonné).
*SACK (Selective ACK)*: acquitte les DATA via Cumulative TSN Ack, signale les écarts (Gap Ack Blocks) et les doublons — plus précis que le ACK TCP.
*ASCONF / ASCONF_ACK*: reconfiguration dynamique des adresses IP d'une association active (RFC 5061 ADD-IP) — permet d'ajouter/supprimer une adresse ou changer l'adresse principale sans couper l'association.
*HEARTBEAT / HEARTBEAT_ACK*: vérification périodique de la disponibilité de chaque chemin — détecte les pannes et déclenche le basculement sur un chemin alternatif.
*Identifiants clés* : TSN (Transmission Sequence Number): numéro de séquence global à l'association — garantit la livraison fiable indépendamment du flux. SSN (Stream Sequence Number): numéro de séquence local à un flux — garantit l'ordre dans un stream sans bloquer les autres. Verification Tag: tag inclus dans chaque paquet (sauf INIT où il vaut 0x0) — valide l'identité de l'émetteur et lie le paquet à l'association.
#text(red, "TCP vs SCTP face SYN flooding"): Bonus SCTP: multihoming + détection de plusieurs connexions depuis la même IP.
#table(
  columns: (auto, 1fr, 1fr),
  inset: 3pt,
  stroke: 0.4pt,
  align: left,
  table.header[*Critère*][*TCP (Vulnérable)*][*SCTP (Protégé)*],
  [Allocation mémoire], [Dès réception de SYN], [Rien n'est stocké avant COOKIE-ECHO],
  [IP spoofing], [L'attaquant n'a pas besoin de réponse], [L'attaquant doit recevoir et renvoyer le cookie],
  [Table connexions saturée], [Oui (SYN Flooding efficace)], [Non (le serveur ne garde rien en mémoire)],
  [Protection intégrée], [Non (TCP doit utiliser SYN Cookies)], [Oui (mécanisme du cookie SCTP intégré)],
)
#text(red, "MPTCP (Multipath TCP"): extension de TCP standard, transparent pour les applications.
*Transferts transparents*: bascule d'un chemin à l'autre sans couper la connexion TCP — ex. Apple utilise MPTCP sur iPhone (Wi-Fi → 4G sans interruption).
*Sélection du meilleur chemin*: choix dynamique selon latence, pertes, coût, bande passante. *Agrégation*: utilisation simultanée de plusieurs chemins pour cumuler les débits — ex. Wi-Fi + 4G en même temps.
*Établissement MPTCP* : Connexion principale : SYN (MP_CAPABLE + clé client) → SYN/ACK (MP_CAPABLE + clé serveur) → ACK (les deux clés).
*Ajout de sous-flux* : SYN (MP_JOIN + token) → SYN/ACK (MP_JOIN + HMAC serveur) → ACK (HMAC client) — HMAC authentifie l'ajout sans nouveau handshake complet.
*Paquet MPTCP*: header TCP standard + option MPTCP (Type, Length, Subtype, Version, Flags, données spécifiques au subtype) + Payload — rétrocompatible avec les middleboxes qui ignorent les options TCP inconnues.

= DIAMETER / RADIUS

#text(red, "Protocole AAA (Authentication, Authorization, Accounting)"): framework de contrôle d'accès réseau. *Authentication*: vérifie l'identité (qui es-tu ?). *Authorization*: définit les droits/ressources accordés (que peux-tu faire ?). *Accounting*: trace les sessions — durée, volume, facturation, roaming. Implémenté par RADIUS ou Diameter.
#text(red, "RADIUS (Remote Authentication Dial-In User Service)"): protocole AAA client-serveur sur UDP, centralisé, scalable — Authentication (vérifier identité), Authorization (droits/ressources), Accounting (suivi sessions, facturation, roaming). Ports : auth 1812, accounting 1813. RADIUS et Diameter encapsulent tous deux des messages EAP, sont utilisés par les NAS (Network Access Server) et relaient les paquets EAP entre les endpoints 802.1X et les serveurs AAA.
*EAP-TLS*: authentification mutuelle forte par certificats — le client et le serveur s'authentifient réciproquement via PKI (CA commune).
*WPA2 Enterprise*: Wi-Fi sécurisé via RADIUS + EAP — chaque utilisateur a ses propres credentials, contrairement à WPA2 PSK (clé partagée).
*PKI en production*: éviter les certificats auto-signés — utiliser une CA reconnue (interne ou externe), HSM pour stocker les clés privées, procédures de révocation (CRL).
#text(red, "Diameter"): successeur de RADIUS sur TCP/SCTP, rétrocompatible (AVP codes 1–255 et command codes 0–255 réutilisés) — corrige toutes les limitations de RADIUS. RADIUS et Diameter encapsulent tous deux des messages EAP, sont utilisés par les NAS (Network Access Server) et relaient les paquets EAP entre les endpoints 802.1X et les serveurs AAA.
*Transport*: clients Diameter MUST support SCTP ou TCP, serveurs/agents MUST support SCTP ET TCP.
*Sécurité*: TLS et IPSec — ordre de sélection : IPSec → SCTP/TCP → TLS après négociation.
*Message Header*: Version, Length, Flags (R=Request, P=Proxiable, E=Error, T=Re-transmitted), Command Code, Application-ID, Hop-by-Hop ID, End-to-End ID.
*AVP (Attribute-Value Pair)*: unité de données Diameter — AVP Code, Flags, Vendor-ID (optionnel), Data.
*Result-Code AVP (268)*: présent dans toute réponse Diameter — 1xxx (Info), 2xxx (Succès), 3xxx (Erreurs protocole), 4xxx (Transitoires), 5xxx (Permanentes).
#text(red, "Diameter vs Radius"):
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

= Wired Security

#image("img/osa_overview.png", width: 100%)
#image("img/auth_component.png", width: 100%)
#image("img/auth_overview.png", width: 100%)
#text(red, "Open System Authentication"): établit une association IEEE 802.11 sans authentification. Équivalent à brancher un câble réseau : n'importe quel client peut se connecter.
#image("img/open_system_authentication.png", width: 100%)
#text(red, "Wired Equivalent Privacy (WEP)"): authentification par clé partagée, chiffrement RC4. *Problèmes de sécurité* : IV de seulement 24 bits — collision d'IV inévitable (le même keystream RC4 réutilisé pour chiffrer des textes différents), permettant des attaques statistiques pour retrouver le plaintext. CRC-32 linéaire et non cryptographique — manipulable pour forger un ICV valide sur un faux message.
#image("img/wep.png", width: 100%)
#image("img/rc4.png", width: 100%)
#text(red, "STA"): wireless client
#text(red, "Access Point (AP)"): point d'accès Wi-Fi — joue le rôle d'*Authenticator* dans 802.1X : contrôle l'accès au réseau et relaie les messages EAP entre le client et le serveur d'authentification.
#text(red, "Authentication Server (AS)"): base de données d'authentification (RADIUS ou Diameter) — vérifie les credentials du client et autorise ou refuse l'accès.
#text(red, "802.1X"): protocole de contrôle d'accès réseau par port (NAC), authentification mutuelle. 3 entités : *Supplicant* (client Wi-Fi), *Authenticator* (AP), *Authentication Server* (RADIUS/Diameter). Utilise EAP comme framework d'authentification — méthodes : EAP-MD5, EAP-TLS, EAP-TTLS, PEAP, EAP-FAST, EAP-SIM, EAP-AKA. Fonctionne au niveau réseau (pas liaison de données).
#text(red, "EAP tunnelisé (TTLS, PEAP, FAST)"): approche générale — TLS établit d'abord un tunnel sécurisé (auth serveur via certificat), puis une méthode d'auth interne (inner EAP) s'exécute à l'intérieur du tunnel. Avantage : le client n'a pas besoin de certificat pour la méthode interne. PMK dérivé des nonces et du secret DH/session TLS.
#image("img/eap_auth.png", width: 100%)
#table(
  columns: (auto, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr),
  inset: 3pt,
  stroke: 0.4pt,
  align: left,
  table.header[*Critère*][*MD5*][*TLS*][*TTLS*][*PEAP*][*FAST*][*LEAP*],
  [Cert. client], [Non], [Oui], [Non], [Non], [Non (PAC)], [Non],
  [Cert. serveur], [Non], [Oui], [Oui], [Oui], [Non (PAC)], [Non],
  [WEP key mgmt], [Non], [Oui], [Oui], [Oui], [Oui], [Oui],
  [Rogue AP], [Non], [Non], [Non], [Non], [Oui], [Oui],
  [Auth], [1 sens], [Mutuelle], [Mutuelle], [Mutuelle], [Mutuelle], [Mutuelle],
  [Déploiement], [Facile], [Difficile], [Modéré], [Modéré], [Modéré], [Modéré],
  [Sécurité Wi-Fi], [Faible], [Très haute], [Haute], [Haute], [Haute], [Haute si MDP fort],
)
#text(red, "Clefs 802.1x"): hiérarchie de clés dérivées : *Root Key (Master Key)* → toutes les autres clés en sont dérivées. *PMK (Pairwise Master Key)* → génère les clés unicast (256 bits, issu de AAA Key ou PSK). *GMK (Group Master Key)* → génère les clés multicast/broadcast. *PTK (Pairwise Transient Key)* → chiffrement + intégrité des données unicast, protège aussi le 4-way handshake. Dérivé par : #text(purple, $"PTK" = "PRF"("PMK", "ANonce", "SNonce", "AP MAC", "STA MAC")$) (384 bits AES-CCMP, 512 bits TKIP). *GTK (Group Temporal Key)* → distribué via group-key handshake, chiffre le trafic multicast/broadcast. *Session Keys* → clés finales effectivement utilisées pour le chiffrement.
#image("img/key_802.-1.png", width: 100%)
#image("img/802-1_key_management.png", width: 100%)
#image("img/key_management_4_way_handshake.png", width: 100%)
#image("img/group_key_handshake.png", width: 100%)
#text(red, "Wireless Network"): Wireless client is the supplicant, AP is the authenticator.
#text(red, "Robust Security Network (RSN / 802.11i)"): définit une RSNA (RSN Association) entre stations. 3 piliers : (1) *Chiffrement* via CCMP (AES en mode CTR + CBC-MAC pour l'intégrité) — TKIP optionnel pour compatibilité. (2) *Gestion des clés* via 4-way handshake (dérive le PTK) + group-key handshake (distribue le GTK). (3) *Authentification* via PSK (personnel) ou 802.1X/EAP (entreprise).
#image("img/ptk.png", width: 100%)
#text(red, "Cipher Block Chaining (CBC)")
#image("img/cbc.png", width: 100%)
#text(red, "CCMP AES Encryption/MIC")
#image("img/ccmp_aes_encryption_mic.png", width: 100%)
#text(red, "Wi-Fi Protected Access (WPA)"): amélioration transitoire de WEP (avant 802.11i/WPA2). Améliorations : authentification via 802.1X/RADIUS (entreprise) ou passphrase PSK (personnel), hiérarchie de clés dérivée du master key, IV doublé à 48 bits (vs 24 bits WEP), intégrité via algorithme *Michael* (MIC). Session = authentification + 4-way handshake (génère la hiérarchie de clés) + données chiffrées via *TKIP* (RC4 + Michael).
#image("img/wpa_personal_vs_enterprise.png", width: 100%)
#text(red, "TKIP (Temporal Key Integrity Protocol)"): amélioration de WEP rétrocompatible (même matériel RC4). *Structure PTK* (512 bits) : KCK (128 bits, intégrité handshake) + KEK (128 bits, chiffre transport GTK) + TK (256 bits = Temporal Encryption Key + MIC Key 1 + MIC Key 2). *Fonctionnement* : clé unique par paquet via key mixing (IV + clé maître → clé RC4 par paquet), IV étendu à 48 bits (vs 24 bits WEP → évite les collisions), intégrité via algorithme *Michael* (MIC). *Faiblesses* : rétrocompatibilité limite la sécurité, vulnérable à l'attaque *Beck-Tews* (2008). Déprécié — remplacé par CCMP/AES dans WPA2.
#image("img/wpa_tkip_encryption.png", width: 100%)
#image("img/ptk_for_tkip.png", width: 100%)
#text(red, "WPA2 (802.11i, 2004)"): standard Wi-Fi Alliance basé sur IEEE 802.11i — marque Wi-Fi certifiée après 2006. Même 4-way handshake et hiérarchie de clés que WPA, mais remplace TKIP par *CCMP/AES* : AES en mode CTR pour le chiffrement, AES en mode CBC-MAC pour l'intégrité (MIC). *PTK AES-CCMP* (384 bits) : KCK (128 bits, intégrité du handshake) + KEK (128 bits, chiffre le transport de la GTK) + TK (128 bits, chiffrement + intégrité des données). TK plus court que TKIP (128 vs 256 bits) car CBC-MAC gère l'intégrité avec une seule clé, sans besoin de 2 clés MIC séparées.
#image("img/aes_ccmp.png", width: 100%)
#text(red, "WPA3 (2018)"): chiffrement 128 bits en mode personnel, 192 bits en mode entreprise. Remplace PSK par *SAE* (Simultaneous Authentication of Equals) — échange de clés PAKE résistant aux attaques par dictionnaire offline (zero-knowledge proof, le mot de passe n'est jamais transmis). Ajoute *PMF* (Protected Management Frames) et *OWE* (Opportunistic Wireless Encryption) pour les réseaux ouverts.
#text(red, "SAE (Simultaneous Authentication of Equals)"): protocole PAKE (Password-Authenticated Key Exchange) introduit par WPA3 — remplace WPA2-PSK. Mécanisme : chaque partie prouve qu'elle connaît le mot de passe sans le transmettre (zero-knowledge proof via courbe elliptique). Résiste aux attaques par dictionnaire offline car chaque tentative nécessite une interaction réseau. Sécurité forte même avec un mot de passe faible.
#text(red, "WPA2/WPA3-Enterprise (802.1X/EAP)"): mode entreprise — authentification mutuelle via 802.1X + serveur RADIUS centralisé. Supporte des méthodes d'auth fortes : certificats (EAP-TLS), smart cards, tokens. Chaque utilisateur a ses propres credentials (contrairement au PSK partagé du mode personnel). Bénéfice : si un credential est compromis, seul cet utilisateur est affecté.
#text(red, "PMF (Protected Management Frames)"): protège les trames de management (deauthentication, disassociation) en les authentifiant et chiffrant — empêche les attaques de déconnexion forcée (deauth attacks) qui exploitaient le fait que ces trames étaient en clair dans WPA/WPA2.
#text(red, "OWE (Opportunistic Wireless Encryption)"): remplace les réseaux Wi-Fi ouverts sans mot de passe. Chiffre le trafic même sans authentification via un échange Diffie-Hellman — chaque client obtient une clé de session unique. Pas de protection contre les rogue AP, mais élimine l'écoute passive sur les réseaux publics.
#text(red, "Purpose of enhanced authentication mechanisms"): identifier les appareils de façon sécurisée avant d'accorder l'accès, empêcher les accès non autorisés, protéger la confidentialité et l'intégrité des données en transit, corriger les failles de WEP, WPA et WPA2.
#text(red, "Discovery Message Exchange (Robust Security Network)")
#image("img/discovery_message_exchange.png", width: 100%)
#text(red, "Operational phases (Robust Security Network)")
#image("img/operational_phase.png", width: 100%)
#text(red, "Key Derivation/Key Partitioning"): la dérivation de clés génère plusieurs clés cryptographiques à partir d'une valeur source via une KDF (Key Derivation Function). Avantage : si une clé dérivée est compromise, la clé maître et les autres clés restent sécurisées. *PMK (256 bits)* est au sommet de la hiérarchie — dérivé soit du *AAA Key* (enterprise, issu de l'auth RADIUS/EAP) soit du *PSK* (personnel, passphrase). Toutes les clés de session (PTK, GTK) en sont dérivées indirectement.
#image("img/kdf.png", width: 100%)
#image("img/pairwise_key.png", width: 100%)
#text(red, "Offline Dictionary Attack")
#image("img/offline_dict_attack.png", width: 100%)

// CONSOLI

= Broadband techniques

TODO REMOVE objectives :
- Overview of all broadband techniques
- Understand the evolution taking to currently used protocols and networking architectures
- Understanding the evolutions of connectivity technologies
- A quick intro to the new connectivity players

#text(red, "Transmission Technology"): cœur des télécoms classiques — aucun traitement ni mémoire, transporte le signal brut de la source au récepteur (le "tuyau"). *Objectif*: que le signal reçu soit le plus fidèle possible au signal émis, malgré les perturbations et imperfections du canal.
#text(red, "Exchange Technology"): crée dynamiquement un chemin de transmission entre terminaux par couplage variable des mécanismes de transmission (l'"aiguillage" — ex: central téléphonique).
#text(red, "Terminal Technology"): mécanismes côté participant (le "combiné") — saisie du signal, préparation pour la transmission et la commutation, restitution fidèle à l'arrivée.
#text(red, "Signal à fréquences limitées"): tout signal n'occupe qu'une plage de fréquences, naturellement ou par filtrage technique. Canal téléphonique ITU: 300–3400 Hz, plage 3100 Hz — correspond à la plage acoustique de la voix humaine.
#text(red, "Milieu à bande limitée (Volume-limited Medium)"): tout milieu de transmission (câble, air, fibre) ne transfère qu'une bande de fréquences finie, y compris les filtres et amplificateurs du système. *Plage* = différence entre la fréquence max et min transférables, définie aux fréquences de coupure. Le signal doit être adapté à la caractéristique du milieu.
#text(red, "PCM (Pulse-Code Modulation)"): numérisation d'un signal analogique en 3 étapes — *échantillonnage* (mesurer à intervalles réguliers), *quantification* (arrondir à une valeur discrète), *codage* (encoder en binaire). Les mots de code sont transmis comme signaux numériques en bande de base. Conversion A/N et N/A réalisée par un *CODEC* (coder/decoder).
#image("img/pcm_techno.png", width: 100%)
#text(red, "PCM Scanning"): *Shannon-Nyquist*: échantillonner à ≥ 2× la fréquence max pour reconstruire sans perte → minimum théorique: 2×3400 = 6800 Hz. L'ITU choisit $f_A = 8$ kHz ($T_A = 1\/f_A = 125 mu s$) — marge pour les imperfections des filtres réels et la séparation des canaux.
#text(red, "PCM Quantization"): arrondir l'amplitude échantillonnée à la "case" discrète la plus proche parmi N intervalles. Le nombre d'intervalles est fixé par la *reconnaissance syllabique* (critère perceptif: en dessous d'un seuil, les syllabes deviennent inintelligibles; au-dessus, l'oreille ne perçoit plus de différence). Avec marge de sécurité: *256 intervalles* → *8 bits* par échantillon ($2^8 = 256$). Débit: $8000 times 8 = bold("64 kbit/s")$ par canal.
#text(red, "Quantification non-uniforme (13 segments)"): la voix passe la majorité du temps à faible amplitude → intervalles plus petits près de zéro (plus de précision) et plus grands à haute amplitude. Compression logarithmique approchée par 13 segments (loi A en Europe, loi µ aux USA). Améliore le SNR (Signal to Noise Ratio) pour les signaux faibles sans augmenter le nombre de bits.
#text(red, "PDH (Plesiochronous Digital Hierarchy)"): multiplexage de canaux PCM. 1 frame = 256 bits = 0.125 ms = 32 time slots de 8 bits. *Europe*: E1 = 30 canaux × 64 kbps = *2.048 Mbps* (G.703/732) — slots 0: sync, 16: contrôle, 1-15 + 17-31: données. *USA*: T1 = 24 canaux × 7 bits = *1.544 Mbps*. Multiplexage hiérarchique par étages MUX: 2.048 → 8.448 → 34.368 → *139.264 Mbit/s*. Les légères variations de débit entre sources sont compensées par des *plugging bits* (bits de bourrage insérés pour aligner les flux). *Limites*: non standardisé mondialement (2 standards USA/Europe), impossible d'insérer/extraire un canal sans démultiplexer toute la trame, topologie point-à-point uniquement, formats de trame différents par niveau, overhead insuffisant pour la gestion réseau.
#text(red, "SDH (Synchronous Digital Hierarchy)"): successeur de PDH — toutes les sources cadencées sur la même horloge (trame *synchrone* de 125 µs), donc pas besoin de plugging bits. Avantage clé: accès/insertion d'un canal en un seul équipement là où PDH en nécessite 4. Débits: *STM-1 = 155.52 Mbit/s*, STM-4 = 622 Mbit/s, STM-16 = 2.4 Gbit/s.
#text(red, "Trame STM-1"): "enveloppe" de 9 lignes × 270 octets = 125 µs. Divisée en *overhead* (les 9 premières colonnes — métadonnées de gestion réseau) et *SPE* (Synchronous Payload Envelope — les données utiles). L'overhead est lui-même structuré en 3 niveaux: *Section OH* (sync, monitoring local), *Line OH* (monitoring, protection, pointeurs), *Path OH* (suivi bout-en-bout du flux).
#image("img/sts_fundamental_building_block.png", width: 100%)
#text(red, "Conteneurs SDH"): emballages hiérarchiques pour transporter des flux de différents débits dans une trame STM. Chaine: C (Container, données brutes) → VC (Virtual Container = C + en-tête de chemin) → TU (Tributary Unit = VC + pointeur) → TUG → AU → STM-N. Débits: C-11=1.5M, C-12=2M, C-2=6.3M, C-3=34/45M, C-4=140M. Multiplexage par entrelacement d'octets pour construire STM-4, STM-16, etc.
#text(red, "OAM&P SDH"): grâce à son overhead riche, SDH permet une gestion réseau bien supérieure à PDH: isolation précise des pannes, communication entre équipements distants, provisioning et monitoring centralisés. Ce que PDH ne pouvait pas faire faute d'overhead suffisant.
#text(red, "ATM (Asynchronous Transfer Mode)"): réseau à commutation de cellules de taille fixe (pas de paquets de taille variable comme Ethernet). Multiplexage temporel asynchrone: les cellules sont envoyées au besoin, pas à intervalles fixes. Connexions négociées bout-en-bout (circuits virtuels). Débits: 25, 155, 622 Mbps. Non standardisé IEEE.
#text(red, "Cellule ATM — 53 octets"): taille fixe = 5 octets d'en-tête + 48 octets de données. Pourquoi 53? Compromis: Europe voulait 32+4 = petites cellules pour réduire le délai sur les lignes lentes (important pour la voix), USA voulait 64+5 = moins d'overhead car les lignes rapides existaient déjà. Résultat: 48+5 = 53 octets.
#text(red, "Format cellule ATM (en-tête 5 octets)"): VPI (Virtual Path Identifier), VCI (Virtual Channel Identifier), PT (Payload Type: données=0, OAM=1), CLP (Cell Loss Priority: la cellule peut être abandonnée si congestion), HEC (Header Error Control). A l'UNI: 4 bits GFC (Generic Flow Control) remplacés par VPI étendu au NNI.
#image("img/cell_format_atm.png", width: 100%)
#text(red, "VPI/VCI"): chaque cellule est adressée par le couple (VPI, VCI). VPI = "tuyau" regroupant plusieurs canaux virtuels (ex: tous les canaux vers un même site). VCI = canal individuel dans ce tuyau. Le même numéro VCI peut exister dans des VPI différents — c'est le couple (VPI,VCI) qui est unique sur un lien.
#text(red, "VP Switching vs VC Switching"): VP Switching = seul le VPI est modifié à chaque noeud, les VCI voyagent intacts (plus simple, plus rapide, pour commuter des groupes de canaux). VC Switching = VPI et VCI sont tous deux remappés à chaque noeud (plus flexible, pour des connexions individuelles).
#text(red, "Circuit Virtuel ATM"): connexion bout-en-bout définie par une suite de couples (VPI/VCI) remappés à chaque switch. Chaque switch a une table: (port_in, VPI/VCI_in) → (port_out, VPI/VCI_out). PVC (Permanent Virtual Circuit) = configuré manuellement. SVC (Switched Virtual Circuit) = établi automatiquement via signalisation UNI.
#text(red, "Classes de service ATM (AAL)"): 4 classes selon 3 critères (synchronisation, débit, mode de connexion). *Classe A*: CBR (débit constant), sync requise, orienté connexion, émulation circuit (voix), AAL1. *Classe B*: VBR, sync requise, orienté connexion, vidéo/audio compressé, AAL2. *Classe C*: VBR, pas de sync, orienté connexion, données, AAL3/4/5. *Classe D*: VBR, pas de sync, sans connexion, données IP, AAL3/4/5.
#image("img/atm_service_classes.png", width: 100%)
#text(red, "LANE (LAN Emulation)"): permet de faire tourner IP/Ethernet sur ATM sans modifier les applications — LANE émule un LAN Ethernet/Token Ring au-dessus du réseau ATM. Composants: LEC (client embarqué dans chaque équipement, gère le forwarding), LES (serveur: résout MAC vers adresse ATM), BUS (Broadcast and Unknown Server: gère les broadcasts), LECS (Configuration Server: assigne les LECs aux ELANs). Chaque ELAN = domaine broadcast = sous-réseau IP.
#text(red, "Classical IP over ATM (RFC 1577)"): alternative à LANE, plus simple. Chaque sous-réseau IP = LIS (Logical IP Subnetwork). Un serveur ARP par LIS résout les adresses IP en adresses ATM. Les hôtes s'enregistrent auprès du serveur ARP de leur LIS.

= MPLS

#text(red, "Problème du routage IP traditionnel"): IP route chaque paquet de façon indépendante en cherchant à chaque noeud le meilleur chemin (longest-match lookup dans la table de routage). Résultat: pas de contrôle sur le délai, jitter ou congestion — impossible de garantir une QoS. Les réseaux modernes (voix, vidéo, VPN) exigent plus.
#text(red, "MPLS (Multi Protocol Label Switching)"): technologie IETF qui attache une étiquette courte (label) à chaque paquet à l'entrée du réseau. Les noeuds intermédiaires forwarden uniquement sur la base de ce label (sans lire l'adresse IP) — forwarding ultra-rapide. Hybride: plan de contrôle IP (routage OSPF/BGP) + plan de forwarding ATM (label swapping). Supporte IP, ATM et Frame-Relay (d'où "multiprotocol"). Bénéfices: vitesse, scalabilité, QoS, traffic engineering.
#text(red, "Label MPLS — format 32 bits"): inséré entre l'en-tête L2 et l'en-tête L3 (shim header = couche 2.5). 4 champs: Label (20 bits, ~1M valeurs possibles, identifie le chemin sur ce lien), Exp/CoS (3 bits, classe de service pour QoS), S — Stack bit (1 bit: 0 = d'autres labels suivent, 1 = dernier label de la pile), TTL (8 bits, Time-to-Live). Portée locale: le même numéro label peut avoir un sens différent sur deux liens différents.
#text(red, "LSP (Label Switched Path)"): chemin prédéterminé bout-en-bout dans le réseau MPLS, défini avant l'envoi des données. Chaque LSP est établi par LDP. 3 opérations sur les labels: PUSH (ingress LER ajoute le label sur le paquet entrant), SWAP (LSR core remplace le label entrant par le label sortant selon sa table), POP (egress LER retire le label et livre le paquet IP nu à destination).
#text(red, "FEC (Forwarding Equivalence Class)"): groupe de paquets traités de façon identique (même label, même LSP). Ex: tous les paquets vers un même préfixe IP = même FEC. Le LER ingress classe chaque paquet entrant dans un FEC et lui attribue le label correspondant — décision de routage prise une seule fois à l'entrée.
#text(red, "LER et LSR"): deux types de noeuds dans un réseau MPLS. LER (Label Edge Router) = routeur de bordure: ingress LER classifie et labellise les paquets entrants (PUSH), egress LER retire le label et livre (POP). LSR (Label Switch Router) = noeud de coeur: swappent les labels à grande vitesse sans examiner l'IP.
#text(red, "LDP (Label Distribution Protocol)"): protocole qui distribue automatiquement les labels entre noeuds MPLS adjacents et établit les LSPs. Fonctionne conjointement avec les protocoles de routage (OSPF, IS-IS, BGP) qui échangent la joignabilité des destinations. RSVP-TE permet en plus de réserver des ressources (bande passante) le long du LSP pour garantir la QoS.
#text(red, "Label stacking (empilement)"): plusieurs labels peuvent être empilés sur un même paquet (RFC 3032). Utile pour les tunnels: le label externe (outer) identifie le tunnel dans le coeur, le label interne (inner) identifie le FEC final. Le bit S=1 marque le dernier label de la pile. Permet de transporter plusieurs flux indépendants sur le même LSP de transport.
#text(red, "Fonctionnement MPLS en 4 étapes"): (1a) Les protocoles de routage (OSPF-TE, IS-IS-TE) échangent la joignabilité des réseaux. (1b) LDP établit les mappings label-destination entre tous les LSR. (2) Le LER ingress reçoit le paquet IP, détermine le FEC, attribue et pousse un label (PUSH). (3) Chaque LSR core lit le label, le swappent selon sa table (SWAP), transmet au prochain saut — sans jamais lire l'IP. (4) Le LER egress retire le label (POP) et livre le paquet IP.
#text(red, "MPLS et ATM"): le mécanisme de forwarding MPLS (label swapping) est identique au forwarding matériel ATM (VCI swapping). Un switch ATM peut donc fonctionner comme un LSR MPLS: il suffit de remplacer le logiciel de contrôle ATM par des protocoles de routage IP et LDP pour établir les tables VCI automatiquement — sans changer le matériel de forwarding.
#text(red, "VPN sur MPLS"): MPLS permet de créer des VPNs (Virtual Private Networks) isolés sur un même coeur réseau partagé. Chaque client a son propre espace d'adressage IP, invisible des autres. Les paquets clients sont encapsulés avec un label de VPN (outer) + label de transport (inner). Le coeur MPLS transporte les flux de plusieurs VPNs simultanément sans qu'ils se voient. Tunnels GRE CE-CE possibles entre sites clients.

= Satellite

#text(red, "Accès satellite"): le satellite joue le rôle de relai entre le coeur réseau (Network Core) et les terminaux ou bases stations mobiles (2G/3G/4G/5G). Utile pour les zones sans infrastructure terrestre (zones rurales, maritimes, aériennes). Le satellite reçoit le signal depuis une station au sol (gateway), l'amplifie et le redirige vers les terminaux.
#text(red, "GEO (Geostationary Orbit)"): orbite à 35 786 km, le satellite reste fixe par rapport à la Terre (même vitesse de rotation). Couverture très large: 3 satellites suffisent pour couvrir toute la Terre (sauf les pôles). Inconvénient: latence aller-retour ~500-600 ms (signal parcourt 72 000 km aller-retour) — rédhibitoire pour la voix temps réel. Opérateurs: Intelsat (~90 GEO, couverture mondiale), Eutelsat (35 GEO + 630 LEO).
#text(red, "LEO (Low Earth Orbit)"): orbite basse 400-2000 km. Latence faible (~5-20 ms) car le signal parcourt une distance bien plus courte qu'en GEO. Inconvénient: le satellite défile rapidement dans le ciel — nécessite une grande constellation pour assurer une couverture continue. Iridium: 66 LEO en maillage cross-linked (les satellites communiquent entre eux directement) = seule constellation offrant 100% de couverture mondiale dont les pôles. Nouvelles méga-constellations: Starlink SpaceX (jusqu'à 12 000 micro-satellites, internet haut débit global), OneWeb (650), Kuiper Amazon (3 236).

= Réseaux Optiques

#text(red, "Structure de la fibre optique"): la fibre transporte la lumière par réflexion totale interne: le coeur (core, indice n1 élevé) est entouré d'une gaine (cladding, indice n2 < n1) — si l'angle d'incidence dépasse l'angle critique, la lumière reste piégée dans le coeur. 3 types: *step-index multimode* (core 200 µm, plusieurs modes de propagation, dispersion élevée, courtes distances), *graded-index multimode* (core 50-100 µm, indice décroissant, dispersion réduite), *singlemode* (core 10 µm, un seul mode, dispersion quasi nulle, longues distances).
#text(red, "Fenêtres télécom (atténuation vs longueur d'onde)"): l'atténuation de la fibre n'est pas uniforme. 3 fenêtres d'utilisation pratique: *850 nm* (1.8 dB/km, 1ère fenêtre, LANs courte distance), *1300 nm* (0.35 dB/km, 2ème fenêtre, LANs et début SONET), *1550 nm* (0.20 dB/km, 3ème fenêtre — minimum d'atténuation absolu, long-haul SONET et amplificateurs EDFA).
#text(red, "Régénération du signal optique (1R/2R/3R)"): sur de longues distances, le signal s'affaiblit et se déforme. 3 niveaux: *1R* (Reamplify: amplificateur optique EDFA, amplifie directement le signal lumineux sans conversion électrique, compense l'atténuation, fonctionne pour tout signal analogique ou numérique), *2R* (Reshape + Reamplify: répéteur optique numérique, corrige aussi la déformation du signal, pas de gestion OAM), *3R* (Reshape + Reamplify + Retime: régénérateur SONET complet, lit l'overhead, resynchronise sur horloge, élimine atténuation + dispersion + jitter).
#text(red, "TDM vs WDM"): deux façons de faire cohabiter plusieurs flux sur une fibre. *TDM (Time Division Multiplexing)*: une seule longueur d'onde, les flux partagent le temps (time slots). *WDM (Wavelength Division Multiplexing)*: plusieurs longueurs d'onde différentes (lambda1, lambda2, …) voyagent simultanément sur la même fibre sans interférer — chaque lambda = canal indépendant. WDM multiplie la capacité d'une fibre sans poser de nouveau câble. DWDM (Dense WDM): grille ITU-T G.694.1, espacements 100/50/25/12.5 GHz autour de 193.1 THz (1550 nm) — permet des dizaines à centaines de canaux par fibre.
#text(red, "Architecture WDM"): chaîne complète: Transponders (E/O, chacun émet sur une lambda précise) → Attenuators (égalise les puissances) → Mux (combine toutes les lambdas sur une fibre) → OFA/EDFA (amplifie tous les canaux simultanément, sans O-E-O) → Demux (sépare les lambdas) → Transponders (O/E). L'EDFA (Erbium-Doped Fiber Amplifier) est la clé: un seul amplificateur traite des dizaines de canaux WDM à la fois dans la fenêtre 1550 nm.
#text(red, "Elastic Optical Network"): modulation adaptative selon la distance: QPSK (phase shifting sur 4 états) pour longues distances (1000 km) à 400 Gbit/s car robuste au bruit, 16QAM pour courtes distances (200 km) à plus haut débit spectral. Elastic channel spacing: largeur de canal variable selon le besoin (pas de grille fixe) pour optimiser l'utilisation du spectre.
#text(red, "Évolution des technologies réseau"): 3 époques. *Ère Circuit* (avant 1990): PDH, transport de voix par circuits dédiés. *Ère Optique* (1990-2000): SDH + WDM, transport numérique synchrone sur fibre, multiplexage en longueur d'onde. *Ère Packet* (depuis 2000): IP/MPLS + OTH + NG-SDH, tout devient paquets IP portés par des couches optiques intelligentes.
#text(red, "Câbles sous-marins"): l'essentiel du trafic internet intercontinental transite par des câbles en fibre optique déposés sur le fond des océans par des navires câbliers spécialisés. Structure renforcée: fibres optiques dans un tube, entourées d'armature acier pour résistance mécanique et protection contre la pression. Longueurs: milliers à dizaines de milliers de km (ex. Atlantic Crossing-1: 14 301 km). Carte mondiale: submarinecablemap.com.

= Cloud and Network Architecture Evolution


Explain the concepts of « Network Virtualisation »
Explain the different services offered by « Cloud » solutions
Describe the general SDN architecture and its main functional components
Describe functionality and placement of OpenFlow in a SDN solution
Explain OpenFlow functions and mecanisms
Locate SDN place in a virtualization architecture

#text(red, "Network architecture evolution"):
4 étapes: *Standalone Servers* > *Server Virtualization* > *Data Center* > *Cloud*. Chaque étape réduit le couplage entre service et hardware physique.
*Standalone Servers*: 1 service = 1 serveur physique dédié, chaque serveur connecté directement au switch/routeur physique. Problème: ressources sous-utilisées, coût élevé.
*Server Virtualization*: N VMs sur 1 seul serveur physique partagé (CPU, RAM, HDD, NIC). Un *vSwitch* interne connecte les VMs entre elles avant de sortir vers le routeur physique. Bénéfice: consolidation, resource sharing, isolation logique.
#text(red, "Network Virtualization (NV)"): la virtualisation des serveurs cache les ressources matérielles mais crée des problèmes avec les architectures réseau traditionnelles. *VLANs*: les VMs doivent être assignées au même port switch que le serveur physique exécutant l'hyperviseur. *Trafic East-West*: dans un data center, une grande partie du trafic est échangée entre serveurs virtuels (East-West), contrairement au modèle client-serveur classique (North-South) — ces flux changent de localisation et d'intensité dans le temps, nécessitant une gestion flexible des ressources réseau. Les infras existantes peuvent répondre via QoS et configurations de sécurité par flux individuel. Limite multi-fournisseurs: chaque nouvelle VM activée nécessite une reconfiguration manuelle chronophage.
#text(red, "NV — Perspective historique"): 4 grandes approches historiques. *VLAN*: isolation logique L2 sur infrastructure partagée. *VPN*: réseau privé virtuel classifié en L1 VPN (circuits physiques dédiés), L2 VPN (tunnels Ethernet/Frame Relay), L3 VPN (routage IP, ex. MPLS), Higher Layer VPNs (SSL, SSH). *Active/Programmable Networks*: deux écoles — Open Signaling (séparation control/forwarding) et Active Networks (nœuds exécutent du code arbitraire) — concepts clés : Programmabilité, Isolation, Provisioning. *Overlay Networks*: réseau logique construit au-dessus d'un ou plusieurs réseaux physiques existants, sans modifier l'infrastructure sous-jacente.
#text(red, "NV — Business Model"): modèle traditionnel: un seul rôle (ISP). Modèle NV: 2 rôles distincts. *InP (Infrastructure Provider)*: déploie et gère les ressources réseau physiques sous-jacentes. *SP (Service Provider)*: loue des ressources auprès de plusieurs InPs, programme ces ressources pour offrir des services bout-en-bout aux utilisateurs finaux. *End User*: similaire à l'Internet existant, mais la coexistence de plusieurs SPs concurrents offre un choix plus large.
#text(red, "NV — Architecture et principes"): une NVE (Network Virtualization Environment) fait coexister plusieurs VNs de différents SPs sur les ressources physiques d'un ou plusieurs InPs. *Coexistence*: plusieurs VNs de SPs différents coexistent sur tout ou partie du réseau physique. *Récursion*: un VN parent peut engendrer des VNs enfants (Child VNs). *Héritage*: les VNs enfants héritent des attributs architecturaux du parent. *Revisitation*: un nœud physique peut héberger plusieurs nœuds virtuels d'un même VN.
#text(red, "NV — Design Goals"): *Flexibilité*: chaque SP libre d'implémenter toute topologie, routage, forwarding et protocoles de contrôle indépendamment du réseau physique et des autres VNs coexistants. *Manageability*: la séparation SP/InP modularise la gestion réseau et introduit l'accountability à chaque couche. *Scalabilité*: coexistence de multiples réseaux sur la même infrastructure. *Isolation*: garantir l'isolation entre VNs coexistants pour la tolérance aux pannes, la sécurité et la vie privée. *Stabilité et Convergence*: erreurs/mauvaises configs dans le réseau physique peuvent déstabiliser toute la NVE ; une instabilité dans un InP (ex. oscillations de routage) peut se propager à tous les VNs hébergés.
#text(red, "NV — Défis de recherche"): Interfaçage, Signalisation et bootstrapping, Découverte des ressources et topologie, Allocation des ressources et provisioning, Contrôle d'admission et surveillance d'usage, Nœuds et liens virtuels, Nommage et adressage, Gestion de la mobilité, Monitoring/Configuration/Gestion des pannes, Sécurité et vie privée, Interopérabilité, Économie de la virtualisation réseau.
#text(red, "NV — À retenir"): la NV occupe une position unique dans l'espace de virtualisation. *D'un côté*: un réseau virtualisé est nécessaire pour interconnecter tous les équipements virtualisés et leur donner une apparence fidèle à leurs homologues physiques. *De l'autre*: l'Internet a atteint un plateau — un redesign est une nécessité, pas un luxe. La NV peut jouer un rôle moteur pour promouvoir l'innovation via des technologies disruptives.
#image("img/nv_internal_external.png", width: 100%)
#text(red, "Data center"): infrastructure physique hébergeant des systèmes informatiques et leurs composants (télécommunications, calcul, stockage). Inclut alimentation redondante, refroidissement, connectivité réseau redondante et contrôle d'accès physique. *Tiers* (certification Uptime Institute): *Tier I* infrastructure basique non-redondante, 99.671% dispo (28.8h downtime/an). *Tier II* composants redondants, 99.741% (22.7h). *Tier III* maintenable en continu (N+1), 99.982% (1.6h). *Tier IV* tolérant aux pannes (2N+1), 99.995% (25 min), équipements dual-powered, résiste 96h sans alimentation externe.
#text(red, "Cloud computing"): applications et services fournis sur Internet depuis des data centers. Transformation IT: Innovation > Produits IT (achat+maintenance) > *Cloud* (on-demand, pay-as-you-go). Analogue à l'eau: générer soi-même > acheter en camion > robinet à la demande. *5 caractéristiques essentielles*: *Resource Pooling* (fondamentale: ressources mutualisées entre clients selon policies), *On-Demand Self-Service* (provisioning sans intervention humaine), *Broad Network Access* (accès réseau universel, sans accès physique), *Rapid Elasticity* (scaling automatique selon la demande), *Measured Service* (facturation à l'usage, à la minute/heure). *Pourquoi*: pay-as-you-go, gestion IT simplifiée, scalabilité instantanée, flexibilité, meilleure utilisation des ressources, réduction empreinte carbone (mutualisation).
#text(red, "IaaS (Infrastructure as a Service)"): outsource de l'équipement (storage, hardware, servers, network). "Migrate to it." *Bénéfices*: billing à l'usage, automation des tâches admin, dynamic scaling, desktop virtualization, policy-based services. *Inconvénients*: moins de contrôle sur le hardware, dépendance provider, latence réseau. *Sécurité*: dépend du modèle de déploiement (cf. Cloud models).
#text(red, "PaaS (Platform as a Service)"): plateforme de dev hébergée chez le provider (DB, runtime, middleware, APIs). Accès via portails web ou APIs. Ex: GoogleEngine. "Build on it." *Bénéfices*: pas à gérer l'infra sous-jacente, accélère le développement. *Inconvénients*: vendor lock-in, moins de flexibilité sur les composants. *Sécurité*: provider sécurise l'infra, client responsable de ses apps et données.
#text(red, "SaaS (Software as a Service)"): application complète hébergée et gérée par le provider, accès browser/mobile. "Consume." *Bénéfices*: admin facilitée, mises à jour automatiques, même version pour tous (compatibilité), collaboration et accessibilité globale. *Inconvénients*: peu de customisation, dépendance Internet, données chez le provider. *Sécurité*: entièrement gérée par le provider, client n'a aucune visibilité sur l'infra.
#image("img/cloud_services.png", width: 100%)
#text(red, "Cloud public"): ressources disponibles (gratuites ou pay-per-usage) au grand public via Internet. Ex: Amazon EC2, IBM Blue Cloud, Google AppEngine, Azure. *Avantages*: simplicité, faible coût, pas de maintenance, pas de contrats HW fournisseurs. *Inconvénients*: pas de contrôle direct, vitesse limitée, sécurité perçue plus faible.
#text(red, "Cloud privé"): architecture propriétaire hébergeant des services pour un nombre limité d'utilisateurs derrière un firewall interne à l'entreprise. *Avantages*: contrôle complet, sécurité potentiellement accrue, haute performance, conformité renforcée, personnalisable. *Inconvénients*: coût élevé, maintenance on-site, plafond de capacité.
#text(red, "Cloud hybride"): organisation gère certaines ressources en interne (privé) et externalise d'autres (public). Ex: cloud public pour données archivées, cloud privé pour données opérationnelles critiques. *Avantages*: scalabilité et coût-efficacité du public sans exposer les apps/données critiques à des vulnérabilités tiers. *Inconvénients*: complexité de gestion, intégration entre environnements, cohérence sécurité difficile.
#text(red, "Network Virtualisation State of the Art"): *Paravirtualization*: guest OS *sait* qu'il est virtualisé, drivers envoient commandes directement au host OS (pas au hardware simulé), inclut memory management. Requiert modification du guest OS. Ex: Xen. *Full Virtualization*: guest OS *ne sait pas* qu'il est virtualisé, host virtualise le hardware (simulated devices), guest OS non modifié. Ex: KVM, QEMU. *Hardware Assisted Virtualization*: type de Full Virtualization où le CPU a des instructions spéciales permettant au guest d'exécuter des instructions privilégiées directement sur le processeur. Sans support CPU: fallback sur *Dynamic Recompilation* (host recompile à la volée les instructions privilégiées). Ex: Xen, VMware, ProxMox. *Hybrid Virtualization*: combo Para + Full, certaines parties du guest en paravirtualisation (ex: IO via driver spécial), d'autres en full virtualization (ex: instructions privilégiées kernel). Performance supérieure sans nécessiter guest entièrement paravirtualisé. Ex: VMware, ProxMox.
#image("img/virtualisation.png", width: 100%)
#text(red, "Virtualisation vs Cloud"): *Virtualisation*: N serveurs sur même hardware physique, VMs facilement déplacées d'un host physique à l'autre. Bénéfice principal: réduction coût infra en maximisant l'usage des ressources physiques. *Cloud*: issu du concept "Utility computing" (pay for what you use). Distribution sur nombreux serveurs: redondance (géographique), haute disponibilité, flexibilité, scalabilité. Inconvénient: pas de contrôle des serveurs. *Différence clé*: virtualisation = optimiser usage du hardware existant (interne), cloud = ressources mesurées/distribuées, accès externe pay-as-you-go. *Lequel choisir ?* Pas de réponse unique. *Coût*: virtualisation = coût upfront élevé (hardware), cloud = faible coût initial mais peut devenir plus cher à mesure que l'usage croît. *Sécurité des données*: virtualisation = données en interne, cloud = données chez le provider.
#text(red, "Virtual Machine"): plusieurs VMs créées sur un seul hardware physique, ressources (CPU, RAM, Network, Storage) partagées entre VMs. *Hypervisor*: logiciel qui crée et exécute des instances VM, traduit les accès au virtual hardware en accès au hardware physique.
#text(red, "Hypervisor Type 1"): "bare metal", installé directement sur le hardware serveur sans OS sous-jacent. Accès direct aux ressources hardware, plus efficace. Requiert une management console. Ex: Citrix XenServer, Microsoft Hyper-V, Oracle VM Server, VMware ESXi.
#text(red, "Hypervisor Type 2"): "hosted", installé sur un OS existant (Windows, Linux, macOS). La machine physique = host machine. Moins efficace (couche OS supplémentaire). Ex: VMware Workstation, Oracle VirtualBox, VMware Fusion, Parallels.
#text(red, "Network Function Virtualization (NFV)"): virtualise les fonctions réseau (routeur, firewall, load balancer…) sur du hardware commodity (COTS) au lieu d'équipements dédiés. *Valeurs*: vitesse, agilité et réduction des coûts. En centralisant sur du hardware commodity, les opérateurs peuvent: concevoir un seul design PoP/site, utiliser les ressources plus efficacement, déployer des fonctions réseau sans envoyer d'ingénieurs sur chaque site, réduire OpEx et CapEx, réduire la complexité système. *Avant (actuel)*: un appliance physique dédié par fonction (router, firewall, load balancer, distribution switch, web servers) — fully redundant, 40A. *Après (NFV)*: toutes les fonctions virtualisées dans le cloud sur des blade servers ou large hypervisors — scalable, 20A.
#image("img/nfv.png", width: 100%)
#text(red, "Composants réseau virtuels"): des composants réseau virtualisés existent déjà. *Cisco*: Nexus 1000-V (vSwitch), Virtual Security Gateway (VSG). *VMware*: vShield Edge (firewall et VPN), vShield Endpoint (conformité sécurité et protection des données). *Extreme Networks*: XNV network hypervisor. *Vyatta*: routeur/firewall/VPN enterprise-grade installé directement sur serveurs physiques pour les transformer en routeurs.
#text(red, "Open vSwitch (OVS)"): switch logiciel open source de qualité production pour environnements serveurs virtualisés. Achemine le trafic entre VMs sur le même hôte physique et entre VMs et le réseau physique. Interfaces de gestion: sFlow, NetFlow, RSPAN, CLI. Programmable et contrôlé via *OpenFlow* et *OVSDB*.
#text(red, "Cloud networking"): objectif: créer un pool fluide de ressources sur serveurs et data centers, accessible à la demande. *2 missions*: permettre le mouvement de ce pool comme ressource virtuelle unique, connecter les utilisateurs indépendamment de leur localisation. *3 structures interdépendantes*: front-end (utilisateurs ↔ apps), horizontal (interconnexion serveurs physiques + mobilité VMs), storage networks. Réseau cloud construit en L2 ou L3. *Exigences*: bande passante on-demand, très faible latence storage/DC/LAN, connexions non bloquantes entre serveurs (mobilité VM), plan de gestion unifié, visibilité malgré l'environnement dynamique.
#text(red, "Problèmes VLAN en cloud"): la virtualisation stresse l'infra réseau: tables MAC des switches surchargées, multi-tenancy/vApps nécessite plus de 4096 VLANs (limite 802.1Q), provisioning VLAN statique incompatible avec la mobilité VM, portée limitée avec STP. *Solutions overlay*: VXLAN, NVGRE, STT — encapsulent du L2 dans du L3.
#text(red, "VXLAN (Virtual eXtensible LAN)"): proposé par Cisco et VMware. Encapsule un réseau L2 virtuel dans des paquets *UDP/IP* (MAC over IP/UDP). *VNI (VXLAN Network Identifier)*: 24 bits → 16 millions de réseaux (chaque VNI contient jusqu'à 4094 VLANs). *VTEP (Virtual Tunnel End Point)*: dans l'hyperviseur, assigne les VNIs aux VMs sans modifier le software VM. *Encapsulation*: Outer MAC (14B) + Outer IP (20B) + Outer UDP (8B) + VXLAN Header (8B) + L2 Frame = *overhead 50B*. *2 types de flux*: tunnels unicast VTEP-to-VTEP (trames unicast connues), groupe multicast VXLAN (broadcast/unknown/multicast).
#text(red, "NVGRE (Network Virtualization using GRE)"): proposé par Microsoft, Intel, HP, Dell. Utilise *GRE* pour créer un réseau L2 virtuel isolé s'étendant sur plusieurs data centers. *TNI/VSID (Tenant Network Identifier)*: 24 bits → 16 millions de réseaux. Chaque TNI associé à un tunnel GRE individuel, paquets en IP multicast. End points dans l'hyperviseur. *Encapsulation*: Outer MAC (14B) + Outer IP (20B) + GRE Header (8B) + L2 Frame = *overhead 42B*.
#text(red, "STT (Stateless Transport Tunneling)"): proposé par Nicira, Broadcom, Rackspace, eBay, Intel, Yahoo. Header *TCP-like* pour bénéficier du TSO (TCP Segmentation Offload) — segmentation déléguée à la NIC, économise CPU. *Context-ID* 64 bits pour séparer les réseaux. *Encapsulation*: Outer MAC + Outer IP + TCP-Like Header + STT Frame Header + L2 Frame = overhead 72B (1er paquet), 54B (suivants). Peut poser des problèmes avec les firewalls.
#text(red, "VM Migration (Live Migration / vMotion)"): déplacer une VM en cours d'exécution d'un *nœud source* vers un *nœud cible*, sans interrompre les connexions réseau actives. Qualifiée de "live" car la VM source continue de tourner pendant la migration. Downtime de l'ordre de quelques *millisecondes*. *Comment*: (1) migration de l'état CPU, (2) migration mémoire par copie itérative — quand le delta résiduel est petit: pause source, copie du delta, reprise sur la cible, (3) migration storage via stockage centralisé partagé, (4) migration réseau. *Bénéfices*: gestion des ressources cloud (économie d'énergie, réduction des coûts, load balancing, maintenance sans interruption).
#text(red, "VM Migration — Implications réseau"): *Même domaine L2*: après migration, un ARP broadcast est envoyé pour mettre à jour les tables ARP des switches. Contraintes VLAN: lien trunking entre serveur physique et switch, tous les serveurs doivent avoir le même ensemble de VLANs, tous les switches intermédiaires doivent participer à ces VLANs — les configurations serveur et switch doivent être synchronisées. Les connexions TCP survivent à la migration (transparent pour la couche transport). *Réseau L3 différent*: nécessite une nouvelle config IP pour la VM et une mise à jour DNS — problématique pour le load balancing et la redondance. Nécessite une reconfiguration IP complète.
#text(red, "VM Migration avec VXLAN"): VXLAN (même principe pour NVGRE ou STT) résout le problème cross-subnet : un réseau L2 virtuel VXLAN est étendu entre les deux sites via le WAN. Les VTEPs (dans les switches/hyperviseurs) encapsulent le trafic en VXLAN sur le WAN — la VM garde sa même IP, aucune reconfiguration nécessaire.
#text(red, "Traffic Trombone"): problème post-migration quand la VM migre vers un autre site mais que ses dépendances (firewall, load balancer, stockage, ressources) restent sur le site d'origine. Le trafic doit traverser le WAN en aller-retour inutilement (HR client → WAN → site origine → WAN → VM migrée) au lieu de rester local. Solution: la flexibilité réseau doit être augmentée — c'est la motivation principale pour le *SDN (Software Defined Networking)*.
#text(red, "SDN (Software Defined Networking)"): architecture réseau qui *sépare* le *control plane* (prise de décision: quelle route, quelle règle ?) du *data plane* (forwarding: exécution physique des décisions). Dans les réseaux traditionnels ces deux plans sont fusionnés dans chaque équipement — SDN les découple en centralisant le contrôle dans un *Network Operating System (netOS)*. Celui-ci collecte les informations des équipements, offre une vue globale du réseau aux applications et leur diffuse les commandes. Les équipements ne font plus que du forwarding. Moteurs de l'essor SDN: Cloud Computing, Big Data, Mobilité.
#text(red, "Réseaux traditionnels — Limites SDN"): *Spécificité*: chaque protocole résout un problème spécifique sans abstraction commune (ex. OSPF a sa propre table de routage, STP sa propre table de spanning tree — aucun partage). *Communication*: pour connaître la topologie globale, chaque équipement doit échanger des messages avec ses voisins (protocoles distribués, coûteux). *Configuration*: chaque équipement configuré séparément → complexité de gestion croissante. *Flexibilité*: tout changement d'architecture (ajout d'une règle, d'une politique) impose la reconfiguration de nombreux équipements. Code source fermé (propriétaire), interactions difficiles entre constructeurs différents.
#text(red, "SDN — Architecture (3 couches)"): *Application Layer*: applications métier (routing, contrôle d'accès, monitoring, traffic engineering) — programmées via la *Northbound API* (interface exposée par le controller vers les apps, ex: REST, NETCONF, XMPP). *Control Layer (Controller)*: cerveau SDN — collecte les infos des équipements, maintient une vue globale du réseau, diffuse les commandes via la *Southbound API* (interface vers les équipements, ex: OpenFlow, OVSDB). *Infrastructure Layer (Data Plane)*: équipements réseau physiques ou virtuels, font uniquement le forwarding de paquets. *2 abstractions clés*: (1) *Common Flow Abstraction* — chaque équipement expose une table d'identifiants et d'actions (Switch API), applicable à routers, switches, etc. (2) *Common Map Abstraction* — le netOS construit et expose une vue logique globale du réseau aux applications.
#text(red, "SDN — Bénéfices"): configuration réseau simplifiée car centralisée en un seul point (controller), architecture dynamique et adaptable à la demande, tout le monde peut développer des applications réseau (pas seulement les constructeurs d'équipements), équipements réseau plus simples, rapides et moins chers (ils ne font que du forwarding), interface de programmation standardisée améliore la vérification, l'extensibilité et la maintenabilité.
#text(red, "SDN — Contrôleurs"): nombreuses solutions. *Open source*: Floodlight, Big Network Controller, OpenDaylight (ODL). *Propriétaires*: Cisco ONE, HP VAN SDN Controller, Juniper JunosV Contrail. Problème: chaque contrôleur utilise une Northbound API différente → applications incompatibles.
#text(red, "SDN — OpenDaylight (ODL)"): contrôleur SDN open source (Eclipse Public License) visant à standardiser une Northbound API commune pour éviter l'incompatibilité entre contrôleurs. Basé sur Cisco ONE. *Architecture en couches*: (1) Application Layer: GUI, orchestration (OpenStack Neutron), protection DDoS… (2) OpenDaylight REST APIs: Northbound commune pour toutes les apps. (3) Controller Platform: fonctions réseau de base (gestionnaire topologie, stats, switches, host tracker, calcul du plus court chemin) + SAL (Service Abstraction Layer = couche d'isolation entre les fonctions réseau et les protocoles southbound). (4) Southbound: OpenFlow 1.0/1.3, OVSDB, NETCONF, BGP, PCEP, SNMP. (5) Data Plane: switches OpenFlow, Open vSwitches, équipements physiques.
#text(red, "SDN — Modèles de déploiement"): 4 modèles d'intégration SDN dans un réseau existant. *Traditional*: planes de contrôle et de données fusionnés dans chaque équipement, gestion via APIs propriétaires du constructeur. *Programmable API*: APIs propriétaires ajoutées pour simplifier la gestion des équipements traditionnels — sans séparer les planes. *Classical SDN*: réseau 100% SDN, plan de contrôle entièrement centralisé dans un controller (via OpenFlow). *Hybrid SDN*: switch pouvant basculer entre son plan de contrôle interne (constructeur) et un plan de contrôle SDN centralisé selon le trafic. *Overlay Network SDN*: tunnels créés au niveau du plan de données pour construire une topologie logique au-dessus du réseau physique — permet de connecter des réseaux non directement connectés physiquement.
#text(red, "SDN — Google SDN WAN (B4)"): Google déploie SDN sur son WAN (Wide Area Network) inter-data centers transportant Gmail, Search, YouTube. *Motivations*: séparer hardware et software (choix indépendants selon les besoins), contrôle réseau logiquement centralisé (plus déterministe, efficace et tolérant aux pannes), automatisation (monitoring, gestion et opérations découplés de chaque équipement individuel). *Architecture*: *Global Broker* (coordonne le Traffic Engineering = optimisation des chemins + allocation de bande passante) → *TE Server* (calcule les chemins, gère les flux et la topologie) → *SDN Gateway* → *Site Brokers* par data center, chacun composé d'un *OFC (OpenFlow Controller)* = cerveau local qui programme les switches, d'un *OFA (OpenFlow Agent)* = agent sur chaque switch qui reçoit les ordres, et d'un routeur de bordure. 2 types de chemins coexistent: *Site Level TE Path* (via SDN, optimisé) et *Non-TE Path* (via ISIS = protocole de routage classique distribué, chemin de secours).
#text(red, "OpenFlow — Définition"): protocole de communication SDN constituant la *Southbound API* (interface entre le controller et les équipements de forwarding). Permet au controller d'accéder directement et de manipuler le plan de forwarding des équipements réseau. Basé sur le concept de *flux* = séquence de paquets partageant les mêmes valeurs de champs header (même src/dst IP, même port TCP, etc.). Standardisé par l'*Open Networking Foundation* (ONF, créée en 2011 par Deutsche Telecom, Google, Facebook, Verizon, Microsoft, Yahoo). Version actuelle: 1.5.1 (2015).
#text(red, "OpenFlow — Architecture"): Controller ↔ OpenFlow Switches via *OpenFlow Channel* (TCP port 6633, TLS possible). 1 connexion principale + N auxiliaires. Multi-controller: *Master* (1, read-write unique), *Equal* (N, read-write, défaut), *Slave* (N, read-only). Switch contient: Flow Table(s) + Group Table + Meter Table + Secure Channel. 2 types: *OpenFlow-only* (tout via pipeline OF) et *OpenFlow-hybrid* (dual pipeline, classification par VLAN tag).
#text(red, "OpenFlow — Flow Table"): le switch contient un pipeline d'au moins une flow table. Chaque *entrée de flux* (règle) contient: *Match Fields* (critères de correspondance: port d'entrée, champs header, metadata d'une table précédente), *Priority* (la règle de plus haute priorité l'emporte — first match), *Counters* (statistiques: paquets/octets reçus, durée), *Instructions* (actions à effectuer quand le paquet matche), *Timeouts* (durée d'inactivité ou durée max avant expiration automatique), *Cookie* (valeur opaque choisie par le controller pour identifier/filtrer les règles). *Entrée table-miss*: règle spéciale (priority 0, match sur tout) déclenchée si aucune règle ne correspond. Si elle n'existe pas: paquets droppés. Champs de match requis: port d'entrée, MAC dst/src, Ethernet type, protocole IP, IPv4/IPv6 src/dst, ports TCP/UDP src/dst.
#text(red, "OpenFlow — Pipeline Processing"): Packet In → Table 0. Par table: (1) trouver highest-priority match, (2) exécuter instructions (modifier paquet + update action set + update metadata), (3) Goto-Table ou exécuter action set final → Packet Out. *Action Set*: collection d'actions associée au paquet, vide par défaut, transporté entre tables, max 1 action de chaque type, exécuté en fin de pipeline dans un ordre fixe.
#text(red, "OpenFlow — Instructions"): déclenchées immédiatement quand un paquet matche une entrée. Résultent en modifications du paquet, de l'action set ou du pipeline. *Meter meter_id*: diriger le paquet vers un compteur de débit (meter) pour du rate-limiting. *Apply-Actions*: exécuter des actions immédiatement (sans attendre la fin du pipeline). *Clear-Actions*: vider complètement l'action set accumulé. *Write-Actions*: ajouter/fusionner des actions dans l'action set courant (exécutées en fin de pipeline). *Write-Metadata*: écrire une valeur dans le champ metadata (pour passer de l'info à la table suivante). *Goto-Table next-id*: rediriger le paquet vers une table de numéro supérieur. Max une instruction de chaque type par entrée, exécutées dans cet ordre précis.
#text(red, "OpenFlow — Actions"): *Output*: forwarder vers un port (ports spéciaux: CONTROLLER, ALL, NORMAL). *Set-Queue*: assigner queue. *Drop*: implicite (action set sans output). *Group*: traiter via groupe. *Push/Pop-Tag*: ajouter/retirer VLAN tags. *Set-Field*: modifier champs header. *Change-TTL*: modifier TTL IPv4/IPv6/MPLS.
#text(red, "OpenFlow — Group Table"): table permettant des comportements de forwarding avancés (multicast, load-balancing, failover). Une flow table peut pointer vers un groupe au lieu d'un port direct. Entrée: Group ID | Group Type | Counters | *Action Buckets* (liste ordonnée de séquences d'actions à exécuter). 4 types de groupe: *All* (exécute tous les buckets, paquet cloné pour chaque → multicast/broadcast), *Indirect* (un seul bucket, permet à plusieurs règles de pointer vers un même groupe → convergence plus rapide), *Select* (exécute un bucket selon algorithme de sélection ex. round-robin → load-balancing), *Fast Failover* (exécute le premier bucket dont le port associé est actif → basculement automatique sans contacter le controller).
#text(red, "OpenFlow — Meter Table"): mesure et contrôle le débit par flux → QoS simple (rate-limiting). Entrée: Meter ID | Meter Bands | Counters. Meter Band: Band Type (drop ou modifier DSCP) | Rate (Kbps) | Counters. Combinable avec queues pour QoS complexe.
#text(red, "OpenFlow — Messages"): 3 types de messages. *Controller→Switch* (le controller interroge ou commande le switch): *Features* (demander les capacités du switch), *Configuration* (paramétrer le switch), *Modify-State* (ajouter/modifier/supprimer des règles dans les tables), *Read-State* (lire stats et configuration), *Packet-out* (injecter un paquet sur un port), *Barrier* (synchronisation: attendre que toutes les opérations précédentes soient terminées). *Asynchronous* (le switch notifie le controller spontanément): *Packet-in* (paquet sans règle correspondante → envoyé au controller pour décision), *Flow-Removed* (règle expirée supprimée), *Port-status* (changement d'état d'un port), *Error*. *Symmetric* (dans les deux sens sans sollicitation): *Hello* (établissement de connexion), *Echo* (vérification que la connexion est vivante + mesure latence), *Experimenter* (extensions propriétaires).
#text(red, "OpenFlow — Flow Instantiation"): 3 façons de peupler les flow tables. *Reactive* (réactif): quand un paquet arrive sans règle correspondante → le switch envoie un *Packet-in* au controller → le controller calcule la décision → répond avec un *Flow Mod* (message pour installer la règle dans le switch) → règle installée pour les prochains paquets. Simple et flexible mais latence sur le premier paquet de chaque flux. *Proactive* (proactif): le controller pré-installe toutes les règles dans les tables avant l'arrivée du trafic → très faible latence, mais nécessite de connaître à l'avance tous les flux possibles. *Hybrid*: combinaison — proactif pour le trafic prévisible (faible latence) + réactif pour les cas particuliers (flexibilité).
#text(red, "OpenFlow — Network Discovery (LLDP)"): le controller effectue la découverte de topologie via LLDP. Les switches envoient des trames LLDP à leurs voisins (multicast MAC spécial, EtherType 0x88cc) → renvoyées au controller via Packet-in → controller reconstruit la topologie.
#text(red, "OpenFlow — Slicing (FlowVisor)"): *FlowVisor* = contrôleur OpenFlow spécial agissant comme un intermédiaire transparent (proxy) entre les switches et plusieurs controllers. Permet de partitionner le réseau en *slices* (tranches logiques) — chaque slice est un sous-ensemble de ressources réseau (ports, trafic correspondant à certains critères) contrôlé par un controller différent et indépendant. Utilité: plusieurs organisations ou expériences réseau peuvent coexister sur la même infrastructure physique sans interférer. Critères de définition d'une slice: ports switch, adresses MAC src/dst, type Ethernet, code/type ICMP, adresses IP src/dst, ports UDP/TCP src/dst.
