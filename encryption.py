from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from base64 import b64encode, b64decode

def encrypt(data, key):
    cipher = Cipher(algorithms.AES(key), modes.CFB, backend=default_backend())
    encryptor = cipher.encryptor()
    ciphertext = encryptor.update(data) + encryptor.finalize()
    return b64encode(ciphertext).decode('utf-8')

def decrypt(encrypted_data, key):
    cipher = Cipher(algorithms.AES(key), modes.CFB, backend=default_backend())
    decryptor = cipher.decryptor()
    ciphertext = b64decode(encrypted_data.encode('utf-8'))
    return decryptor.update(ciphertext) + decryptor.finalize()
