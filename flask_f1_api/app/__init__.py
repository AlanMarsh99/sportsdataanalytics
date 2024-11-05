from flask import Flask
from .views import api_blueprint

def create_app():
    app = Flask(__name__)
    
    # Register the API blueprint
    app.register_blueprint(api_blueprint)
    
    return app
