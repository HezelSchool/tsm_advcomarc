import socket
from crypto import compute_sres, generate_kc, xor_cipher
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
    encrypted_data = xor_cipher(data, kc)
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
    decrypted_response = xor_cipher(encrypted_response, kc)
    print(f"[CLIENT] Fichier déchiffré: {len(decrypted_response)} octets")

    with open("files/client_received.mp3", "wb") as f:
        f.write(decrypted_response)

    print("[CLIENT] Fichier reçu et déchiffré")

    client.close()
    print("[CLIENT] Connexion fermée")

if __name__ == "__main__":
    start_client()