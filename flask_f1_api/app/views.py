from flask import Blueprint, jsonify, request
import requests
from datetime import datetime
from app.cache import cache

api_blueprint = Blueprint('api', __name__)

BASE_ERGAST_URL = "http://ergast.com/api/f1"

# HOME SCREEN VIEWS

# Get upcoming race information - WORKS
@api_blueprint.route('/home/upcoming_race/', methods=['GET'])
@cache.cached(timeout=0)
def get_upcoming_race():
    # Fetch the current season's schedule
    schedule_url = f"{BASE_ERGAST_URL}/current.json"
    response = requests.get(schedule_url)
    
    if response.status_code != 200:
        return jsonify({"error": "Failed to retrieve upcoming race info"}), response.status_code

    races = response.json()['MRData']['RaceTable']['Races']
    upcoming_race = None

    # Find the next race that hasn't happened yet
    for race in races:
        race_date = datetime.strptime(race['date'], "%Y-%m-%d")
        if race_date > datetime.now():
            upcoming_race = {
                "race_name": race['raceName'],
                "race_id": race['round'],
                "date": race['date'],
                "hour": race['time'][:5],  # Extract hour and minute from time
                "year": race['season'],   # Add year field
                "country": race['Circuit']['Location']['country'],
                "drivers": []             # Placeholder for drivers
            }
            break

    if not upcoming_race:
        return jsonify({"error": "No upcoming races found"}), 404

    # Fetch all drivers and their teams for the current season
    standings_url = f"{BASE_ERGAST_URL}/current/driverStandings.json"
    drivers_response = requests.get(standings_url)
    
    if drivers_response.status_code == 200:
        standings_data = drivers_response.json()
        standings_list = standings_data.get('MRData', {}).get('StandingsTable', {}).get('StandingsLists', [])

        if standings_list:
            driver_standings = standings_list[0].get('DriverStandings', [])
            upcoming_race['drivers'] = [
                {
                    "driver_id": driver['Driver']['driverId'],
                    "driver_name": f"{driver['Driver']['givenName']} {driver['Driver']['familyName']}",
                    "team_name": driver['Constructors'][0]['name']  # Extract team name from Constructors
                }
                for driver in driver_standings
            ]
    else:
        upcoming_race['drivers'] = [{"error": "Failed to fetch driver standings for the current season."}]

    return jsonify(upcoming_race)


# Get last race results - WORKS
@api_blueprint.route('/home/last_race_results/', methods=['GET'])
@cache.cached(timeout=0)
def get_last_race_results():
    # Fetch the current season's schedule
    schedule_url = f"{BASE_ERGAST_URL}/current.json"
    response = requests.get(schedule_url)
    
    if response.status_code != 200:
        return jsonify({"error": "Failed to retrieve season schedule"}), response.status_code

    race_table = response.json()['MRData']['RaceTable']['Races']
    
    if not race_table:
        return jsonify({"error": "No races found for the current season"}), 404

    # Ensure races are sorted by round number
    races_sorted = sorted(race_table, key=lambda x: int(x['round']))
    
    # Total number of races scheduled for the season
    total_races = int(races_sorted[-1]['round'])
    
    last_race = None

    # Find the most recent past race
    for race in reversed(races_sorted):
        race_date = datetime.strptime(race['date'], "%Y-%m-%d")
        if race_date < datetime.now():
            last_race = int(race['round'])
            break

    if not last_race:
        return jsonify({"error": "No past races found"}), 404

    # Determine if the last race is the final race of the season
    is_last_race_of_season = (last_race == total_races)

    # Fetch results for the last completed race
    results_url = f"{BASE_ERGAST_URL}/current/{last_race}/results.json"
    results_response = requests.get(results_url)

    if results_response.status_code != 200:
        return jsonify({"error": "Failed to retrieve last race results"}), results_response.status_code

    race_data = results_response.json()['MRData']['RaceTable']['Races'][0]
    results = race_data['Results']

    if not results:
        return jsonify({"error": "No results found for the last race"}), 404

    # Extract the year from the race data
    year = race_data['season']

    # Extract details for the top 3 finishers and fastest lap
    last_race_results = {
        "race_id": str(last_race),
        "year": year,
        "first_position": {
            "driver_name": f"{results[0]['Driver']['givenName']} {results[0]['Driver']['familyName']}",
            "team_name": results[0]['Constructor']['name'],
            "driver_id": results[0]['Driver']['driverId']
        },
        "second_position": {
            "driver_name": f"{results[1]['Driver']['givenName']} {results[1]['Driver']['familyName']}",
            "team_name": results[1]['Constructor']['name'],
            "driver_id": results[1]['Driver']['driverId']
        },
        "third_position": {
            "driver_name": f"{results[2]['Driver']['givenName']} {results[2]['Driver']['familyName']}",
            "team_name": results[2]['Constructor']['name'],
            "driver_id": results[2]['Driver']['driverId']
        },
        "fastest_lap": {}
    }

    # Find the driver with the fastest lap
    for result in results:
        if 'FastestLap' in result:
            last_race_results["fastest_lap"] = {
                "driver_name": f"{result['Driver']['givenName']} {result['Driver']['familyName']}",
                "team_name": result['Constructor']['name'],
                "driver_id": result['Driver']['driverId']
            }
            break

    # Add the is_last_race_of_season boolean to the response
    last_race_results["is_last_race_of_season"] = is_last_race_of_season

    return jsonify(last_race_results)

