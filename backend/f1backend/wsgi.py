"""Description: This file sets up the WSGI application used for deploying the Django project.
It exposes the WSGI callable as a module-level variable named application."""

import os

from django.core.wsgi import get_wsgi_application

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "f1backend.settings")

application = get_wsgi_application()
