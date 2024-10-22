"""Description: This file defines the URL patterns for the Django project.
It includes the admin site URLs and the URLs from the f1app application, and defines a simple home view."""

from django.contrib import admin
from django.urls import path, include
from django.http import HttpResponse

def home_view(request):
    return HttpResponse("Welcome to the F1 API. Access endpoints at /api/v1/")

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/v1/', include('f1app.urls')),
    path('', home_view, name='home'),
]