# Get single specific race details (See More on home screen) - WORKS
@api_blueprint.route('/race/<int:year>/<int:round>/', methods=['GET'])
@cache.cached(timeout=0)
def get_race_by_year_and_round(year, round):
    # Fetch race data for the specific year and round
    race_url = f"{BASE_ERGAST_URL}/{year}/{round}.json"
    response = requests.get(race_url)

    if response.status_code != 200:
        return jsonify({"error": f"Failed to retrieve details for race in year {year}, round {round}"}), response.status_code

    race_data = response.json()['MRData']['RaceTable']['Races']
    if not race_data:
        return jsonify({"error": "No race data found"}), 404

    # Function to parse duration strings
    def parse_duration(duration_str):
        if ':' in duration_str:
            # Duration is in 'mm:ss.sss' format
            minutes, seconds = duration_str.split(':')
            total_seconds = int(minutes) * 60 + float(seconds)
            return total_seconds
        else:
            # Duration is in seconds
            return float(duration_str)

    # Initialize the race information dictionary
    race = race_data[0]
    race_info = {
        "date": race['date'],
        "race_name": race['raceName'],
        "race_id": str(round),
        "circuit_name": race['Circuit']['circuitName'],
        "round": str(round),
        "location": f"{race['Circuit']['Location']['locality']}, {race['Circuit']['Location']['country']}",
        # Fields for additional race details
        "winner": "N/A",
        "winner_driver_id": "N/A",
        "winning_time": "N/A",
        "fastest_lap": "N/A",
        "fastest_lap_driver_id": "N/A",
        "fastest_lap_time": "N/A",
        "pole_position": "N/A",
        "pole_position_driver_id": "N/A",
        "fastest_pit_stop": "N/A",
        "fastest_pit_stop_driver_id": "N/A",
        "fastest_pit_stop_time": "N/A"
    }

    # Fetch winner, pole position, and fastest lap data
    race_results_url = f"{BASE_ERGAST_URL}/{year}/{round}/results.json"
    results_response = requests.get(race_results_url)

    if results_response.status_code == 200:
        results_data = results_response.json()['MRData']['RaceTable']['Races']
        if results_data:
            results = results_data[0]['Results']
            winner_info = results[0]
            race_info["winner"] = f"{winner_info['Driver']['givenName']} {winner_info['Driver']['familyName']}"
            race_info["winner_driver_id"] = winner_info['Driver']['driverId']
            race_info["winning_time"] = winner_info.get('Time', {}).get('time', "N/A")

            # Determine the fastest lap
            fastest_lap_time = None
            for result in results:
                if 'FastestLap' in result:
                    current_fastest_lap_time = result['FastestLap']['Time']['time']
                    if fastest_lap_time is None or current_fastest_lap_time < fastest_lap_time:
                        fastest_lap_time = current_fastest_lap_time
                        race_info["fastest_lap"] = f"{result['Driver']['givenName']} {result['Driver']['familyName']}"
                        race_info["fastest_lap_driver_id"] = result['Driver']['driverId']
                        race_info["fastest_lap_time"] = fastest_lap_time

    # Fetch qualifying data for pole position
    qualifying_url = f"{BASE_ERGAST_URL}/{year}/{round}/qualifying.json"
    qualifying_response = requests.get(qualifying_url)

    if qualifying_response.status_code == 200:
        qualifying_data = qualifying_response.json()['MRData']['RaceTable']['Races']
        if qualifying_data:
            pole_position = qualifying_data[0]['QualifyingResults'][0]
            race_info["pole_position"] = f"{pole_position['Driver']['givenName']} {pole_position['Driver']['familyName']}"
            race_info["pole_position_driver_id"] = pole_position['Driver']['driverId']

    # Fetch pit stop data to find the fastest pit stop
    pit_stop_url = f"{BASE_ERGAST_URL}/{year}/{round}/pitstops.json?limit=1000"
    pit_stop_response = requests.get(pit_stop_url)

    if pit_stop_response.status_code == 200:
        pit_stop_data = pit_stop_response.json()['MRData']['RaceTable']['Races']
        if pit_stop_data:
            pit_stops = pit_stop_data[0].get('PitStops', [])
            if pit_stops:
                # Find the pit stop with the shortest duration
                fastest_pit_stop = min(pit_stops, key=lambda x: parse_duration(x['duration']))
                race_info["fastest_pit_stop_time"] = fastest_pit_stop['duration']
                race_info["fastest_pit_stop_driver_id"] = fastest_pit_stop['driverId']

                # Fetch the driver’s full name for the fastest pit stop (if not cached)
                driver_id = fastest_pit_stop['driverId']
                driver_url = f"{BASE_ERGAST_URL}/drivers/{driver_id}.json"
                driver_response = requests.get(driver_url)
                if driver_response.status_code == 200:
                    driver_data = driver_response.json()['MRData']['DriverTable']['Drivers']
                    if driver_data:
                        driver = driver_data[0]
                        full_name = f"{driver['givenName']} {driver['familyName']}"
                        race_info["fastest_pit_stop"] = full_name
                    else:
                        race_info["fastest_pit_stop"] = driver_id
                else:
                    race_info["fastest_pit_stop"] = driver_id

    return jsonify(race_info)

