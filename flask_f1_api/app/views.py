from flask import Blueprint, jsonify, request
import requests
from datetime import datetime

api_blueprint = Blueprint('api', __name__)

BASE_ERGAST_URL = "http://ergast.com/api/f1"

# HOME SCREEN VIEWS

# Get upcoming race information - WORKS
@api_blueprint.route('/home/upcoming_race/', methods=['GET'])
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
                "hour": race['time'][:5]  # Extract hour and minute from time
            }
            break

    if not upcoming_race:
        return jsonify({"error": "No upcoming races found"}), 404

    return jsonify(upcoming_race)


# Get last race results - WORKS
@api_blueprint.route('/home/last_race_results/', methods=['GET'])
def get_last_race_results():
    # Fetch the current season's schedule
    schedule_url = f"{BASE_ERGAST_URL}/current.json"
    response = requests.get(schedule_url)
    
    if response.status_code != 200:
        return jsonify({"error": "Failed to retrieve last race info"}), response.status_code

    races = response.json()['MRData']['RaceTable']['Races']
    last_race = None

    # Find the most recent past race
    for race in reversed(races):
        race_date = datetime.strptime(race['date'], "%Y-%m-%d")
        if race_date < datetime.now():
            last_race = race['round']
            break

    if not last_race:
        return jsonify({"error": "No past races found"}), 404

    # Fetch results for the last completed race
    results_url = f"{BASE_ERGAST_URL}/current/{last_race}/results.json"
    results_response = requests.get(results_url)

    if results_response.status_code != 200:
        return jsonify({"error": "Failed to retrieve last race results"}), results_response.status_code

    results = results_response.json()['MRData']['RaceTable']['Races'][0]['Results']

    # Extract details for the top 3 finishers and fastest lap
    last_race_results = {
        "race_id": last_race,
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

    return jsonify(last_race_results)

## RACE SCREEN VIEWS

# Get list of all races in selected year - WORKS
@api_blueprint.route('/races/<int:year>/', methods=['GET'])
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

# Get pit stop data - WORKS EXCEPT TEAM INFO MISSING
@api_blueprint.route('/race/<int:year>/<int:round>/pitstops/', methods=['GET'])
def get_pit_stops(year, round):
    # Fetch pit stop data for a specific race
    pitstop_url = f"{BASE_ERGAST_URL}/{year}/{round}/pitstops.json"
    response = requests.get(pitstop_url)

    if response.status_code != 200:
        return jsonify({"error": f"Failed to retrieve pit stops for round {round} in {year}"}), response.status_code

    pit_stops = response.json()['MRData']['RaceTable']['Races'][0].get('PitStops', [])
    driver_pit_data = {}

    # Process each pit stop
    for pit_stop in pit_stops:
        driver_id = pit_stop['driverId']
        if driver_id not in driver_pit_data:
            driver_pit_data[driver_id] = {
                "driver": driver_id,
                "total_duration": 0.0,
                "stops": []
            }
        
        # Add individual pit stop details
        driver_pit_data[driver_id]["stops"].append({
            "lap": pit_stop['lap'],
            "time_of_day": pit_stop['time'],
            "duration": float(pit_stop['duration'])
        })
        
        # Accumulate total duration
        driver_pit_data[driver_id]["total_duration"] += float(pit_stop['duration'])

    # Convert to list for JSON response
    pit_stops_data = list(driver_pit_data.values())
    
    return jsonify(pit_stops_data)

## DRIVERS SCREEN VIEWS

# Get all drivers in a given year - WORKS
@api_blueprint.route('/drivers/<int:year>/', methods=['GET'])
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

# Get driver career and season stats - WORKS EXCEPT POLE POSTIONS IN ALL TIME STATS, POLE POSITIONS IN CURRENT SEASON STATS, WINS IN CURRENT SEASON STATS
@api_blueprint.route('/driver/<string:driver_id>/<int:year>/stats/', methods=['GET'])
def get_driver_stats(driver_id, year):
    # Career Stats (all-time)
    career_stats_url = f"{BASE_ERGAST_URL}/drivers/{driver_id}/driverStandings.json"
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
        
        # Fetch total races in the season for the driver
        season_races_url = f"{BASE_ERGAST_URL}/{season_year}/drivers/{driver_id}/results.json"
        season_races_response = requests.get(season_races_url)

        if season_races_response.status_code == 200:
            season_races = season_races_response.json()['MRData']['RaceTable']['Races']
            num_races = len(season_races)
        else:
            num_races = 0  # Default if unable to fetch data

        all_time_stats["total_races"] += num_races
        all_time_stats["total_wins"] += int(driver_standing.get('wins', 0))
        all_time_stats["total_podiums"] += int(driver_standing.get('podiums', 0))
        all_time_stats["total_championships"] += 1 if driver_standing['position'] == '1' else 0

        # Season result summary
        season_results.append({
            "year": season_year,
            "position": driver_standing['position'],
            "points": driver_standing['points'],
            "num_races": num_races,
            "wins": int(driver_standing.get('wins', 0)),
            "team": driver_standing['Constructors'][0]['name'] if driver_standing.get('Constructors') else "N/A", 
        })

    # Current Season Stats
    current_season_url = f"{BASE_ERGAST_URL}/{year}/drivers/{driver_id}/results.json"
    season_response = requests.get(current_season_url)

    if season_response.status_code == 200:
        races = season_response.json()['MRData']['RaceTable']['Races']
        current_season_stats = {
            "num_races": len(races),
            "wins": sum(1 for race in races if race['Results'][0]['position'] == '1'),
            "podiums": sum(1 for race in races if int(race['Results'][0]['position']) <= 3),
            "pole_positions": sum(1 for race in races if race['Results'][0]['grid'] == '1')
        }
    else:
        current_season_stats = {
            "num_races": 0,
            "wins": 0,
            "podiums": 0,
            "pole_positions": 0
        }

    # Combine all stats for JSON response
    return jsonify({
        "all_time_stats": all_time_stats,
        "current_season_stats": current_season_stats,
        "season_results": season_results
    })

# Get driver race stats for a given year - WORKS
@api_blueprint.route('/driver/<string:driver_id>/<int:year>/races/', methods=['GET'])
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
def get_team_stats(team_id, year):
    # All-Time Stats
    all_time_stats_url = f"{BASE_ERGAST_URL}/constructors/{team_id}/results.json"
    response = requests.get(all_time_stats_url)

    if response.status_code != 200:
        return jsonify({"error": f"Failed to retrieve all-time stats for team {team_id}"}), response.status_code

    races_data = response.json()['MRData']['RaceTable']['Races']
    all_time_stats = {
        "total_races": len(races_data),
        "total_wins": 0,
        "total_podiums": 0,
        "total_championships": 0,
        "total_pole_positions": 0
    }
    season_results = []
    seasons = set()

    # Loop through each race to calculate all-time stats
    for race in races_data:
        season = race['season']
        if season not in seasons:
            seasons.add(season)
            season_summary = {
                "year": season,
                "num_races": 0,
                "wins": 0,
                "podiums": 0,
                "pole_positions": 0,
                "position": "N/A",
                "points": "0",
                "drivers": []
            }
            season_results.append(season_summary)

        result = race['Results'][0]
        position = int(result['position'])
        grid_position = int(result.get('grid', 0))
        
        # All-time accumulations
        all_time_stats["total_wins"] += 1 if position == 1 else 0
        all_time_stats["total_podiums"] += 1 if position <= 3 else 0
        all_time_stats["total_pole_positions"] += 1 if grid_position == 1 else 0

        # Update season summary for each season
        for summary in season_results:
            if summary["year"] == season:
                summary["num_races"] += 1
                summary["wins"] += 1 if position == 1 else 0
                summary["podiums"] += 1 if position <= 3 else 0
                summary["pole_positions"] += 1 if grid_position == 1 else 0
                summary["points"] = result['points']
                summary["position"] = result.get('position', "N/A")
                driver_name = f"{result['Driver']['givenName']} {result['Driver']['familyName']}"
                if driver_name not in summary["drivers"]:
                    summary["drivers"].append(driver_name)

    # Calculate championships by checking if team had position 1 at the end of each season
    standings_url = f"{BASE_ERGAST_URL}/constructors/{team_id}/constructorStandings.json"
    standings_response = requests.get(standings_url)
    if standings_response.status_code == 200:
        standings_data = standings_response.json()['MRData']['StandingsTable']['StandingsLists']
        for standing in standings_data:
            if standing['ConstructorStandings'][0]['position'] == '1':
                all_time_stats["total_championships"] += 1

    # Current Season Stats
    current_season_stats = next(
        (summary for summary in season_results if summary["year"] == str(year)),
        {"num_races": 0, "wins": 0, "podiums": 0, "pole_positions": 0}
    )

    # Combine all stats for JSON response
    return jsonify({
        "all_time_stats": all_time_stats,
        "current_season_stats": current_season_stats,
        "season_results": season_results
    })
