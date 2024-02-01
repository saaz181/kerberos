from flask import Flask, request
from flask_gssapi import GSSAPI

app = Flask(__name__)
gssapi = GSSAPI(app)

@app.route('/swim', methods=['GET'])
@gssapi
def swim():
    user = request.environ.get('REMOTE_USER')
    return f"Welcome to the swim area, {user}!"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8081, debug=True)