# Get current season constructors standings - WORKS
@api_blueprint.route('/constructors/<int:year>/standings/', methods=['GET'])
@cache.cached(timeout=0)
def get_constructors_standings(year):
    # Retrieve constructors' current points tally and names for the specified season
    standings_url = f"{BASE_ERGAST_URL}/{year}/constructorStandings.json"
    response = requests.get(standings_url)
    
    if response.status_code != 200:
        return jsonify({"error": f"Failed to retrieve constructors standings for year {year}"}), response.status_code

    standings_data = response.json()['MRData']['StandingsTable']['StandingsLists']
    if standings_data:
        constructors_standings = []
        for standing in standings_data[0]['ConstructorStandings']:
            constructors_standings.append({
                "position": standing['position'],
                "points": standing['points'],
                "wins": standing['wins'],
                "constructor_id": standing['Constructor']['constructorId'],
                "constructor_name": standing['Constructor']['name']
            })
        return jsonify({"constructors_standings": constructors_standings})
    else:
        return jsonify({"error": f"No constructors standings found for year {year}"}), 404

# Get drivers' current points tally and names for the given season - WORKS
@api_blueprint.route('/drivers/<int:year>/standings/', methods=['GET'])
@cache.cached(timeout=0)
def get_drivers_current_points(year):
    # Define the Ergast API endpoint for driver standings
    driver_standings_url = f"{BASE_ERGAST_URL}/{year}/driverStandings.json"
    response = requests.get(driver_standings_url)
    
    if response.status_code != 200:
        return jsonify({"error": f"Failed to retrieve driver standings for the year {year}"}), response.status_code
    
    # Parse the JSON response
    standings_data = response.json()['MRData']['StandingsTable']['StandingsLists']
    if not standings_data:
        return jsonify({"error": f"No driver standings data available for the year {year}"}), 404

    # Extract the driver standings
    driver_standings = []
    for standing in standings_data[0]['DriverStandings']:
        driver = standing['Driver']
        constructor = standing['Constructors'][0] if standing.get('Constructors') else {}
        driver_standings.append({
            "position": standing['position'],
            "points": standing['points'],
            "wins": standing['wins'],
            "driver_id": driver['driverId'],
            "driver_name": f"{driver['givenName']} {driver['familyName']}",
            "driver_nationality": driver['nationality'],
            "constructor_id": constructor.get('constructorId', 'N/A'),
            "constructor_name": constructor.get('name', 'N/A'),
            "constructor_nationality": constructor.get('nationality', 'N/A')
        })

    # Return the standings as a JSON response
    return jsonify({"driver_standings": driver_standings})

# Get lap-by-lap positions for a specific race - WORKS
@api_blueprint.route('/race/<int:year>/<int:round>/positions/', methods=['GET'])
@cache.cached(timeout=0)
def get_race_positions(year, round):
    # Fetch race results to determine the total number of laps
    results_url = f"{BASE_ERGAST_URL}/{year}/{round}/results.json"
    results_response = requests.get(results_url)
    if results_response.status_code != 200:
        return jsonify({"error": f"Failed to retrieve race results for round {round} in {year}"}), results_response.status_code

    results_data = results_response.json()['MRData']['RaceTable']['Races']
    if not results_data:
        return jsonify({"error": "No race results data found"}), 404

    race_results = results_data[0]['Results']

    # Find the maximum number of laps completed by any driver
    max_laps = max(int(result['laps']) for result in race_results)

    # Generate a list of lap numbers we want to fetch (every 3rd lap)
    lap_numbers = list(range(1, max_laps + 1, 3))  # Laps 1, 4, 7, ...

    # Ensure the final lap is included
    if max_laps not in lap_numbers:
        lap_numbers.append(max_laps)

    # Optional: Sort the lap_numbers to maintain order
    lap_numbers.sort()

    # Initialize data structures
    laps = {}
    drivers_set = set()

    # Fetch lap data for every 3rd lap
    for lap_number in lap_numbers:
        lap_url = f"{BASE_ERGAST_URL}/{year}/{round}/laps/{lap_number}.json?limit=1000"
        lap_response = requests.get(lap_url)
        if lap_response.status_code != 200:
            continue  # Skip if data is not available for this lap
        lap_data = lap_response.json()
        race_table = lap_data['MRData']['RaceTable']['Races']
        if not race_table or not race_table[0]['Laps']:
            continue
        lap_timings = race_table[0]['Laps'][0]['Timings']
        laps[lap_number] = lap_timings
        for timing in lap_timings:
            drivers_set.add(timing['driverId'])

    if not laps:
        return jsonify({"error": "No lap data found for the specified laps."}), 404

    # Initialize drivers data
    drivers = {}
    for driver_id in drivers_set:
        drivers[driver_id] = {
            "driver_id": driver_id,
            "positions": []
        }

    # Populate positions for each driver per lap
    for lap_number in lap_numbers:
        lap_timings = laps.get(lap_number, [])
        lap_positions = {timing['driverId']: int(timing['position']) for timing in lap_timings}
        for driver_id in drivers.keys():
            position = lap_positions.get(driver_id)
            drivers[driver_id]['positions'].append(position)

    # Fetch driver names from race results
    for result in race_results:
        driver_id = result['Driver']['driverId']
        driver_name = f"{result['Driver']['givenName']} {result['Driver']['familyName']}"
        if driver_id in drivers:
            drivers[driver_id]['driver_name'] = driver_name

    # Prepare the final data
    drivers_list = list(drivers.values())
    race_positions = {
        "laps": lap_numbers,
        "drivers": drivers_list
    }

    return jsonify(race_positions)

