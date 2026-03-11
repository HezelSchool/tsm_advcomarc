import socket
import os
from crypto import generate_rand, compute_sres, generate_kc, xor_cipher
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
        decrypted_data = xor_cipher(encrypted_data, session.kc)
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
        encrypted_response = xor_cipher(data, session.kc)
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