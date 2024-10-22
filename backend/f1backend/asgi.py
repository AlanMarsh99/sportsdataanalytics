"""Description: This file sets up the ASGI application used for asynchronous deployments.
It exposes the ASGI callable as a module-level variable named application."""

import os

from django.core.asgi import get_asgi_application

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "f1backend.settings")

application = get_asgi_application()
