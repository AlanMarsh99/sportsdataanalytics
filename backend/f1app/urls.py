"""Description: This file defines the URL patterns for the f1app application.
It maps URL paths to the corresponding view functions or classes."""

from django.urls import path
from . import views
from .views import RaceListView, RaceDetailView, ConstructorDetailView

urlpatterns = [
    # Drivers endpoints
    path('drivers/<int:year>/', views.drivers_by_season, name='drivers-by-season'), # works
    path('driver/<str:driver_id>/season_stats/', views.driver_season_stats, name='driver-season-stats'), # almost works(missing data)
    path('driver/<str:driver_id>/races/<int:year>/', views.driver_races_in_year, name='driver-races-in-year'), # almost works

    # Races endpoints
    path('races/', RaceListView.as_view(), name='race-list'), # works
    path('race/<int:id>/', RaceDetailView.as_view(), name='race-detail'), # works
    path('race/<int:id>/results/', views.race_results, name='race-results'), # doesn't return anything

    # Constructors endpoints
    path('constructors/<int:year>/', views.constructors_by_year, name='constructors-by-year'), # works
    path('constructor/<str:id>/', ConstructorDetailView.as_view(), name='constructor-detail'), # works
    path('constructor/<str:id>/stats/', views.constructor_stats, name='constructor-stats'), # works except current season stats
    path('constructor/<str:id>/season_results/', views.constructor_season_results, name='constructor-season-results'), # works but missing some data
]
