import requests
from concurrent.futures import ThreadPoolExecutor, as_completed

# Replace with your Flask app's base URL
BASE_URL = 'https://sportsdataanalytics.onrender.com'

def fetch_url(url):
    """Helper function to fetch a URL and handle errors."""
    try:
        response = requests.get(url)
        if response.status_code == 200:
            print(f"GET {url} - Cached successfully")
        else:
            print(f"GET {url} - Failed with status code: {response.status_code}")
        return response
    except requests.exceptions.RequestException as e:
        print(f"Error fetching {url}: {e}")
        return None

def fetch_all(urls, max_workers=4):
    """
    Helper function to fetch multiple URLs concurrently.
    
    Args:
        urls (list): List of URLs to fetch.
        max_workers (int): Maximum number of threads to use.
        
    Returns:
        dict: Mapping of URL to its response.
    """
    responses = {}
    with ThreadPoolExecutor(max_workers=max_workers) as executor:
        future_to_url = {executor.submit(fetch_url, url): url for url in urls}
        for future in as_completed(future_to_url):
            url = future_to_url[future]
            try:
                response = future.result()
                responses[url] = response
            except Exception as e:
                print(f"Exception fetching {url}: {e}")
                responses[url] = None
    return responses

def main():
    # Define the year to cache
    year = 2024

    # Hit endpoints without parameters concurrently
    endpoints = [
        '/home/upcoming_race/',
        '/home/last_race_results/',
    ]
    urls = [BASE_URL + endpoint for endpoint in endpoints]
    print("Fetching general endpoints concurrently...")
    fetch_all(urls)

    print(f'\nProcessing data for year: {year}')

    # Fetch list of drivers
    drivers_url = f'{BASE_URL}/drivers/{year}/'
    drivers_response = fetch_url(drivers_url)
    driver_ids = [driver['driver_id'] for driver in drivers_response.json()] if drivers_response and drivers_response.status_code == 200 else []
    print(f'Fetched {len(driver_ids)} drivers.')

    # Fetch list of teams
    teams_url = f'{BASE_URL}/teams/{year}/'
    teams_response = fetch_url(teams_url)
    team_ids = [team['team_id'] for team in teams_response.json()] if teams_response and teams_response.status_code == 200 else []
    print(f'Fetched {len(team_ids)} teams.')

    # Start with round [hardcode this value] and work backward to round 1
    rounds_in_year = list(range(19, 0, -1))
    print(f'Hardcoded race rounds: {rounds_in_year}')

    # Hit endpoints that require only the year concurrently
    year_endpoints = [
        f'/constructors/{year}/standings/',
        f'/drivers/{year}/standings/',
        f'/drivers/{year}/',
        f'/races/{year}/',
    ]
    year_urls = [BASE_URL + endpoint for endpoint in year_endpoints]
    print("Fetching year-specific endpoints concurrently...")
    fetch_all(year_urls)

    # Process each race in reverse order
    for race_round in rounds_in_year:
        print(f'\nProcessing race round: {race_round}')
        # Endpoints requiring year and round
        race_endpoints = [
            f'/race/{year}/{race_round}/',
            f'/race/{year}/{race_round}/positions/',
            f'/race/{year}/{race_round}/results/',
            f'/race/{year}/{race_round}/pitstops/',
        ]
        race_urls = [BASE_URL + endpoint for endpoint in race_endpoints]
        print(f"Fetching race round {race_round} endpoints concurrently...")
        fetch_all(race_urls)

        # Prepare driver endpoints for this race
        driver_endpoints = []
        for driver_id in driver_ids:
            driver_endpoints.extend([
                f'/race/{year}/{race_round}/driver/{driver_id}/lap_data/',
                f'/race/{year}/{race_round}/driver/{driver_id}/laps/',
                f'/driver/{driver_id}/{year}/stats/',
                f'/driver/{driver_id}/{year}/races/',
            ])
        driver_urls = [BASE_URL + endpoint for endpoint in driver_endpoints]
        print(f"Fetching driver endpoints for race round {race_round} concurrently...")
        fetch_all(driver_urls)

    # Process each team concurrently
    team_endpoints = [f'/team/{team_id}/{year}/stats/' for team_id in team_ids]
    team_urls = [BASE_URL + endpoint for endpoint in team_endpoints]
    print("Fetching team endpoints concurrently...")
    fetch_all(team_urls)

if __name__ == '__main__':
    main()
