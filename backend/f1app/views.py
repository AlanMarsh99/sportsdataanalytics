"""Description: This file contains the view classes for the API endpoints,
utilizing Django REST Framework's generic views to handle HTTP requests and responses for each model."""

from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import generics
from .models import (
    Driver,
    SeasonEntrantDriver,
    SeasonDriverStanding,
    RaceData,
    Race,
    Season,
    SeasonConstructorStanding,
    SeasonEntrantConstructor,
    Constructor,
)
from .serializers import (
    DriverSerializer,
    DriverSeasonStatsSerializer,
    DriverRaceEntrySerializer,
    RaceSerializer,
    RaceResultSerializer,
    ConstructorStatsSerializer,
    ConstructorDetailSerializer,
    ConstructorStatsDetailSerializer,
    ConstructorSeasonResultsSerializer,
)
from datetime import datetime

# View to retrieve drivers competing in a specific year
@api_view(['GET'])
def drivers_by_season(request, year):
    # Filter SeasonEntrantDriver by the specified year and retrieve driver IDs
    driver_ids = SeasonEntrantDriver.objects.filter(year_id=year).values_list('driver_id', flat=True)
    drivers = Driver.objects.filter(id__in=driver_ids)  # Query drivers based on IDs
    serializer = DriverSerializer(drivers, many=True)
    return Response(serializer.data)

# View to get driver statistics for each season competed
@api_view(['GET'])
def driver_season_stats(request, driver_id):
    season_standings = SeasonDriverStanding.objects.filter(driver_id=driver_id)
    data = []

    num_championship_entries = season_standings.count()
    num_championship_victories = season_standings.filter(position_number=1).count()

    for standing in season_standings:
        year = standing.year.year  # Since standing.year is a Season object
        position = standing.position_number
        points = standing.points

        # Corrected Queries using the updated RaceData model
        num_races = RaceData.objects.filter(
            race__year__year=year,
            driver_id=driver_id,
            type='Race'
        ).count()

        num_wins = RaceData.objects.filter(
            race__year__year=year,
            driver_id=driver_id,
            type='Race',
            position_number=1
        ).count()

        num_podiums = RaceData.objects.filter(
            race__year__year=year,
            driver_id=driver_id,
            type='Race',
            position_number__lte=3
        ).count()

        num_pole_positions = RaceData.objects.filter(
            race__year__year=year,
            driver_id=driver_id,
            type='Qualifying',
            position_number=1
        ).count()

        teams = SeasonEntrantDriver.objects.filter(
            year__year=year,
            driver_id=driver_id
        ).values_list('constructor__name', flat=True).distinct()
        team = ', '.join(teams)

        num_dnf = RaceData.objects.filter(
            race__year__year=year,
            driver_id=driver_id,
            type='Race',
            race_reason_retired__isnull=False
        ).count()

        num_dns = RaceData.objects.filter(
            race__year__year=year,
            driver_id=driver_id,
            type='Race',
            position_text='DNS'
        ).count()

        data.append({
            'year': year,
            'position': position,
            'points': points,
            'num_races': num_races,
            'num_wins': num_wins,
            'num_podiums': num_podiums,
            'num_pole_positions': num_pole_positions,
            'team': team,
            'num_championship_entries': num_championship_entries,
            'num_championship_victories': num_championship_victories,
            'num_dnf': num_dnf,
            'num_dns': num_dns,
        })

    serializer = DriverSeasonStatsSerializer(data, many=True)
    return Response(serializer.data)

# View to retrieve all races a driver competed in a specific year
@api_view(['GET'])
def driver_races_in_year(request, driver_id, year):
    races = Race.objects.filter(year_id=year)
    data = []

    for race in races:
        race_name = race.grand_prix.name

        # Qualifying position
        qualifying_entry = RaceData.objects.filter(
            race=race, driver_id=driver_id, type='Qualifying'
        ).first()
        qualifying_position = qualifying_entry.position_number if qualifying_entry else None

        # Grid position and result
        race_entry = RaceData.objects.filter(
            race=race, driver_id=driver_id, type='Race'
        ).first()
        if race_entry:
            grid_position = race_entry.race_grid_position_number
            result = race_entry.position_text
        else:
            grid_position = None
            result = 'Did Not Participate'

        data.append({
            'race_name': race_name,
            'qualifying_position': qualifying_position,
            'grid_position': grid_position,
            'result': result,
        })

    serializer = DriverRaceEntrySerializer(data, many=True)
    return Response(serializer.data)