# Get lap-by-lap positions and lap times for a single driver and list of drivers for a specific race - WORKS
@api_blueprint.route('/race/<int:year>/<int:round>/driver/<string:driver_id>/lap_data/', methods=['GET'])
@cache.cached(timeout=0)
def get_driver_lap_data_with_drivers(year, round, driver_id):
    # Fetch lap data for the driver
    limit = 1000  # Ensure we retrieve all laps
    laps_url = f"{BASE_ERGAST_URL}/{year}/{round}/drivers/{driver_id}/laps.json?limit={limit}"
    response = requests.get(laps_url)
    
    if response.status_code != 200:
        return jsonify({"error": f"Failed to retrieve lap data for driver {driver_id} in round {round} of {year}"}), response.status_code
    
    data = response.json()
    race_table = data['MRData']['RaceTable']['Races']
    if not race_table or not race_table[0]['Laps']:
        return jsonify({"error": "No lap data found for this driver in the specified race."}), 404
    
    laps_data = race_table[0]['Laps']
    
    # Process the lap data
    lap_data_list = []
    for lap in laps_data:
        lap_number = int(lap['number'])
        timing = lap['Timings'][0]  # Only one timing per lap for the specific driver
        lap_time_str = timing['time']
        position = int(timing['position'])
        
        lap_data_list.append({
            "lap_number": lap_number,
            "lap_time": lap_time_str,
            "position": position
        })
    
    # Sort the list by lap number
    lap_data_list.sort(key=lambda x: x['lap_number'])
    
    # Fetch driver information
    driver_url = f"{BASE_ERGAST_URL}/drivers/{driver_id}.json"
    driver_response = requests.get(driver_url)
    if driver_response.status_code == 200:
        driver_data = driver_response.json()['MRData']['DriverTable']['Drivers'][0]
        driver_name = f"{driver_data['givenName']} {driver_data['familyName']}"
    else:
        driver_name = driver_id  # Fallback to driver ID if name not found
    
    # Fetch all drivers participating in the race
    drivers_url = f"{BASE_ERGAST_URL}/{year}/{round}/drivers.json"
    drivers_response = requests.get(drivers_url)
    drivers_list = []
    if drivers_response.status_code == 200:
        drivers_data = drivers_response.json()['MRData']['DriverTable']['Drivers']
        for driver in drivers_data:
            drivers_list.append({
                "driver_id": driver['driverId'],
                "driver_name": f"{driver['givenName']} {driver['familyName']}"
            })
    else:
        return jsonify({"error": "Failed to retrieve list of drivers for this race."}), drivers_response.status_code
    
    # Prepare the final data
    result = {
        "drivers": drivers_list,
        "lap_data": {
            "driver_id": driver_id,
            "driver_name": driver_name,
            "laps": lap_data_list
        }
    }
    
    return jsonify(result)

## RACE SCREEN VIEWS

# Get list of all races in selected year - WORKS
@api_blueprint.route('/races/<int:year>/', methods=['GET'])
@cache.cached(timeout=0)
def get_races_by_year(year):
    # Fetch all races in the selected year
    races_url = f"{BASE_ERGAST_URL}/{year}.json"
    response = requests.get(races_url)

    if response.status_code != 200:
        return jsonify({"error": f"Failed to retrieve races for {year}"}), response.status_code

    races = response.json()['MRData']['RaceTable']['Races']
    race_list = []

    # Initialize a driver cache to minimize API calls
    driver_cache = {}

    # Function to parse duration strings
    def parse_duration(duration_str):
        if ':' in duration_str:
            # Duration is in 'mm:ss.sss' format
            minutes, seconds = duration_str.split(':')
            total_seconds = int(minutes) * 60 + float(seconds)
            return total_seconds
        else:
            # Duration is in seconds
            return float(duration_str)

    # Loop through each race to get necessary details
    for race in races:
        round_num = race['round']
        race_info = {
            "date": race['date'],
            "race_name": race['raceName'],
            "race_id": round_num,
            "circuit_name": race['Circuit']['circuitName'],
            "round": f"{round_num}/{len(races)}",
            "location": f"{race['Circuit']['Location']['locality']}, {race['Circuit']['Location']['country']}",
            # Initialize fields that might not be available
            "winner": "N/A",
            "winner_driver_id": "N/A",
            "winning_time": "N/A",
            "fastest_lap": "N/A",
            "fastest_lap_driver_id": "N/A",
            "fastest_lap_time": "N/A",
            "pole_position": "N/A",
            "pole_position_driver_id": "N/A",
            "fastest_pit_stop": "N/A",
            "fastest_pit_stop_driver_id": "N/A",
            "fastest_pit_stop_time": "N/A"
        }

        # Fetch winner, pole position, fastest lap for each race
        race_details_url = f"{BASE_ERGAST_URL}/{year}/{round_num}/results.json"
        race_details_response = requests.get(race_details_url)

        # Check if race results are available
        if race_details_response.status_code == 200:
            race_details_data = race_details_response.json()['MRData']['RaceTable']['Races']
            if race_details_data:
                results = race_details_data[0]['Results']

                # Winner and Winning Time
                winner_info = results[0]
                race_info["winner"] = f"{winner_info['Driver']['givenName']} {winner_info['Driver']['familyName']}"
                race_info["winner_driver_id"] = winner_info['Driver']['driverId']
                race_info["winning_time"] = winner_info.get('Time', {}).get('time', "N/A")

                # Fastest Lap
                fastest_lap_time = None
                for result in results:
                    if 'FastestLap' in result:
                        current_fastest_lap_time = result['FastestLap']['Time']['time']
                        if fastest_lap_time is None or current_fastest_lap_time < fastest_lap_time:
                            fastest_lap_time = current_fastest_lap_time
                            race_info["fastest_lap"] = f"{result['Driver']['givenName']} {result['Driver']['familyName']}"
                            race_info["fastest_lap_driver_id"] = result['Driver']['driverId']
                            race_info["fastest_lap_time"] = fastest_lap_time

        # Fetch qualifying data
        qualifying_url = f"{BASE_ERGAST_URL}/{year}/{round_num}/qualifying.json"
        qualifying_response = requests.get(qualifying_url)

        # Check if qualifying data is available
        if qualifying_response.status_code == 200:
            qualifying_data = qualifying_response.json()['MRData']['RaceTable']['Races']
            if qualifying_data:
                pole_position = qualifying_data[0]['QualifyingResults'][0]
                race_info["pole_position"] = f"{pole_position['Driver']['givenName']} {pole_position['Driver']['familyName']}"
                race_info["pole_position_driver_id"] = pole_position['Driver']['driverId']

        # Fetch pit stop data to find the fastest pit stop
        pit_stop_url = f"{BASE_ERGAST_URL}/{year}/{round_num}/pitstops.json?limit=1000"
        pit_stop_response = requests.get(pit_stop_url)

        if pit_stop_response.status_code == 200:
            pit_stop_data = pit_stop_response.json()['MRData']['RaceTable']['Races']
            if pit_stop_data:
                pit_stops = pit_stop_data[0].get('PitStops', [])
                if pit_stops:
                    # Function to parse duration is defined above
                    # Find the pit stop with the shortest duration
                    fastest_pit_stop = min(pit_stops, key=lambda x: parse_duration(x['duration']))
                    race_info["fastest_pit_stop_time"] = fastest_pit_stop['duration']
                    race_info["fastest_pit_stop_driver_id"] = fastest_pit_stop['driverId']

                    driver_id = fastest_pit_stop['driverId']
                    # Use driver cache to minimize API calls
                    if driver_id in driver_cache:
                        race_info["fastest_pit_stop"] = driver_cache[driver_id]
                    else:
                        # Fetch driver's full name
                        driver_url = f"{BASE_ERGAST_URL}/drivers/{driver_id}.json"
                        driver_response = requests.get(driver_url)
                        if driver_response.status_code == 200:
                            driver_data = driver_response.json()['MRData']['DriverTable']['Drivers']
                            if driver_data:
                                driver = driver_data[0]
                                full_name = f"{driver['givenName']} {driver['familyName']}"
                                race_info["fastest_pit_stop"] = full_name
                                driver_cache[driver_id] = full_name
                            else:
                                race_info["fastest_pit_stop"] = driver_id
                        else:
                            race_info["fastest_pit_stop"] = driver_id

        race_list.append(race_info)

    return jsonify(race_list)

