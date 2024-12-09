import requests
from concurrent.futures import ThreadPoolExecutor, as_completed

BASE_URL = 'https://sportsdataanalytics.onrender.com'

def fetch_url(url):
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
