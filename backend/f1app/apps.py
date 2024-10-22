"""Description: This file defines the configuration for the f1app Django application. It specifies the app's name and default settings."""

from django.apps import AppConfig


class F1AppConfig(AppConfig):
    default_auto_field = "django.db.models.BigAutoField"
    name = "f1app"