# Get detailed results for a specific race - WORKS
@api_blueprint.route('/race/<int:year>/<int:round>/results/', methods=['GET'])
@cache.cached(timeout=0)
def get_race_results(year, round):
    # Fetch race results for a specific race
    results_url = f"{BASE_ERGAST_URL}/{year}/{round}/results.json"
    response = requests.get(results_url)

    if response.status_code != 200:
        return jsonify({"error": f"Failed to retrieve results for round {round} in {year}"}), response.status_code

    race_results = response.json()['MRData']['RaceTable']['Races'][0]['Results']
    race_details = []

    # Loop through each result to gather required details
    for result in race_results:
        race_details.append({
            "position": result['position'],
            "driver": f"{result['Driver']['givenName']} {result['Driver']['familyName']}",
            "driver_id": result['Driver']['driverId'],
            "team": result['Constructor']['name'],
            "team_id": result['Constructor']['constructorId'],
            "time": result.get('Time', {}).get('time', "N/A"),
            "grid": result['grid'],
            "laps": result['laps'],
            "points": result['points']
        })

    return jsonify(race_details)

# Get lap by lap details for specific driver in a race - WORKS
@api_blueprint.route('/race/<int:year>/<int:round>/driver/<string:driver_id>/laps/', methods=['GET'])
@cache.cached(timeout=0)
def get_driver_lap_times(year, round, driver_id):
    lap = 1
    lap_times = []

    # Loop through each lap until no more data is found
    while True:
        lap_url = f"{BASE_ERGAST_URL}/{year}/{round}/laps/{lap}.json"
        lap_response = requests.get(lap_url)

        if lap_response.status_code != 200 or not lap_response.json()['MRData']['RaceTable']['Races']:
            break  # Stop if no data is found for this lap

        lap_data = lap_response.json()['MRData']['RaceTable']['Races'][0]['Laps'][0]['Timings']
        
        # Find lap time for specified driver
        for timing in lap_data:
            if timing['driverId'] == driver_id:
                lap_times.append({
                    "lap_number": lap,
                    "lap_time": timing['time']
                })
                break

        lap += 1  # Move to the next lap

    return jsonify(lap_times)

