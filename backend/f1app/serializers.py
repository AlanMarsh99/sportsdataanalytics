"""Description: This file defines the serializers for the Django REST Framework,
which convert model instances into JSON representations and vice versa for the specified models."""

from rest_framework import serializers
from .models import Driver, Constructor, Circuit, Race

class DriverSerializer(serializers.ModelSerializer):
    class Meta:
        model = Driver
        fields = '__all__'

class ConstructorSerializer(serializers.ModelSerializer):
    class Meta:
        model = Constructor
        fields = '__all__'

class CircuitSerializer(serializers.ModelSerializer):
    class Meta:
        model = Circuit
        fields = '__all__'

class RaceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Race
        fields = '__all__'
