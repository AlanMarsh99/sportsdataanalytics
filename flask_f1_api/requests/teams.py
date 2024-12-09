from utils import BASE_URL, fetch_url, fetch_all

def get_team_ids(year):
    teams_url = f'{BASE_URL}/teams/{year}/'
    teams_response = fetch_url(teams_url)
    team_ids = [team['team_id'] for team in teams_response.json()] if (teams_response and teams_response.status_code == 200) else []
    print(f'Fetched {len(team_ids)} teams.')
    return team_ids

def cache_team_year_endpoints(year):
    # Constructors standings is related to teams.
    year_endpoints = [
        f'/constructors/{year}/standings/'
    ]
    year_urls = [BASE_URL + endpoint for endpoint in year_endpoints]
    print("Fetching team year-specific endpoints concurrently...")
    fetch_all(year_urls)

def cache_team_endpoints(year, team_ids):
    team_endpoints = [f'/team/{team_id}/{year}/stats/' for team_id in team_ids]
    team_urls = [BASE_URL + endpoint for endpoint in team_endpoints]
    print("Fetching team endpoints concurrently...")
    fetch_all(team_urls)
