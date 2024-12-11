from utils import BASE_URL, fetch_url, fetch_all

def get_driver_ids(year):
    drivers_url = f'{BASE_URL}/drivers/{year}/'
    drivers_response = fetch_url(drivers_url)
    driver_ids = [driver['driver_id'] for driver in drivers_response.json()] if (drivers_response and drivers_response.status_code == 200) else []
    print(f'Fetched {len(driver_ids)} drivers.')
    return driver_ids

def cache_driver_year_endpoints(year):
    year_endpoints = [
        f'/drivers/{year}/standings/',
        f'/drivers/{year}/',
    ]
    year_urls = [BASE_URL + endpoint for endpoint in year_endpoints]
    print("Fetching driver year-specific endpoints concurrently...")
    fetch_all(year_urls)

def cache_driver_race_endpoints(year, race_round, driver_ids):
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
