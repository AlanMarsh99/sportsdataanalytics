"""Description: This file defines the URL patterns for the f1app application.
It maps URL paths to the corresponding view functions or classes."""

from django.urls import path
from . import views

urlpatterns = [
    # Driver
    path('driver/', views.DriverList.as_view(), name='driver-list'),
    path('driver/<int:driverid>/', views.DriverDetail.as_view(), name='driver-detail'),
    path('driver/<int:driverid>/results/', views.DriverResultsList.as_view(), name='driver-results'),

    # Constructor
    path('constructor/', views.ConstructorList.as_view(), name='constructor-list'),
    path('constructor/<int:constructorid>/', views.ConstructorDetail.as_view(), name='constructor-detail'),

    # Circuit
    path('circuit/', views.CircuitList.as_view(), name='circuit-list'),
    path('circuit/<int:circuitid>/', views.CircuitDetail.as_view(), name='circuit-detail'),

    # Race
    path('race/', views.RaceList.as_view(), name='race-list'),
    path('race/<int:raceid>/', views.RaceDetail.as_view(), name='race-detail'),
    path('race/<int:raceid>/results/', views.RaceResultsList.as_view(), name='race-results'),
]
