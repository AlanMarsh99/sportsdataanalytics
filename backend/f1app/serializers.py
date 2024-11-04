"""Description: This file defines the serializers for the Django REST Framework,
which convert model instances into JSON representations and vice versa for the specified models."""

from rest_framework import serializers
from .models import Driver, Race, RaceData, Constructor

# Serializer for Driver basic information
class DriverSerializer(serializers.ModelSerializer):
    class Meta:
        model = Driver
        fields = ['id', 'name', 'first_name', 'last_name', 'abbreviation', 'nationality_country']

# Serializer for Driver season statistics
class DriverSeasonStatsSerializer(serializers.Serializer):
    year = serializers.IntegerField()
    position = serializers.IntegerField()
    points = serializers.DecimalField(max_digits=8, decimal_places=2)
    num_races = serializers.IntegerField()
    num_wins = serializers.IntegerField()
    num_podiums = serializers.IntegerField()
    num_pole_positions = serializers.IntegerField()
    team = serializers.CharField()
    num_championship_entries = serializers.IntegerField()
    num_championship_victories = serializers.IntegerField()
    num_dnf = serializers.IntegerField()
    num_dns = serializers.IntegerField()

# Serializer for Driver race entries in a specific year
class DriverRaceEntrySerializer(serializers.Serializer):
    race_name = serializers.CharField()
    qualifying_position = serializers.IntegerField(allow_null=True)
    grid_position = serializers.IntegerField(allow_null=True)
    result = serializers.CharField()

# Serializer for Race information
class RaceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Race
        fields = ['id', 'year', 'round', 'date', 'grand_prix', 'official_name']

# Serializer for Race results
class RaceResultSerializer(serializers.ModelSerializer):
    driver_name = serializers.CharField(source='driver.full_name')
    constructor_name = serializers.CharField(source='constructor.name')

    class Meta:
        model = RaceData
        fields = [
            'position_number',
            'position_text',
            'driver_name',
            'constructor_name',
            'race_time',
            'race_gap',
            'race_points',
        ]

# Serializer for Constructor statistics in a year
class ConstructorStatsSerializer(serializers.Serializer):
    constructor_name = serializers.CharField()
    num_wins = serializers.IntegerField()
    num_podiums = serializers.IntegerField()
    drivers = serializers.ListField(child=serializers.CharField())

# Serializer for Constructor detailed information
class ConstructorDetailSerializer(serializers.ModelSerializer):
    class Meta:
        model = Constructor
        fields = '__all__'

# Serializer for Constructor all-time and current season statistics
class ConstructorStatsDetailSerializer(serializers.Serializer):
    constructor_name = serializers.CharField()
    all_time_stats = serializers.DictField()
    current_season_stats = serializers.DictField()

# Serializer for Constructor season results
class ConstructorSeasonResultsSerializer(serializers.Serializer):
    year = serializers.IntegerField()
    position = serializers.IntegerField()
    points = serializers.DecimalField(max_digits=8, decimal_places=2)
    wins = serializers.IntegerField()
    podiums = serializers.IntegerField()
    pole_positions = serializers.IntegerField()
    drivers = serializers.ListField(child=serializers.CharField())
