/*
 * --------------------------------------------------------------------------------
 * File: /home/hezeltm/Projects/typst_template/practical_work/section/implementation.typ
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

#import "../helper.typ": qbox

// ---------- Implementation

= Code Python

== config.py

Ce script contient les paramètres de configuration globaux utilisés par le client et le serveur, notamment les paramètres de connexion, la clé secrète Ki et la durée de session.

```python
SERVER_HOST = "127.0.0.1"
SERVER_PORT = 5000

# Clé secrète partagée (Ki)
KI = b"SuperSecretKi123"

SESSION_DURATION = 20 * 60  # 20 minutes en secondes
BUFFER_SIZE = 4096
```

== crypto.py

Ce script implémente les fonctions cryptographiques nécessaires pour le challenge d'authentification, le chiffrement/déchiffrement des données, et la génération des tokens d'authentification.

```python
import os
import hashlib

# --- RAND ---
def generate_rand():
    return os.urandom(16)  # 128 bits

# --- A3 (Simulation SRES) ---
def compute_sres(rand, ki):
    data = ki + rand
    hash_value = hashlib.sha256(data).digest()
    return hash_value[:8]  # 64 bits

# --- A8 (Simulation Kc) ---
def generate_kc(rand, ki):
    data = rand + ki
    hash_value = hashlib.sha256(data).digest()
    return hash_value[:16]  # 128-bit session key

# --- A5 Encryption/Decryption ---
def generate_keystream(kc, length):
    """
    Génère un flot pseudo-aléatoire à partir de Kc
    """
    keystream = b""
    counter = 0

    while len(keystream) < length:
        block = hashlib.sha256(kc + counter.to_bytes(4, 'big')).digest()
        keystream += block
        counter += 1

    return keystream[:length]


def a5_cipher(data, kc):
    """
    Chiffrement / déchiffrement (symétrique)
    """
    ks = generate_keystream(kc, len(data))
    return bytes([d ^ k for d, k in zip(data, ks)])
```

== session.py

Ce script gère l'état d'une session d'authentification.

```python
import time
from config import SESSION_DURATION

class Session:
    def __init__(self, kc):
        self.kc = kc
        self.created_at = time.time()

    def is_valid(self):
        return (time.time() - self.created_at) < SESSION_DURATION
```

== server.py

Ce script implémente un serveur d'authentification GSM. Il gère les connexions entrantes, le processus d'authentification, la réception de données chiffrées, et l'envoi de données chiffrées au client. Le serveur suit les étapes définies dans le protocole d'authentification GSM, en utilisant les fonctions cryptographiques définies dans crypto.py.

```python
import socket
import os
from crypto import generate_rand, compute_sres, generate_kc, a5_cipher
from session import Session
from config import *

def handle_client(conn):
    try:
        print("[SERVER] Client connecté")
        print("[SERVER] Début de l'authentification")

        # 1. Génération RAND
        rand = generate_rand()
        print(f"[SERVER] RAND généré: {rand.hex()[:32]} ({len(rand)} octets)")
        conn.sendall(rand)

        # 2. Réception SRES
        client_sres = conn.recv(1024)
        print(f"[SERVER] SRES reçu du client: {client_sres.hex()} ({len(client_sres)} octets)")

        # 3. Vérification
        expected_sres = compute_sres(rand, KI)
        print(f"[SERVER] SRES attendu: {expected_sres.hex()}")

        if client_sres != expected_sres:
            conn.sendall(b"AUTH_FAILED")
            print("[SERVER] Authentification échouée")
            return

        conn.sendall(b"AUTH_SUCCESS")
        print("[SERVER] Authentification réussie")

        # 4. Génération session
        kc = generate_kc(rand, KI)
        print(f"[SERVER] Clé de session Kc générée: {kc.hex()[:32]} ({len(kc)} octets)")
        session = Session(kc)
        print(f"[SERVER] Session créée à {session.created_at}")

        # 5. Réception fichier chiffré
        print("[SERVER] Réception du fichier chiffré")
        encrypted_data = b""
        chunk_count = 0
        while True:
            chunk = conn.recv(BUFFER_SIZE)
            if not chunk:
                break
            encrypted_data += chunk
            chunk_count += 1

        print(f"[SERVER] Fichier chiffré complet reçu: {len(encrypted_data)} octets")

        if not session.is_valid():
            print("[SERVER] Session expirée")
            return

        print("[SERVER] Déchiffrement en cours")
        decrypted_data = a5_cipher(encrypted_data, session.kc)
        print(f"[SERVER] Fichier déchiffré: {len(decrypted_data)} octets")

        with open("files/server_received.mp3", "wb") as f:
            f.write(decrypted_data)

        print("[SERVER] Fichier reçu et déchiffré")

        # 6. Envoi fichier serveur
        print("[SERVER] Lecture du fichier à envoyer")
        with open("files/bombinsound-rap-rap-beat-beats-music-20-second-491118.mp3", "rb") as f:
            data = f.read()

        print(f"[SERVER] Fichier lu: {len(data)} octets")
        print("[SERVER] Chiffrement en cours")
        encrypted_response = a5_cipher(data, session.kc)
        print(f"[SERVER] Fichier chiffré: {len(encrypted_response)} octets")
        print("[SERVER] Envoi du fichier")
        conn.sendall(encrypted_response)

        print("[SERVER] Fichier envoyé")

    except Exception as e:
        print(f"[SERVER ERROR] {e}")
    finally:
        conn.close()

def start_server():
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server.bind((SERVER_HOST, SERVER_PORT))
    server.listen(1)
    print(f"[SERVER] En écoute sur {SERVER_HOST}:{SERVER_PORT}")

    while True:
        conn, addr = server.accept()
        handle_client(conn)

if __name__ == "__main__":
    start_server()
```

== client.py

Ce script implémente un client d'authentification GSM. Il gère la connexion au serveur, le processus d'authentification, l'envoi de données chiffrées, et la réception de données chiffrées du serveur. Le client suit les étapes définies dans le protocole d'authentification GSM, en utilisant les fonctions cryptographiques définies dans crypto.py.

```python
import socket
from crypto import compute_sres, generate_kc, a5_cipher
from config import *

def start_client():
    print(f"[CLIENT] Connexion au serveur {SERVER_HOST}:{SERVER_PORT}")
    client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    client.connect((SERVER_HOST, SERVER_PORT))
    print("[CLIENT] Connecté")

    # 1. Réception RAND
    rand = client.recv(1024)
    print(f"[CLIENT] RAND reçu: {rand.hex()[:32]} ({len(rand)} octets)")

    # 2. Calcul SRES
    print("[CLIENT] Calcul du SRES")
    sres = compute_sres(rand, KI)
    print(f"[CLIENT] SRES calculé: {sres.hex()} ({len(sres)} octets)")
    client.sendall(sres)
    print("[CLIENT] SRES envoyé au serveur")

    # 3. Vérification résultat
    response = client.recv(1024)
    print(f"[CLIENT] Réponse d'authentification: {response.decode('utf-8', errors='ignore')}")

    if response != b"AUTH_SUCCESS":
        print("[CLIENT] Authentification échouée")
        return

    print("[CLIENT] Authentification réussie")

    # 4. Génération Kc
    print("[CLIENT] Génération de la clé de session")
    kc = generate_kc(rand, KI)
    print(f"[CLIENT] Clé de session Kc: {kc.hex()[:32]} ({len(kc)} octets)")

    # 5. Envoi fichier
    print("[CLIENT] Lecture du fichier à envoyer")
    with open("files/bombinsound-rap-rap-beat-beats-music-20-second-491118.mp3", "rb") as f:
        data = f.read()

    print(f"[CLIENT] Fichier lu: {len(data)} octets")
    print("[CLIENT] Chiffrement en cours")
    encrypted_data = a5_cipher(data, kc)
    print(f"[CLIENT] Fichier chiffré: {len(encrypted_data)} octets")
    print("[CLIENT] Envoi du fichier")
    client.sendall(encrypted_data)
    client.shutdown(socket.SHUT_WR)

    print("[CLIENT] Fichier envoyé")

    # 6. Réception fichier serveur
    print("[CLIENT] Réception du fichier du serveur")
    encrypted_response = b""
    chunk_count = 0
    while True:
        chunk = client.recv(BUFFER_SIZE)
        if not chunk:
            break
        encrypted_response += chunk
        chunk_count += 1

    print(f"[CLIENT] Fichier chiffré complet reçu: {len(encrypted_response)} octets")
    print("[CLIENT] Déchiffrement en cours")
    decrypted_response = a5_cipher(encrypted_response, kc)
    print(f"[CLIENT] Fichier déchiffré: {len(decrypted_response)} octets")

    with open("files/client_received.mp3", "wb") as f:
        f.write(decrypted_response)

    print("[CLIENT] Fichier reçu et déchiffré")

    client.close()
    print("[CLIENT] Connexion fermée")

if __name__ == "__main__":
    start_client()
```

= Capture du fonctionnement

#figure(
  image("../asset/Cap1.png", width: 100%),
  caption: [Capture fonctionnement côté serveur],
) <fig-server>

#figure(
  image("../asset/Cap2.png", width: 100%),
  caption: [Capture fonctionnement côté client],
) <fig-client>
