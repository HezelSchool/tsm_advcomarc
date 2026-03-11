"""
Configuration globale pour l'authentification GSM/LTE
Contient les paramètres partagés entre client et serveur
"""

# Paramètres de connexion
HOST = "127.0.0.1"
PORT = 5000

# Clé secrète Ki (stockée dans USIM et AuC)
# En production, cette clé devrait être stockée de manière sécurisée
Ki = b"SuperSecretKey123"

# Paramètres de debug
DEBUG = True