# Get pit stop data - WORKS
@api_blueprint.route('/race/<int:year>/<int:round>/pitstops/', methods=['GET'])
@cache.cached(timeout=0)
def get_pit_stops(year, round):
    # Fetch pit stop data for a specific race
    pitstop_url = f"{BASE_ERGAST_URL}/{year}/{round}/pitstops.json?limit=1000"
    response = requests.get(pitstop_url)

    if response.status_code != 200:
        return jsonify({"error": f"Failed to retrieve pit stops for round {round} in {year}"}), response.status_code

    pit_stops_data = response.json()['MRData']['RaceTable']['Races']
    if not pit_stops_data:
        return jsonify([])  # Return an empty list if no pit stop data is available

    pit_stops = pit_stops_data[0].get('PitStops', [])
    driver_pit_data = {}

    # Fetch race results to get team information
    results_url = f"{BASE_ERGAST_URL}/{year}/{round}/results.json"
    results_response = requests.get(results_url)

    driver_team_map = {}
    if results_response.status_code == 200:
        results_data = results_response.json()['MRData']['RaceTable']['Races']
        if results_data:
            results = results_data[0]['Results']
            # Build a mapping from driver_id to team_name and team_id
            for result in results:
                driver_id = result['Driver']['driverId']
                team_id = result['Constructor']['constructorId']
                team_name = result['Constructor']['name']
                driver_team_map[driver_id] = {
                    'team_name': team_name,
                    'team_id': team_id
                }

    # Function to parse duration strings
    def parse_duration(duration_str):
        if ':' in duration_str:
            # Duration is in 'mm:ss.sss' format
            minutes, seconds = duration_str.split(':')
            total_seconds = int(minutes) * 60 + float(seconds)
            return total_seconds
        else:
            # Duration is in seconds
            return float(duration_str)

    # Process each pit stop
    for pit_stop in pit_stops:
        driver_id = pit_stop['driverId']
        if driver_id not in driver_pit_data:
            team_info = driver_team_map.get(driver_id, {'team_name': 'N/A', 'team_id': 'N/A'})
            driver_pit_data[driver_id] = {
                "driver": driver_id,
                "team": team_info['team_name'],
                "team_id": team_info['team_id'],
                "total_duration": 0.0,
                "stops": []
            }
        
        # Add individual pit stop details
        driver_pit_data[driver_id]["stops"].append({
            "lap": pit_stop['lap'],
            "time_of_day": pit_stop['time'],
            "duration": parse_duration(pit_stop['duration'])
        })
        
        # Accumulate total duration
        driver_pit_data[driver_id]["total_duration"] += parse_duration(pit_stop['duration'])

    # Convert to list for JSON response
    pit_stops_list = list(driver_pit_data.values())
    
    return jsonify(pit_stops_list)

## DRIVERS SCREEN VIEWS

# Get all drivers in a given year - WORKS
@api_blueprint.route('/drivers/<int:year>/', methods=['GET'])
@cache.cached(timeout=0)
def get_drivers_by_year(year):
    # Fetch all drivers who participated in the selected year
    drivers_url = f"{BASE_ERGAST_URL}/{year}/drivers.json"
    response = requests.get(drivers_url)

    if response.status_code != 200:
        return jsonify({"error": f"Failed to retrieve drivers for {year}"}), response.status_code

    drivers = response.json()['MRData']['DriverTable']['Drivers']
    driver_list = [
        {
            "driver_name": f"{driver['givenName']} {driver['familyName']}",
            "driver_id": driver['driverId']
        }
        for driver in drivers
    ]

    return jsonify(driver_list)

