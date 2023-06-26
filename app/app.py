from flask import Flask, jsonify, request
import uuid

app = Flask(__name__)

# Sample data - messages
messages = [
    {
        'account_id': '1',
        'message_id': str(uuid.uuid4()),
        'sender_number': '<SENDER_PHONE_NUMBER>',
        'receiver_number': '<RECEIVER_PHONE_NUMBER>'
    },
    {
        'account_id': '2',
        'message_id': str(uuid.uuid4()),
        'sender_number': '<SENDER_PHONE_NUMBER>',
        'receiver_number': '<RECEIVER_PHONE_NUMBER>'
    }
]
@app.route('/get/messages/account_id', methods=['GET'])
def get_messages():
    return jsonify(messages)

@app.route('/messages/<string:message_id>', methods=['GET'])
def get_message(message_id):
    message = next((message for message in messages if message['message_id'] == message_id), None)
    if message:
        return jsonify(message)
    else:
        return jsonify({'error': 'Message not found'}), 404

# Route for creating a new message
@app.route('/create', methods=['POST'])
def create_message():
    new_message = {
        'account_id': request.json['account_id'],
        'message_id': str(uuid.uuid4()),
        'sender_number': request.json['sender_number'],
        'receiver_number': request.json['receiver_number']
    }
    messages.append(new_message)
    return jsonify(new_message), 201

# Route for deleting a message by message_id
@app.route('/messages/<string:message_id>', methods=['DELETE'])
def delete_message(message_id):
    global messages
    messages = [message for message in messages if message['message_id'] != message_id]
    return jsonify({'message': 'Message deleted'})

# Main entry point
if __name__ == '__main__':
    app.run()
