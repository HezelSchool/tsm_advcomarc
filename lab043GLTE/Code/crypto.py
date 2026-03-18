"""
Module de fonctions cryptographiques pour l'authentification GSM/LTE
Contient les fonctions de génération et de calcul utilisées par le client et le serveur
"""

import os
import hashlib
import hmac
import struct
from config import DEBUG


TAG_SIZE = 16
NONCE_SIZE = 8


def generate_rand():
    """
    Génère un nombre aléatoire RAND de 16 octets
    Utilisé par le serveur pour le challenge d'authentification
    """
    rand = os.urandom(16)
    if DEBUG:
        print(f"[CRYPTO] RAND généré: {rand.hex()}")
    return rand


def compute_sres(rand, ki):
    """
    Calcule la réponse signée SRES à partir de RAND et Ki
    SRES = premiers 4 octets de SHA256(RAND || Ki)
    
    Args:
        rand: Le challenge RAND (16 octets)
        ki: La clé secrète Ki
    
    Returns:
        SRES (4 octets)
    """
    sres = hashlib.sha256(rand + ki).digest()[:4]
    if DEBUG:
        print(f"[CRYPTO] SRES calculé: {sres.hex()}")
    return sres


def derive_kc(rand, ki):
    """
    Dérive la clé de session Kc à partir de RAND et Ki
    Kc = SHA256(Ki || RAND)
    
    Args:
        rand: Le challenge RAND (16 octets)
        ki: La clé secrète Ki
    
    Returns:
        Kc (32 octets)
    """
    kc = hashlib.sha256(ki + rand).digest()
    if DEBUG:
        print(f"[CRYPTO] Clé de session Kc dérivée: {kc.hex()}")
    return kc


def derive_keystream_keys(kc):
    """
    Dérive des sous-clés dédiées chiffrement et intégrité.

    Args:
        kc: Clé de session principale

    Returns:
        Tuple (k_enc, k_mac)
    """
    k_enc = hmac.new(kc, b"ENC", hashlib.sha256).digest()
    k_mac = hmac.new(kc, b"MAC", hashlib.sha256).digest()
    if DEBUG:
        print("[CRYPTO] Sous-cles derivees (ENC/MAC)")
    return k_enc, k_mac


def _build_keystream(k_enc, nonce, count, direction, length):
    """
    Génère un flot pseudo-aléatoire avec HMAC-SHA256 en mode compteur.
    
    Args:
        k_enc: Clé de chiffrement dérivée
        nonce: Nonce aléatoire de 8 octets
        count: Compteur de trame
        direction: 0 (uplink/client->serveur) ou 1 (downlink/serveur->client)
        length: Longueur souhaitée du flot en octets
    
    Returns:
        Flot de pseudo-aléa de la longueur spécifiée
    """
    if direction not in (0, 1):
        raise ValueError("direction doit valoir 0 (UL) ou 1 (DL)")

    stream = bytearray()
    block_index = 0
    while len(stream) < length:
        material = nonce + struct.pack("!Q", count) + bytes([direction]) + struct.pack("!I", block_index)
        block = hmac.new(k_enc, material, hashlib.sha256).digest()
        stream.extend(block)
        block_index += 1
    return bytes(stream[:length])


def _xor_bytes(data, key_stream):
    """
    Effectue un XOR octet par octet entre les données et le flot.
    
    Args:
        data: Données à transformer
        key_stream: Flot pseudo-aléatoire
    
    Returns:
        Résultat du XOR
    """
    return bytes([d ^ k for d, k in zip(data, key_stream)])


def encrypt_packet(plain_data, k_enc, k_mac, count, direction):
    """
    Chiffre et authentifie un paquet de données.
    
    Format: NONCE(8) || COUNT(8) || CIPHERTEXT || TAG(16)
    
    Args:
        plain_data: Données à chiffrer
        k_enc: Clé de chiffrement
        k_mac: Clé d'authentification MAC
        count: Compteur de trame
        direction: 0 (uplink) ou 1 (downlink)
    
    Returns:
        Paquet chiffré avec tag d'intégrité
    """
    nonce = os.urandom(NONCE_SIZE)
    key_stream = _build_keystream(k_enc, nonce, count, direction, len(plain_data))
    cipher_data = _xor_bytes(plain_data, key_stream)

    mac_input = bytes([direction]) + struct.pack("!Q", count) + nonce + cipher_data
    tag = hmac.new(k_mac, mac_input, hashlib.sha256).digest()[:TAG_SIZE]

    packet = nonce + struct.pack("!Q", count) + cipher_data + tag
    if DEBUG:
        print(f"[CRYPTO] Paquet chiffre: nonce={nonce.hex()} count={count} taille={len(packet)}")
    return packet


def decrypt_packet(packet, k_enc, k_mac, direction):
    """
    Vérifie l'intégrité et déchiffre un paquet.
    
    Args:
        packet: Paquet chiffré au format NONCE || COUNT || CIPHERTEXT || TAG
        k_enc: Clé de chiffrement
        k_mac: Clé d'authentification MAC
        direction: 0 (uplink) ou 1 (downlink)
    
    Returns:
        Tuple (count, plain_data) - compteur et données déchiffrées
    """
    min_size = NONCE_SIZE + 8 + TAG_SIZE
    if len(packet) < min_size:
        raise ValueError("Paquet trop court")

    nonce = packet[:NONCE_SIZE]
    count = struct.unpack("!Q", packet[NONCE_SIZE:NONCE_SIZE + 8])[0]
    tag = packet[-TAG_SIZE:]
    cipher_data = packet[NONCE_SIZE + 8:-TAG_SIZE]

    mac_input = bytes([direction]) + struct.pack("!Q", count) + nonce + cipher_data
    expected_tag = hmac.new(k_mac, mac_input, hashlib.sha256).digest()[:TAG_SIZE]
    if not hmac.compare_digest(tag, expected_tag):
        raise ValueError("Tag d'integrite invalide")

    key_stream = _build_keystream(k_enc, nonce, count, direction, len(cipher_data))
    plain_data = _xor_bytes(cipher_data, key_stream)

    if DEBUG:
        print(f"[CRYPTO] Paquet dechiffre: nonce={nonce.hex()} count={count} taille={len(plain_data)}")
    return count, plain_data


def compute_auth_token(rand, ki):
    """
    Calcule le token d'authentification du serveur
    Token = SHA256(RAND || Ki)
    
    Args:
        rand: Le challenge RAND
        ki: La clé secrète Ki
    
    Returns:
        Token d'authentification (32 octets)
    """
    token = hmac.new(ki, rand + b"AUTN", hashlib.sha256).digest()
    if DEBUG:
        print(f"[CRYPTO] Token d'authentification calculé: {token.hex()}")
    return token
