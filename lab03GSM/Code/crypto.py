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

# --- XOR Encryption/Decryption ---
def xor_cipher(data, key):
    return bytes([data[i] ^ key[i % len(key)] for i in range(len(data))])