from utils import BASE_URL
from home import cache_home_endpoints
from drivers import get_driver_ids, cache_driver_year_endpoints, cache_driver_race_endpoints
from teams import get_team_ids, cache_team_year_endpoints, cache_team_endpoints
from races import cache_race_year_endpoints, cache_race_round_endpoints

def main():
    # Define the year to cache
    year = 2024

    # Fetch home endpoints
    cache_home_endpoints()

    print(f'\nProcessing data for year: {year}')

    # Get drivers and teams
    driver_ids = get_driver_ids(year)
    team_ids = get_team_ids(year)

    # Hardcoded race rounds
    rounds_in_year = list(range(24, 0, -1))
    print(f'Hardcoded race rounds: {rounds_in_year}')

    # Fetch year-level endpoints
    cache_driver_year_endpoints(year)
    cache_team_year_endpoints(year)
    cache_race_year_endpoints(year)

    # Process each race in reverse order
    for race_round in rounds_in_year:
        print(f'\nProcessing race round: {race_round}')
        cache_race_round_endpoints(year, race_round)
        cache_driver_race_endpoints(year, race_round, driver_ids)

    # Fetch team endpoints
    cache_team_endpoints(year, team_ids)

if __name__ == '__main__':
    main()
