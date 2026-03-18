"""
Module de gestion de session pour l'authentification GSM/LTE
Gère l'état de la session et les opérations d'authentification
"""

from config import Ki, DEBUG
from crypto import compute_sres, derive_kc, xor_cipher, compute_auth_token


class Session:
    """
    Classe gérant l'état d'une session d'authentification
    """
    
    def __init__(self):
        self.rand = None
        self.kc = None
        self.authenticated = False
        self.server_authenticated = False
        if DEBUG:
            print("[SESSION] Session initialisée")
    
    def set_rand(self, rand):
        """
        Enregistre le RAND reçu/généré
        """
        self.rand = rand
        if DEBUG:
            print(f"[SESSION] RAND enregistré: {rand.hex()}")
    
    def authenticate_client(self, received_sres):
        """
        Authentifie le client en vérifiant le SRES reçu
        
        Args:
            received_sres: SRES reçu du client
        
        Returns:
            True si authentifié, False sinon
        """
        if self.rand is None:
            if DEBUG:
                print("[SESSION] Erreur: RAND non défini")
            return False
        
        expected_sres = compute_sres(self.rand, Ki)
        self.authenticated = (received_sres == expected_sres)
        
        if DEBUG:
            if self.authenticated:
                print("[SESSION] Client authentifié avec succès")
            else:
                print("[SESSION] Échec d'authentification du client")
                print(f"[SESSION]   SRES attendu: {expected_sres.hex()}")
                print(f"[SESSION]   SRES reçu: {received_sres.hex()}")
        
        return self.authenticated
    
    def authenticate_server(self, received_token):
        """
        Authentifie le serveur en vérifiant le token reçu
        
        Args:
            received_token: Token reçu du serveur
        
        Returns:
            True si authentifié, False sinon
        """
        if self.rand is None:
            if DEBUG:
                print("[SESSION] Erreur: RAND non défini")
            return False
        
        expected_token = compute_auth_token(self.rand, Ki)
        self.server_authenticated = (received_token == expected_token)
        
        if DEBUG:
            if self.server_authenticated:
                print("[SESSION] Serveur authentifié avec succès")
            else:
                print("[SESSION] Échec d'authentification du serveur")
                print(f"[SESSION]   Token attendu: {expected_token.hex()}")
                print(f"[SESSION]   Token reçu: {received_token.hex()}")
        
        return self.server_authenticated
    
    def establish_session_key(self):
        """
        Établit la clé de session Kc
        
        Returns:
            La clé de session Kc
        """
        if self.rand is None:
            if DEBUG:
                print("[SESSION] Erreur: RAND non défini")
            return None
        
        self.kc = derive_kc(self.rand, Ki)
        if DEBUG:
            print(f"[SESSION] Clé de session établie: {self.kc.hex()}")
        return self.kc
    
    def encrypt_data(self, data):
        """
        Chiffre des données avec la clé de session
        
        Args:
            data: Données à chiffrer
        
        Returns:
            Données chiffrées
        """
        if self.kc is None:
            if DEBUG:
                print("[SESSION] Erreur: Clé de session non établie")
            return None
        
        if DEBUG:
            print(f"[SESSION] Chiffrement de {len(data)} octets")
        
        return xor_cipher(data, self.kc)
    
    def decrypt_data(self, cipher_data):
        """
        Déchiffre des données avec la clé de session
        
        Args:
            cipher_data: Données chiffrées
        
        Returns:
            Données déchiffrées
        """
        if self.kc is None:
            if DEBUG:
                print("[SESSION] Erreur: Clé de session non établie")
            return None
        
        if DEBUG:
            print(f"[SESSION] Déchiffrement de {len(cipher_data)} octets")
        
        return xor_cipher(cipher_data, self.kc)
    
    def get_auth_token(self):
        """
        Génère le token d'authentification du serveur
        
        Returns:
            Token d'authentification
        """
        if self.rand is None:
            if DEBUG:
                print("[SESSION] Erreur: RAND non défini")
            return None
        
        return compute_auth_token(self.rand, Ki)
    
    def is_authenticated(self):
        """
        Vérifie si la session est authentifiée
        
        Returns:
            True si authentifié, False sinon
        """
        return self.authenticated
    
    def is_server_authenticated(self):
        """
        Vérifie si le serveur est authentifié
        
        Returns:
            True si authentifié, False sinon
        """
        return self.server_authenticated
