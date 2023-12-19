from flask import Flask, request, jsonify
import psycopg2
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from base64 import b64encode, b64decode
import os
import json

app = Flask(__name__)

db_config = {
    'dbname': 'db',
    'user': 'postgres',
    'password': 'test',
    'host': 'localhost',
    'port': '5432'
}

encryption_key = b'Sixteen byte key'

def encrypt(data):
    nonce = os.urandom(16)
    cipher = Cipher(algorithms.AES(encryption_key), modes.GCM(nonce), backend=default_backend())
    encryptor = cipher.encryptor()
    ciphertext = encryptor.update(json.dumps(data).encode('utf-8')) + encryptor.finalize()
    return {
        'nonce': b64encode(nonce).decode('utf-8'),
        'ciphertext': b64encode(ciphertext).decode('utf-8')
    }


def decrypt(encrypted_data):
    try:
        nonce = b64decode(encrypted_data['nonce'].encode('utf-8'))
        ciphertext = b64decode(encrypted_data['ciphertext'].encode('utf-8'))
        cipher = Cipher(algorithms.AES(encryption_key), modes.GCM(nonce), backend=default_backend())
        decryptor = cipher.decryptor()
        decrypted_data = decryptor.update(ciphertext) + decryptor.finalize()
        return decrypted_data.decode('utf-8')
    except Exception as e:
        return {
            'error': str(e),
            'raw_data': encrypted_data['ciphertext']
        }




def get_db_connection():
    connection = psycopg2.connect(**db_config)
    return connection


@app.route('/api/data', methods=['GET', 'POST', 'PUT', 'DELETE'])
def handle_data():
    connection = get_db_connection()

    if connection is None:
        return jsonify({'error': 'Failed to connect to the database'})

    cursor = connection.cursor()

    try:
        if request.method == 'GET':
            cursor.execute("SELECT id, username, password, email, encrypted_data FROM public.users;")
            result = cursor.fetchall()

            data_list = []
            for row in result:
                data = {
                    'id': row[0],
                    'username': row[1],
                    'password': row[2],
                    'email': row[3],
                }

                encrypted_data_str = row[4]

                if encrypted_data_str:
                    try:
                        data['encrypted_data'] = decrypt(json.loads(encrypted_data_str))
                    except json.JSONDecodeError as e:
                        data['encrypted_data'] = {
                            'raw_data': encrypted_data_str
                        }
                else:
                    data['encrypted_data'] = None

                data_list.append(data)

            return jsonify(data_list)

        elif request.method == 'POST':
            new_data = request.json
            username = new_data['username']
            password = new_data['password']
            email = new_data['email']
            encrypted_data = encrypt(new_data['encrypted_data'])

            cursor.execute(
                "INSERT INTO public.users (username, password, email, encrypted_data) VALUES (%s, %s, %s, %s) RETURNING id;",
                (username, password, email, encrypted_data['ciphertext'])  
            )

            new_id = cursor.fetchone()[0]
            connection.commit()

            return jsonify({
                'id': new_id,
                'username': username,
                'password': password,
                'email': email,
                'encrypted_data': encrypted_data
            })

        elif request.method == 'PUT':
            data_id = request.json['id']
            updated_data = request.json['data']
            encrypted_data = encrypt(updated_data['encrypted_data'])

            cursor.execute("UPDATE public.users SET encrypted_data = %s WHERE id = %s;", (encrypted_data['ciphertext'], data_id))
            connection.commit()

            return jsonify({'message': 'Data updated successfully'})

        elif request.method == 'DELETE':
            data_id = request.json['id']

            cursor.execute("DELETE FROM public.users WHERE id = %s;", (data_id,))
            connection.commit()

            return jsonify({'message': 'Data deleted successfully'})

    except Exception as e:
        return jsonify({'error': str(e)})

    finally:
        cursor.close()
        connection.close()

if __name__ == '__main__':
    app.run(debug=True)