# View to list races with optional filtering by year
class RaceListView(generics.ListAPIView):
    serializer_class = RaceSerializer

    def get_queryset(self):
        queryset = Race.objects.all()
        year = self.request.query_params.get('year', None)
        if year is not None:
            queryset = queryset.filter(year__year=year)
        return queryset

# View to retrieve details of a specific race
class RaceDetailView(generics.RetrieveAPIView):
    queryset = Race.objects.all()
    serializer_class = RaceSerializer
    lookup_field = 'id'

# View to retrieve race results
@api_view(['GET'])
def race_results(request, id):
    results = RaceData.objects.filter(
        race_id=id, type='Race'
    ).order_by('position_display_order')
    serializer = RaceResultSerializer(results, many=True)
    return Response(serializer.data)

# View to retrieve constructors competing in a specific year
@api_view(['GET'])
def constructors_by_year(request, year):
    constructor_ids = SeasonEntrantConstructor.objects.filter(
        year=year
    ).values_list('constructor_id', flat=True).distinct()
    constructors = Constructor.objects.filter(id__in=constructor_ids)
    data = []

    for constructor in constructors:
        num_wins = RaceData.objects.filter(
            race__year=year, constructor=constructor, type='Race', position_number=1
        ).count()

        num_podiums = RaceData.objects.filter(
            race__year=year, constructor=constructor, type='Race', position_number__lte=3
        ).count()

        drivers = SeasonEntrantDriver.objects.filter(
            year=year, constructor=constructor
        ).values_list('driver__full_name', flat=True).distinct()

        data.append({
            'constructor_name': constructor.name,
            'num_wins': num_wins,
            'num_podiums': num_podiums,
            'drivers': list(drivers),
        })

    serializer = ConstructorStatsSerializer(data, many=True)
    return Response(serializer.data)

# View to retrieve detailed information about a constructor
class ConstructorDetailView(generics.RetrieveAPIView):
    queryset = Constructor.objects.all()
    serializer_class = ConstructorDetailSerializer
    lookup_field = 'id'

# View to retrieve all-time and current season statistics of a constructor
from datetime import datetime

@api_view(['GET'])
def constructor_stats(request, id):
    constructor = Constructor.objects.get(id=id)
    current_year = datetime.now().year

    # All-time stats
    all_time_stats = {
        'num_races': constructor.total_race_entries,
        'wins': constructor.total_race_wins,
        'podiums': constructor.total_podiums,
        'championships': constructor.total_championship_wins,
        'pole_positions': constructor.total_pole_positions,
    }

    # Check if the current year exists in your Season model
    if Season.objects.filter(year=current_year).exists():
        # Current season stats
        current_season_races = RaceData.objects.filter(
            race__year_id=current_year, constructor=constructor, type='Race'
        )
        current_season_stats = {
            'num_races': current_season_races.count(),
            'wins': current_season_races.filter(position_number=1).count(),
            'podiums': current_season_races.filter(position_number__lte=3).count(),
            'championships': None,
            'pole_positions': RaceData.objects.filter(
                race__year_id=current_year, constructor=constructor, type='Qualifying', position_number=1
            ).count(),
        }
    else:
        current_season_stats = {
            'num_races': 0,
            'wins': 0,
            'podiums': 0,
            'championships': None,
            'pole_positions': 0,
        }

    data = {
        'constructor_name': constructor.name,
        'all_time_stats': all_time_stats,
        'current_season_stats': current_season_stats,
    }

    serializer = ConstructorStatsDetailSerializer(data)
    return Response(serializer.data)

# View to retrieve constructor's results in all seasons competed
@api_view(['GET'])
def constructor_season_results(request, id):
    season_standings = SeasonConstructorStanding.objects.filter(constructor_id=id)
    data = []

    for standing in season_standings:
        year = standing.year.year
        position = standing.position_number
        points = standing.points

        wins = RaceData.objects.filter(
            race__year_id=year, constructor_id=id, type='Race', position_number=1
        ).count()

        podiums = RaceData.objects.filter(
            race__year_id=year, constructor_id=id, type='Race', position_number__lte=3
        ).count()

        pole_positions = RaceData.objects.filter(
            race__year_id=year, constructor_id=id, type='Qualifying', position_number=1
        ).count()

        drivers = SeasonEntrantDriver.objects.filter(
            year_id=year, constructor_id=id
        ).values_list('driver__full_name', flat=True).distinct()

        data.append({
            'year': year,
            'position': position,
            'points': points,
            'wins': wins,
            'podiums': podiums,
            'pole_positions': pole_positions,
            'drivers': list(drivers),
        })

    serializer = ConstructorSeasonResultsSerializer(data, many=True)
    return Response(serializer.data)

