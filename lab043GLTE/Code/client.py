import socket
import os
import struct
from config import (
    HOST,
    PORT,
    DEBUG,
    FILES_DIR,
    CLIENT_INPUT_FILE,
    CLIENT_RECEIVED_FILE,
)
from crypto import compute_sres
from session import Session


def recv_exact(conn, size):
    """
    Reçoit exactement 'size' octets depuis la connexion.
    
    Args:
        conn: Socket de connexion
        size: Nombre d'octets à recevoir
    
    Returns:
        Données brutes reçues
    """
    data = b""
    while len(data) < size:
        chunk = conn.recv(size - len(data))
        if not chunk:
            raise ConnectionError("Connexion interrompue")
        data += chunk
    return data


def send_frame(conn, payload):
    """
    Envoie un frame: longueur (4 bytes) + payload.
    
    Args:
        conn: Socket de connexion
        payload: Contenu du frame à envoyer
    """
    conn.sendall(struct.pack("!I", len(payload)) + payload)


def recv_frame(conn):
    """
    Reçoit un frame: lit d'abord la longueur, puis le contenu.
    
    Args:
        conn: Socket de connexion
    
    Returns:
        Contenu du frame reçu
    """
    header = recv_exact(conn, 4)
    length = struct.unpack("!I", header)[0]
    return recv_exact(conn, length)


def pack_file_payload(filename, content):
    """
    Encode un fichier au format: longueur du nom (2 bytes) + nom + contenu.
    
    Args:
        filename: Nom du fichier
        content: Contenu du fichier en bytes
    
    Returns:
        Payload encodé prêt à être chiffré/envoyé
    """
    name_bytes = filename.encode("utf-8")
    if len(name_bytes) > 65535:
        raise ValueError("Nom de fichier trop long")
    return struct.pack("!H", len(name_bytes)) + name_bytes + content


def unpack_file_payload(payload):
    """
    Décode un fichier à partir du payload reçu.
    
    Args:
        payload: Payload encodé au format: longueur nom + nom + contenu
    
    Returns:
        Tuple (filename, content) - nom et contenu du fichier
    """
    if len(payload) < 2:
        raise ValueError("Payload fichier invalide")
    name_len = struct.unpack("!H", payload[:2])[0]
    if len(payload) < 2 + name_len:
        raise ValueError("Payload fichier tronque")
    filename = payload[2:2 + name_len].decode("utf-8", errors="replace")
    content = payload[2 + name_len:]
    return filename, content

def main():
    """
    Client d'authentification GSM/LTE
    """
    # Initialisation de la session
    session = Session(role="client")

    os.makedirs(FILES_DIR, exist_ok=True)
    
    # Connexion au serveur
    client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    
    print(f"[CLIENT] Connexion au serveur {HOST}:{PORT}...")
    
    try:
        client.connect((HOST, PORT))
        print("[CLIENT] Connecté au serveur")
        print()
        
        # ÉTAPE 1: Réception du RAND
        print("[CLIENT] Attente du RAND du serveur...")
        RAND = recv_frame(client)
        session.set_rand(RAND)
        print(f"[CLIENT] RAND reçu: {RAND.hex()}")
        print()
        
        # ÉTAPE 2: Calcul et envoi du SRES
        print("[CLIENT] Calcul du SRES...")
        from config import Ki
        SRES = compute_sres(RAND, Ki)
        print(f"[CLIENT] SRES calculé: {SRES.hex()}")
        send_frame(client, SRES)
        print("[CLIENT] SRES envoyé au serveur")
        print()
        
        # ÉTAPE 3: Authentification du serveur
        print("[CLIENT] Attente du token d'authentification...")
        token = recv_frame(client)
        print(f"[CLIENT] Token reçu: {token.hex()}")
        
        if not session.authenticate_server(token):
            print("[CLIENT] ÉCHEC: Serveur non authentifié")
            client.close()
            return
        
        print("[CLIENT] Serveur authentifié avec succès")
        print()
        
        # ÉTAPE 4: Établissement de la clé de session
        Kc = session.establish_session_key()
        print(f"[CLIENT] Clé de session Kc établie: {Kc.hex()}")
        print()
        
        # ÉTAPE 5: Envoi d'un fichier chiffré
        if not os.path.exists(CLIENT_INPUT_FILE):
            default_content = (
                b"Fichier client pour simulation securisee 3G/LTE.\n"
                b"Contenu chiffre avec Kc temporaire, nonce, compteur et tag MAC.\n"
            )
            with open(CLIENT_INPUT_FILE, "wb") as default_file:
                default_file.write(default_content)

        with open(CLIENT_INPUT_FILE, "rb") as input_file:
            file_content = input_file.read()

        print(f"[CLIENT] Fichier a envoyer: {CLIENT_INPUT_FILE} ({len(file_content)} octets)")
        payload = pack_file_payload(os.path.basename(CLIENT_INPUT_FILE), file_content)

        cipher = session.encrypt_data(payload)
        if cipher is None:
            print("[CLIENT] Erreur: cle de session invalide/expiree")
            return

        print(f"[CLIENT] Données chiffrées: {cipher.hex()}")
        send_frame(client, cipher)
        print("[CLIENT] Données envoyées au serveur")
        print()
        
        # ÉTAPE 6: Réception de la réponse
        print("[CLIENT] Attente de la réponse du serveur...")
        cipher_resp = recv_frame(client)
        print(f"[CLIENT] Réponse chiffrée reçue: {cipher_resp.hex()}")
        
        resp = session.decrypt_data(cipher_resp)
        if resp is None:
            print("[CLIENT] Erreur: echec de dechiffrement/verification integrite")
            return

        reply_name, reply_content = unpack_file_payload(resp)
        with open(CLIENT_RECEIVED_FILE, "wb") as received_file:
            received_file.write(reply_content)

        print(f"[CLIENT] Fichier recu du serveur: {reply_name} ({len(reply_content)} octets)")
        print(f"[CLIENT] Fichier sauvegarde: {CLIENT_RECEIVED_FILE}")
        print()
        
    except Exception as e:
        print(f"[CLIENT] Erreur: {e}")
    finally:
        client.close()
        print("[CLIENT] Connexion fermée")

if __name__ == "__main__":
    main()