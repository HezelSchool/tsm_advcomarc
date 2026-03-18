"""
Configuration globale pour l'authentification GSM/LTE
Contient les paramètres partagés entre client et serveur
"""

import os

# Paramètres de connexion
HOST = "127.0.0.1"
PORT = 5000

# Clé secrète Ki (stockée dans USIM et AuC)
# En production, cette clé devrait être stockée de manière sécurisée
Ki = b"SuperSecretKey123"

# Durée de vie de la clé de session (20 minutes)
KEY_VALIDITY_SECONDS = 20 * 60

# Répertoire local pour les fichiers échangés
BASE_DIR = os.path.dirname(__file__)
FILES_DIR = os.path.join(BASE_DIR, "files")

# Fichier envoyé par le client vers le serveur
CLIENT_INPUT_FILE = os.path.join(FILES_DIR, "client_payload.txt")

# Fichier sauvegardé côté serveur (reçu du client)
SERVER_RECEIVED_FILE = os.path.join(FILES_DIR, "server_received_from_client.txt")

# Fichier envoyé par le serveur vers le client
SERVER_REPLY_FILE = os.path.join(FILES_DIR, "server_reply.txt")

# Fichier sauvegardé côté client (reçu du serveur)
CLIENT_RECEIVED_FILE = os.path.join(FILES_DIR, "client_received_from_server.txt")

# Paramètres de debug
DEBUG = True
