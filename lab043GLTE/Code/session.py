"""
Module de gestion de session pour l'authentification GSM/LTE
Gère l'état de la session et les opérations d'authentification
"""

import time
from config import Ki, DEBUG, KEY_VALIDITY_SECONDS
from crypto import (
    compute_sres,
    derive_kc,
    derive_keystream_keys,
    encrypt_packet,
    decrypt_packet,
    compute_auth_token,
)


class Session:
    """
    Classe gérant l'état d'une session d'authentification
    """
    
    def __init__(self, role):
        if role not in ("client", "server"):
            raise ValueError("role doit valoir 'client' ou 'server'")

        self.role = role
        self.rand = None
        self.kc = None
        self.k_enc = None
        self.k_mac = None
        self.authenticated = False
        self.server_authenticated = False
        self.kc_created_at = None
        self.kc_expires_at = None
        self.tx_count = 0
        self.expected_rx_count = 0
        if DEBUG:
            print(f"[SESSION] Session initialisee (role={self.role})")
    
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
        self.k_enc, self.k_mac = derive_keystream_keys(self.kc)
        self.kc_created_at = time.time()
        self.kc_expires_at = self.kc_created_at + KEY_VALIDITY_SECONDS
        self.tx_count = 0
        self.expected_rx_count = 0
        if DEBUG:
            print(f"[SESSION] Cle de session etablie: {self.kc.hex()}")
            print(f"[SESSION] Cle valide jusqu'a: {time.ctime(self.kc_expires_at)}")
        return self.kc

    def _ensure_key_usable(self):
        """
        Vérifie que la clé de session est établie et non expirée.
        
        Returns:
            True si la clé est utilisable, False sinon
        """
        if self.kc is None or self.k_enc is None or self.k_mac is None:
            if DEBUG:
                print("[SESSION] Erreur: Cle de session non etablie")
            return False

        if time.time() > self.kc_expires_at:
            if DEBUG:
                print("[SESSION] Erreur: Cle de session expiree")
            return False

        return True

    def _tx_direction(self):
        """
        Retourne le type de direction pour l'émission (transmission).
        
        Returns:
            0 pour uplink (client->serveur), 1 pour downlink (serveur->client)
        """
        return 0 if self.role == "client" else 1

    def _rx_direction(self):
        """
        Retourne le type de direction pour la réception.
        
        Returns:
            1 pour downlink reçu par client, 0 pour uplink reçu par serveur
        """
        return 1 if self.role == "client" else 0
    
    def encrypt_data(self, data):
        """
        Chiffre et authentifie des données avec la clé de session.
        
        Args:
            data: Données à chiffrer
        
        Returns:
            Paquet chiffré avec tag d'intégrité, ou None si clé non válid
        """
        if not self._ensure_key_usable():
            return None

        if DEBUG:
            print(f"[SESSION] Chiffrement de {len(data)} octets (count={self.tx_count})")

        packet = encrypt_packet(
            plain_data=data,
            k_enc=self.k_enc,
            k_mac=self.k_mac,
            count=self.tx_count,
            direction=self._tx_direction(),
        )
        self.tx_count += 1
        return packet
    
    def decrypt_data(self, cipher_data):
        """
        Vérifie l'intégrité et déchiffre des données de session.
        
        Args:
            cipher_data: Paquet chiffré à déchiffrer
        
        Returns:
            Données déchiffrées, ou None si vérification échoue
        """
        if not self._ensure_key_usable():
            return None

        if DEBUG:
            print(f"[SESSION] Dechiffrement de {len(cipher_data)} octets")

        try:
            count, plain_data = decrypt_packet(
                packet=cipher_data,
                k_enc=self.k_enc,
                k_mac=self.k_mac,
                direction=self._rx_direction(),
            )
        except ValueError as err:
            if DEBUG:
                print(f"[SESSION] Erreur de dechiffrement: {err}")
            return None

        if count != self.expected_rx_count:
            if DEBUG:
                print(
                    f"[SESSION] Rejet paquet: count attendu={self.expected_rx_count}, recu={count}"
                )
            return None

        self.expected_rx_count += 1
        return plain_data
    
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

    def is_key_valid(self):
        """
        Vérifie si la clé de session est toujours valide.
        
        Returns:
            True si la clé n'a pas expiré, False sinon
        """
        if self.kc_expires_at is None:
            return False
        return time.time() <= self.kc_expires_at
