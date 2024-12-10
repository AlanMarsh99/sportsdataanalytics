from utils import BASE_URL, fetch_all

def cache_race_year_endpoints(year):
    year_endpoints = [
        f'/races/{year}/',
    ]
    year_urls = [BASE_URL + endpoint for endpoint in year_endpoints]
    print("Fetching race year-specific endpoints concurrently...")
    fetch_all(year_urls)

def cache_race_round_endpoints(year, race_round):
    race_endpoints = [
        f'/race/{year}/{race_round}/',
        f'/race/{year}/{race_round}/positions/',
        f'/race/{year}/{race_round}/results/',
        f'/race/{year}/{race_round}/pitstops/',
    ]
    race_urls = [BASE_URL + endpoint for endpoint in race_endpoints]
    print(f"Fetching race round {race_round} endpoints concurrently...")
    fetch_all(race_urls)
