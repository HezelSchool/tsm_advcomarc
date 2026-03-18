import os
import hashlib

# --- RAND ---
def generate_rand():
    return os.urandom(16)  # 128 bits

# --- A3 (Simulation SRES) ---
def compute_sres(rand, ki):
    data = ki + rand
    hash_value = hashlib.sha256(data).digest()
    return hash_value[:8]  # 64 bits

# --- A8 (Simulation Kc) ---
def generate_kc(rand, ki):
    data = rand + ki
    hash_value = hashlib.sha256(data).digest()
    return hash_value[:16]  # 128-bit session key

# --- A5 Encryption/Decryption ---
def generate_keystream(kc, length):
    """
    Génère un flot pseudo-aléatoire à partir de Kc
    """
    keystream = b""
    counter = 0

    while len(keystream) < length:
        block = hashlib.sha256(kc + counter.to_bytes(4, 'big')).digest()
        keystream += block
        counter += 1

    return keystream[:length]


def a5_cipher(data, kc):
    """
    Chiffrement / déchiffrement (symétrique)
    """
    ks = generate_keystream(kc, len(data))
    return bytes([d ^ k for d, k in zip(data, ks)])