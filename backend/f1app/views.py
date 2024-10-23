"""Description: This file contains the view classes for the API endpoints,
utilizing Django REST Framework's generic views to handle HTTP requests and responses for each model."""

from django.shortcuts import render
from rest_framework import generics
from .models import Driver, Constructor, Circuit, Race
from .serializers import DriverSerializer, ConstructorSerializer, CircuitSerializer, RaceSerializer

# Driver
class DriverList(generics.ListAPIView):
    queryset = Driver.objects.all()
    serializer_class = DriverSerializer
    filterset_fields = ['nationality']
    search_fields = ['forename', 'surname']

class DriverDetail(generics.RetrieveAPIView):
    queryset = Driver.objects.all()
    serializer_class = DriverSerializer
    lookup_field = 'driverid'

# Constructor
class ConstructorList(generics.ListAPIView):
    queryset = Constructor.objects.all()
    serializer_class = ConstructorSerializer

class ConstructorDetail(generics.RetrieveAPIView):
    queryset = Constructor.objects.all()
    serializer_class = ConstructorSerializer
    lookup_field = 'constructorid'

# Circuit
class CircuitList(generics.ListAPIView):
    queryset = Circuit.objects.all()
    serializer_class = CircuitSerializer

class CircuitDetail(generics.RetrieveAPIView):
    queryset = Circuit.objects.all()
    serializer_class = CircuitSerializer
    lookup_field = 'circuitid'

# Race
class RaceList(generics.ListAPIView):
    queryset = Race.objects.all()
    serializer_class = RaceSerializer
    filterset_fields = ['year']
    search_fields = ['name']

class RaceDetail(generics.RetrieveAPIView):
    queryset = Race.objects.all()
    serializer_class = RaceSerializer
    lookup_field = 'raceid'