## Get driver career and season stats - WORKS
@api_blueprint.route('/driver/<string:driver_id>/<int:year>/stats/', methods=['GET'])
@cache.cached(timeout=0)
def get_driver_stats(driver_id, year):
    def fetch_race_results(driver_id, season_year):
        # Fetch race results for a driver in a given season
        season_races_url = f"{BASE_ERGAST_URL}/{season_year}/drivers/{driver_id}/results.json?limit=1000"
        season_races_response = requests.get(season_races_url)
        if season_races_response.status_code == 200:
            season_races = season_races_response.json()['MRData']['RaceTable']['Races']
            return season_races
        return []

    def fetch_qualifying_results(driver_id, season_year):
        # Fetch qualifying results for a driver in a given season
        qualifying_url = f"{BASE_ERGAST_URL}/{season_year}/drivers/{driver_id}/qualifying.json?limit=1000"
        qualifying_response = requests.get(qualifying_url)
        if qualifying_response.status_code == 200:
            qualifying_data = qualifying_response.json()['MRData']['RaceTable']['Races']
            return qualifying_data
        return []

    def calculate_wins_podiums(race_results, driver_id):
        # Calculate wins and podiums from race results
        wins = 0
        podiums = 0
        for race in race_results:
            results = race['Results']
            for result in results:
                if result['Driver']['driverId'] == driver_id:
                    position = result['position']
                    if position == '1':
                        wins += 1
                    if int(position) <= 3:
                        podiums += 1
                    break  # Found the driver's result
        return wins, podiums

    def calculate_pole_positions(qualifying_data, driver_id):
        # Calculate pole positions from qualifying results.
        pole_positions = 0
        for race in qualifying_data:
            for qual_result in race['QualifyingResults']:
                if qual_result['Driver']['driverId'] == driver_id and qual_result['position'] == '1':
                    pole_positions += 1
                    break  # Found the driver's result
        return pole_positions

    def fetch_driver_standing(driver_id, season_year):
        # Fetch driver standing for a given season.
        standings_url = f"{BASE_ERGAST_URL}/{season_year}/drivers/{driver_id}/driverStandings.json"
        standings_response = requests.get(standings_url)
        if standings_response.status_code == 200:
            standings_data = standings_response.json()['MRData']['StandingsTable']['StandingsLists']
            if standings_data:
                driver_standing = standings_data[0]['DriverStandings'][0]
                return driver_standing
        return None
    
    def fetch_driver_general_info(driver_id):
        driver_info_url = f"{BASE_ERGAST_URL}/drivers/{driver_id}.json"
        response = requests.get(driver_info_url)
        
        if response.status_code == 200:
            driver_data = response.json().get('MRData', {}).get('DriverTable', {}).get('Drivers', [])
            if driver_data:
                driver = driver_data[0]  # Extract first driver entry
                full_name = f"{driver.get('givenName', '')} {driver.get('familyName', '')}"
                date_of_birth = driver.get('dateOfBirth', '')
                nationality = driver.get('nationality', '')
                driver_number = driver.get('permanentNumber', 'N/A')

                # Calculate age from date of birth
                age = None
                if date_of_birth:
                    birth_date = datetime.strptime(date_of_birth, "%Y-%m-%d")
                    today = datetime.today()
                    age = today.year - birth_date.year - ((today.month, today.day) < (birth_date.month, birth_date.day))

                return {
                    "full_name": full_name,
                    "date_of_birth": date_of_birth,
                    "age": age,
                    "nationality": nationality,
                    "driver_number": driver_number,
                }
        return {"error": f"Driver {driver_id} info could not be retrieved"}


    # Career Stats (all-time)
    career_stats_url = f"{BASE_ERGAST_URL}/drivers/{driver_id}/driverStandings.json?limit=1000"
    response = requests.get(career_stats_url)

    if response.status_code != 200:
        return jsonify({"error": f"Failed to retrieve career stats for driver {driver_id}"}), response.status_code

    standings_data = response.json()['MRData']['StandingsTable']['StandingsLists']
    all_time_stats = {
        "total_races": 0,
        "total_wins": 0,
        "total_podiums": 0,
        "total_championships": 0,
        "total_pole_positions": 0
    }
    season_results = []

    # Process each season's stats
    for season in standings_data:
        season_year = season['season']
        driver_standing = season['DriverStandings'][0]

        # Fetch race results
        race_results = fetch_race_results(driver_id, season_year)
        num_races = len(race_results)
        wins, podiums = calculate_wins_podiums(race_results, driver_id)

        # Fetch qualifying results
        qualifying_data = fetch_qualifying_results(driver_id, season_year)
        pole_positions = calculate_pole_positions(qualifying_data, driver_id)

        # Update all-time stats
        all_time_stats["total_races"] += num_races
        all_time_stats["total_wins"] += wins
        all_time_stats["total_podiums"] += podiums
        all_time_stats["total_pole_positions"] += pole_positions
        if driver_standing['position'] == '1':
            all_time_stats["total_championships"] += 1

        # Season result summary
        season_results.append({
            "year": season_year,
            "position": driver_standing['position'],
            "points": driver_standing['points'],
            "num_races": num_races,
            "wins": wins,
            "podiums": podiums,
            "pole_positions": pole_positions,
            "team": driver_standing['Constructors'][0]['name'] if driver_standing.get('Constructors') else "N/A",
        })

    # Current Season Stats
    race_results = fetch_race_results(driver_id, year)
    num_races = len(race_results)
    wins, podiums = calculate_wins_podiums(race_results, driver_id)

    qualifying_data = fetch_qualifying_results(driver_id, year)
    pole_positions = calculate_pole_positions(qualifying_data, driver_id)

    current_season_stats = {
        "num_races": num_races,
        "wins": wins,
        "podiums": podiums,
        "pole_positions": pole_positions
    }

    driver_standing = fetch_driver_standing(driver_id, year)
    if driver_standing:
        position = driver_standing['position']
        points = driver_standing['points']
        team = driver_standing['Constructors'][0]['name'] if driver_standing.get('Constructors') else "N/A"
        if position == '1':
            all_time_stats["total_championships"] += 1
    else:
        position = "N/A"
        points = "0"
        team = "N/A"

    # Update all-time stats with current season stats
    all_time_stats["total_races"] += current_season_stats["num_races"]
    all_time_stats["total_wins"] += current_season_stats["wins"]
    all_time_stats["total_podiums"] += current_season_stats["podiums"]
    all_time_stats["total_pole_positions"] += current_season_stats["pole_positions"]

    # Create season result for current season
    current_season_result = {
        "year": str(year),
        "position": position,
        "points": points,
        "num_races": current_season_stats['num_races'],
        "wins": current_season_stats['wins'],
        "podiums": current_season_stats['podiums'],
        "pole_positions": current_season_stats['pole_positions'],
        "team": team
    }

    # Check if the current season year is already in season_results
    if not any(result['year'] == str(year) for result in season_results):
        season_results.append(current_season_result)

    # Fetch general information about the driver
    general_info = fetch_driver_general_info(driver_id)

    # Combine all stats for JSON response
    return jsonify({
        "general_info": general_info,  # New section added
        "all_time_stats": all_time_stats,
        "current_season_stats": current_season_stats,
        "season_results": season_results
    })

# Get driver race stats for a given year - WORKS
@api_blueprint.route('/driver/<string:driver_id>/<int:year>/races/', methods=['GET'])
@cache.cached(timeout=0)
def get_driver_races(year, driver_id):
    # Fetch all races for the driver in the specified year
    race_results_url = f"{BASE_ERGAST_URL}/{year}/drivers/{driver_id}/results.json"
    response = requests.get(race_results_url)

    if response.status_code != 200:
        return jsonify({"error": f"Failed to retrieve races for driver {driver_id} in {year}"}), response.status_code

    races = response.json()['MRData']['RaceTable']['Races']
    race_details = []

    # Extract required information for each race
    for race in races:
        race_result = race['Results'][0]
        race_details.append({
            "race_id": race['round'],
            "race_name": race['raceName'],
            "qualifying_position": race_result.get('grid', 'N/A'),
            "grid": race_result['grid'],
            "result": race_result['position']
        })

    return jsonify(race_details)

## TEAMS SCREEN VIEWS

