from utils import BASE_URL, fetch_all

def cache_home_endpoints():
    endpoints = [
        '/home/upcoming_race/',
        '/home/last_race_results/'
    ]
    urls = [BASE_URL + endpoint for endpoint in endpoints]
    print("Fetching home endpoints concurrently...")
    fetch_all(urls)
