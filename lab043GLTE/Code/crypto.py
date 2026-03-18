"""
Module de fonctions cryptographiques pour l'authentification GSM/LTE
Contient les fonctions de génération et de calcul utilisées par le client et le serveur
"""

import os
import hashlib
from config import DEBUG


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


def xor_cipher(data, key):
    """
    Chiffrement/déchiffrement XOR avec clé
    
    Args:
        data: Données à chiffrer/déchiffrer
        key: Clé de chiffrement
    
    Returns:
        Données chiffrées/déchiffrées
    """
    result = bytes([data[i] ^ key[i % len(key)] for i in range(len(data))])
    if DEBUG:
        print(f"[CRYPTO] XOR cipher appliqué - Taille: {len(data)} octets")
    return result


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
    token = hashlib.sha256(rand + ki).digest()
    if DEBUG:
        print(f"[CRYPTO] Token d'authentification calculé: {token.hex()}")
    return token
