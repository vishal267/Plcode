from flask import Flask, jsonify, request
import os
import psycopg2
import uuid

app = Flask(__name__)

def get_db_connection():
    connection = psycopg2.connect(host='localhost',
                            database='flask_db',
                            user=os.environ['DB_USERNAME'],
                            password=os.environ['DB_PASSWORD'])
    return connection


# Route for creating a new message
@app.route('/create', methods=['POST'])
def create_message():
    try:
        # Get message data from the request body
        message_data = request.get_json()
                
        # Create a cursor to execute SQL queries
        get_db_connection()
        cursor = connection.cursor()
        
        # Insert the message into the database
        query = """
            INSERT INTO messages (account_id, message_id, sender_number, receiver_number)
            VALUES (%s, %s, %s, %s)
        """
        cursor.execute(query, (
            message_data['account_id'],
            message_data['message_id'],
            message_data['sender_number'],
            message_data['receiver_number']
        ))
        
        # Commit the changes and close the connection
        connection.commit()
        connection.close()
        
        return jsonify({'message': 'Message created successfully'})
    except Exception as e:
        return jsonify({'error': str(e)}), 500


# Route for retrieving messages by account id 
@app.route('/get/messages/<account_id>')
def get_messages(account_id):
    try:
        # Create a cursor to execute SQL queries
        cursor = connection.cursor()
        
        # Retrieve messages for the given account ID
        query = """
            SELECT * FROM messages WHERE account_id = %s
        """
        cursor.execute(query, (account_id,))
        
        # Fetch all rows and build the messages list
        messages = []
        rows = cursor.fetchall()
        for row in rows:
            message = {
                'account_id': row[0],
                'message_id': row[1],
                'sender_number': row[2],
                'receiver_number': row[3]
            }
            messages.append(message)
        
        # Close the connection
        connection.close()
        
        return jsonify(messages)
    except Exception as e:
        return jsonify({'error': str(e)}), 500


#Route with search cabapilities
@app.route('/search')
def search_messages():
    try:
        message_ids = request.args.get('message_id', '').split(',')

        # Create a cursor to execute SQL queries
        cursor = connection.cursor()

        # Retrieve messages with the given message IDs
        query = """
            SELECT * FROM messages WHERE message_id IN %s
        """
        cursor.execute(query, (tuple(message_ids),))

        # Fetch all rows and build the messages list
        messages = []
        rows = cursor.fetchall()
        for row in rows:
            message = {
                'account_id': row[0],
                'message_id': row[1],
                'sender_number': row[2],
                'receiver_number': row[3]
            }
            messages.append(message)

        # Close the connection
        connection.close()

        return jsonify(messages)
    except Exception as e:
        return jsonify({'error': str(e)}), 500


# Main entry point
if __name__ == '__main__':
    app.run()
