from utils import BASE_URL, fetch_url
from home import cache_home_endpoints
from drivers import get_driver_ids, cache_driver_year_endpoints, cache_driver_race_endpoints
from teams import get_team_ids, cache_team_year_endpoints, cache_team_endpoints
from races import cache_race_year_endpoints, cache_race_round_endpoints

def get_rounds_in_year(year):
    races_url = f"{BASE_URL}/races/{year}/"
    response = fetch_url(races_url)
    
    if response and response.status_code == 200:
        race_data = response.json()
        rounds = [int(race['race_id']) for race in race_data]
        return sorted(rounds, reverse=True)
    else:
        print(f"Failed to fetch rounds for year {year}, defaulting to 1 round.")
        return [1]  # Default to 1 round if fetch fails

def main():
    years = range(1950, 2023)

    # Fetch home endpoints once (not year-specific)
    cache_home_endpoints()

    for year in years:
        print(f'\nProcessing data for year: {year}')

        # Get drivers and teams for the year
        driver_ids = get_driver_ids(year)
        team_ids = get_team_ids(year)

        # Dynamically fetch race rounds for the year
        rounds_in_year = get_rounds_in_year(year)
        print(f'Race rounds for {year}: {rounds_in_year}')

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
