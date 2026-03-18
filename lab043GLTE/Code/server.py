import socket
import os
import struct
from config import HOST, PORT, DEBUG, FILES_DIR, SERVER_RECEIVED_FILE, SERVER_REPLY_FILE
from crypto import generate_rand
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
    Serveur d'authentification 3G/LTE
    """
    # Initialisation de la session
    session = Session(role="server")

    os.makedirs(FILES_DIR, exist_ok=True)
    
    # Création du socket serveur
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.bind((HOST, PORT))
    server.listen(1)
    
    print(f"[SERVEUR] En attente de connexion sur {HOST}:{PORT}...")
    print()
    
    conn, addr = server.accept()
    print(f"[SERVEUR] Client connecté depuis: {addr}")
    print()
    
    try:
        # ÉTAPE 1: Génération et envoi du RAND
        RAND = generate_rand()
        session.set_rand(RAND)
        send_frame(conn, RAND)
        print(f"[SERVEUR] RAND envoyé au client: {RAND.hex()}")
        print()
        
        # ÉTAPE 2: Réception et vérification du SRES
        print("[SERVEUR] Attente de la réponse SRES du client...")
        client_sres = recv_frame(conn)
        print(f"[SERVEUR] SRES reçu: {client_sres.hex()}")
        
        if not session.authenticate_client(client_sres):
            print("[SERVEUR] ÉCHEC: Authentification du client échouée")
            conn.close()
            server.close()
            return
        
        print("[SERVEUR] Client authentifié avec succès")
        print()
        
        # ÉTAPE 3: Authentification du serveur auprès du client
        token = session.get_auth_token()
        send_frame(conn, token)
        print(f"[SERVEUR] Token d'authentification envoyé: {token.hex()}")
        print()
        
        # ÉTAPE 4: Établissement de la clé de session
        Kc = session.establish_session_key()
        print(f"[SERVEUR] Clé de session Kc établie: {Kc.hex()}")
        print()
        
        # ÉTAPE 5: Réception des données chiffrées
        print("[SERVEUR] Attente des données du client...")
        cipher_data = recv_frame(conn)
        print(f"[SERVEUR] Données chiffrées reçues ({len(cipher_data)} octets): {cipher_data.hex()}")
        
        plain = session.decrypt_data(cipher_data)
        if plain is None:
            print("[SERVEUR] Erreur: echec de dechiffrement/verification integrite")
            return

        filename, file_content = unpack_file_payload(plain)
        with open(SERVER_RECEIVED_FILE, "wb") as out_file:
            out_file.write(file_content)

        print(f"[SERVEUR] Fichier recu: {filename} ({len(file_content)} octets)")
        print(f"[SERVEUR] Fichier sauvegarde: {SERVER_RECEIVED_FILE}")
        print()
        
        # ÉTAPE 6: Envoi de la réponse chiffrée
        server_text = (
            b"Accuse de reception: fichier client recu et verifie.\n"
            b"Simulation 3G/LTE: chiffrement flot + integrite HMAC + compteur.\n"
        )
        with open(SERVER_REPLY_FILE, "wb") as reply_file:
            reply_file.write(server_text)

        reply_payload = pack_file_payload(os.path.basename(SERVER_REPLY_FILE), server_text)
        print(f"[SERVEUR] Fichier de reponse a envoyer: {SERVER_REPLY_FILE}")

        cipher = session.encrypt_data(reply_payload)
        if cipher is None:
            print("[SERVEUR] Erreur: cle de session invalide/expiree")
            return

        print(f"[SERVEUR] Message chiffré: {cipher.hex()}")
        send_frame(conn, cipher)
        print("[SERVEUR] Réponse envoyée au client")
        print()
        
    except Exception as e:
        print(f"[SERVEUR] Erreur: {e}")
    finally:
        conn.close()
        server.close()
        print("[SERVEUR] Connexion fermée")

if __name__ == "__main__":
    main()