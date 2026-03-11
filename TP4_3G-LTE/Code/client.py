import socket
from config import HOST, PORT, DEBUG
from crypto import compute_sres
from session import Session

def main():
    """
    Client d'authentification GSM/LTE
    """
    # Initialisation de la session
    session = Session()
    
    # Connexion au serveur
    client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    
    print(f"[CLIENT] Connexion au serveur {HOST}:{PORT}...")
    
    try:
        client.connect((HOST, PORT))
        print("[CLIENT] Connecté au serveur")
        print()
        
        # ÉTAPE 1: Réception du RAND
        print("[CLIENT] Attente du RAND du serveur...")
        RAND = client.recv(1024)
        session.set_rand(RAND)
        print(f"[CLIENT] RAND reçu: {RAND.hex()}")
        print()
        
        # ÉTAPE 2: Calcul et envoi du SRES
        print("[CLIENT] Calcul du SRES...")
        from config import Ki
        SRES = compute_sres(RAND, Ki)
        print(f"[CLIENT] SRES calculé: {SRES.hex()}")
        client.send(SRES)
        print("[CLIENT] SRES envoyé au serveur")
        print()
        
        # ÉTAPE 3: Authentification du serveur
        print("[CLIENT] Attente du token d'authentification...")
        token = client.recv(1024)
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
        
        # ÉTAPE 5: Envoi de données chiffrées
        # Paquet de données (~256 bits)
        data = b"a3f7b2c1d9e845607f2c1a3b9d4e6f8a01c3b5d7e9f2a4c6b8d0e1f3a5c7b9d0"
        print(f"[CLIENT] Données à envoyer ({len(data)} octets): {data}")
        
        cipher = session.encrypt_data(data)
        print(f"[CLIENT] Données chiffrées: {cipher.hex()}")
        client.send(cipher)
        print("[CLIENT] Données envoyées au serveur")
        print()
        
        # ÉTAPE 6: Réception de la réponse
        print("[CLIENT] Attente de la réponse du serveur...")
        cipher_resp = client.recv(1024)
        print(f"[CLIENT] Réponse chiffrée reçue: {cipher_resp.hex()}")
        
        resp = session.decrypt_data(cipher_resp)
        print(f"[CLIENT] Réponse déchiffrée: {resp}")
        print()
        
    except Exception as e:
        print(f"[CLIENT] Erreur: {e}")
    finally:
        client.close()
        print("[CLIENT] Connexion fermée")

if __name__ == "__main__":
    main()