from flask import Flask
from flask_cors import CORS
from app.cache import cache

app = Flask(__name__)

# Enable CORS for the entire app
CORS(app)

# Set up cache configuration
app.config['CACHE_TYPE'] = 'SimpleCache'
app.config['CACHE_DEFAULT_TIMEOUT'] = 300
cache.init_app(app)

# Blueprint
from app.views import api_blueprint
app.register_blueprint(api_blueprint)

if __name__ == '__main__':
    app.run(debug=True)
