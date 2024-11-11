from flask import Flask
from flask_cors import CORS
from app.cache import cache
from redis import SSLConnection

app = Flask(__name__)

# Enable CORS for the entire app
CORS(app)

# Set up cache configuration for Redis using Upstash
app.config['CACHE_TYPE'] = 'RedisCache'
app.config['CACHE_DEFAULT_TIMEOUT'] = 300

# Hardcode the Upstash Redis URL for now

app.config['CACHE_REDIS_URL'] = 'rediss://:AWMkAAIjcDFhNDk4NTcwMjI4NTg0ZTNmYjZjMjBiNzdhODIzNmNmMXAxMA@careful-gobbler-25380.upstash.io:6379'

# Ensure SSL/TLS is used for the Redis connection
app.config['CACHE_OPTIONS'] = {
    'connection_class': SSLConnection,  # Use SSLConnection for secure connection
}

# Initialize the cache with the app
cache.init_app(app)

# Blueprint
from app.views import api_blueprint
app.register_blueprint(api_blueprint)

if __name__ == '__main__':
    app.run(debug=True)
