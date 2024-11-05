from flask import Flask
from flask_cors import CORS

app = Flask(__name__)

# Enable CORS for the entire app
CORS(app)

# Import blueprint
from app.views import api_blueprint

# Register blueprint
app.register_blueprint(api_blueprint)

if __name__ == '__main__':
    app.run(debug=True)