# Get teams in a year - WORKS
@api_blueprint.route('/teams/<int:year>/', methods=['GET'])
@cache.cached(timeout=0)
def get_teams_by_year(year):
    # Fetch all constructors for the selected year
    constructors_url = f"{BASE_ERGAST_URL}/{year}/constructors.json"
    response = requests.get(constructors_url)

    if response.status_code != 200:
        return jsonify({"error": f"Failed to retrieve constructors for {year}"}), response.status_code

    constructors = response.json()['MRData']['ConstructorTable']['Constructors']
    team_list = []

    # Loop through each constructor to gather stats
    for constructor in constructors:
        team_id = constructor['constructorId']
        team_name = constructor['name']

        # Initialize stats for the year
        team_stats = {
            "team_id": team_id,
            "team_name": team_name,
            "year_wins": 0,
            "year_podiums": 0,
            "drivers": []
        }

        # Fetch race results for this constructor in the specified year
        team_results_url = f"{BASE_ERGAST_URL}/{year}/constructors/{team_id}/results.json"
        results_response = requests.get(team_results_url)

        if results_response.status_code == 200:
            races = results_response.json()['MRData']['RaceTable']['Races']

            # Loop through races to calculate wins and podiums and collect drivers
            driver_set = set()
            for race in races:
                result = race['Results'][0]
                position = int(result['position'])

                # Track wins and podiums
                if position == 1:
                    team_stats["year_wins"] += 1
                if position <= 3:
                    team_stats["year_podiums"] += 1

                # Track drivers for the team
                driver_id = result['Driver']['driverId']
                driver_name = f"{result['Driver']['givenName']} {result['Driver']['familyName']}"
                if driver_id not in driver_set:
                    team_stats["drivers"].append(driver_name)
                    driver_set.add(driver_id)

        team_list.append(team_stats)

    return jsonify(team_list)

# Get detailed team stats
@api_blueprint.route('/team/<string:team_id>/<int:year>/stats/', methods=['GET'])
@cache.cached(timeout=0)
def get_team_stats(team_id, year):
    # Initialize all-time stats and season results
    all_time_stats = {
        "total_races": 0,
        "total_wins": 0,
        "total_podiums": 0,
        "total_championships": 0,
        "total_pole_positions": 0
    }
    season_results = []

    # Fetch all seasons the team has participated in
    seasons_url = f"{BASE_ERGAST_URL}/constructors/{team_id}/seasons.json?limit=1000"
    seasons_response = requests.get(seasons_url)
    if seasons_response.status_code != 200:
        return jsonify({"error": f"Failed to retrieve seasons for team {team_id}"}), seasons_response.status_code

    seasons_data = seasons_response.json()['MRData']['SeasonTable']['Seasons']
    seasons_list = [season['season'] for season in seasons_data]

    # For each season, fetch race results and calculate stats
    for season in seasons_list:
        season_races_url = f"{BASE_ERGAST_URL}/{season}/constructors/{team_id}/results.json?limit=1000"
        season_races_response = requests.get(season_races_url)
        if season_races_response.status_code != 200:
            continue  # Skip this season if data cannot be fetched

        races_data = season_races_response.json()['MRData']['RaceTable']['Races']
        season_summary = {
            "year": season,
            "num_races": 0,
            "wins": 0,
            "podiums": 0,
            "pole_positions": 0,
            "position": "N/A",  # Will be updated later
            "points": 0.0,
            "drivers": set()
        }

        for race in races_data:
            # Process each driver result in the race
            for result in race['Results']:
                if result['Constructor']['constructorId'] != team_id:
                    continue  # Skip if not the team we're interested in

                season_summary["num_races"] += 1
                all_time_stats["total_races"] += 1

                position = int(result['position'])
                grid_position = int(result.get('grid', 0))

                # All-time accumulations
                if position == 1:
                    all_time_stats["total_wins"] += 1
                    season_summary["wins"] += 1
                if position <= 3:
                    all_time_stats["total_podiums"] += 1
                    season_summary["podiums"] += 1
                if grid_position == 1:
                    all_time_stats["total_pole_positions"] += 1
                    season_summary["pole_positions"] += 1

                # Accumulate points
                points = float(result['points'])
                season_summary["points"] += points

                # Collect drivers
                driver_name = f"{result['Driver']['givenName']} {result['Driver']['familyName']}"
                season_summary["drivers"].add(driver_name)

        # Convert drivers set to list
        season_summary["drivers"] = list(season_summary["drivers"])

        # Fetch the constructor standings for this season
        standings_url = f"{BASE_ERGAST_URL}/{season}/constructorStandings.json"
        standings_response = requests.get(standings_url)
        if standings_response.status_code == 200:
            standings_data = standings_response.json()['MRData']['StandingsTable']['StandingsLists']
            if standings_data:
                # Find the team's position in the standings
                constructor_standings = standings_data[0]['ConstructorStandings']
                for constructor in constructor_standings:
                    if constructor['Constructor']['constructorId'] == team_id:
                        season_summary["position"] = constructor['position']
                        season_summary["points"] = float(constructor['points'])  # Use total season points
                        # Check if the team won the championship
                        if season_summary["position"] == '1':
                            all_time_stats["total_championships"] += 1
                        break

        season_results.append(season_summary)

    # Find current season stats
    current_season_stats = next(
        (summary for summary in season_results if summary["year"] == str(year)),
        {
            "year": str(year),
            "num_races": 0,
            "wins": 0,
            "podiums": 0,
            "pole_positions": 0,
            "position": "N/A",
            "points": 0.0,
            "drivers": []
        }
    )

    # Combine all stats for JSON response
    return jsonify({
        "all_time_stats": all_time_stats,
        "current_season_stats": current_season_stats,
        "season_results": season_results
    })
