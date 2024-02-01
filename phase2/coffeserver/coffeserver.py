from flask import Flask, request
from flask_gssapi import GSSAPI

app = Flask(__name__)
gssapi = GSSAPI(app)

@app.route('/coffee', methods=['GET'])
@gssapi
def coffee():
    user = request.environ.get('REMOTE_USER')
    return f"Welcome to the coffee shop, {user}!"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8082, debug=True)
