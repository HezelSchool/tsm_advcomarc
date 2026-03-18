import socket
from config import HOST, PORT, DEBUG
from crypto import generate_rand
from session import Session

def main():
    """
    Serveur d'authentification GSM/LTE
    """
    # Initialisation de la session
    session = Session()
    
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
        conn.send(RAND)
        print(f"[SERVEUR] RAND envoyé au client: {RAND.hex()}")
        print()
        
        # ÉTAPE 2: Réception et vérification du SRES
        print("[SERVEUR] Attente de la réponse SRES du client...")
        client_sres = conn.recv(1024)
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
        conn.send(token)
        print(f"[SERVEUR] Token d'authentification envoyé: {token.hex()}")
        print()
        
        # ÉTAPE 4: Établissement de la clé de session
        Kc = session.establish_session_key()
        print(f"[SERVEUR] Clé de session Kc établie: {Kc.hex()}")
        print()
        
        # ÉTAPE 5: Réception des données chiffrées
        print("[SERVEUR] Attente des données du client...")
        cipher_data = conn.recv(1024)
        print(f"[SERVEUR] Données chiffrées reçues ({len(cipher_data)} octets): {cipher_data.hex()}")
        
        plain = session.decrypt_data(cipher_data)
        print(f"[SERVEUR] Données déchiffrées: {plain}")
        print()
        
        # ÉTAPE 6: Envoi de la réponse chiffrée
        message = b"Accuse de reception"
        print(f"[SERVEUR] Message à envoyer: {message}")
        cipher = session.encrypt_data(message)
        print(f"[SERVEUR] Message chiffré: {cipher.hex()}")
        conn.send(cipher)
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