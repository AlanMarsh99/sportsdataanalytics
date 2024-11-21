# API Documentation for F1 Backend

## Overview

This document provides an overview of the F1 Backend API and explains how to interact with it to retrieve data for the frontend application. The API aggregates data from the [Ergast Developer API](http://ergast.com/mrd/) to provide Formula 1 statistics and information.

## Running the Server

When you run the Flask development server using the command `python run.py`, you're starting a local web server that listens for HTTP requests on port **5000** by default. This server hosts the backend application, including all the API endpoints.

## Using the API

### Base URL

- **Local Development**: `http://127.0.0.1:5000/`
- **Production**: Will replace with the deployed server's URL when available.

## Endpoints

### Home Screen Views

#### 1. Get Upcoming Race Information

- **URL**: `/home/upcoming_race/`
- **Method**: `GET`
- **Description**: Retrieves information about the next upcoming race in the current season.
- **Sample Request**:

  ```
  GET /home/upcoming_race/
  ```

- **Sample Response**:

  ```json
  {
    "race_name": "Dutch Grand Prix",
    "race_id": "14",
    "date": "2023-08-27",
    "hour": "13:00"
  }
  ```

#### 2. Get Last Race Results

- **URL**: `/home/last_race_results/`
- **Method**: `GET`
- **Description**: Retrieves the results of the most recent past race in the current season.
- **Sample Request**:

  ```
  GET /home/last_race_results/
  ```

- **Sample Response**:

  ```json
  {
    "race_id": "13",
    "first_position": {
      "driver_name": "Max Verstappen",
      "team_name": "Red Bull",
      "driver_id": "max_verstappen"
    },
    "second_position": {
      "driver_name": "Lewis Hamilton",
      "team_name": "Mercedes",
      "driver_id": "lewis_hamilton"
    },
    "third_position": {
      "driver_name": "Charles Leclerc",
      "team_name": "Ferrari",
      "driver_id": "charles_leclerc"
    },
    "fastest_lap": {
      "driver_name": "Lando Norris",
      "team_name": "McLaren",
      "driver_id": "lando_norris"
    },
    "year": "2024"
  }
  ```

#### 3. Get Race Information by Year and Round

- **URL**: `/race/<int:year>/<int:round>/`
- **Method**: `GET`
- **Description**: Retrieves detailed information about a specific race in a given year and round.
- **Sample Request**:

  ```
  GET /race/2023/10/
  ```

- **Sample Response**:

  ```json
  {
    "date": "2023-10-08",
    "race_name": "Japanese Grand Prix",
    "race_id": "10",
    "circuit_name": "Suzuka International Racing Course",
    "round": "10/22",
    "location": "Suzuka, Japan",
    "winner": "Max Verstappen",
    "winner_driver_id": "max_verstappen",
    "winning_time": "1:34:23.456",
    "fastest_lap": "Lewis Hamilton",
    "fastest_lap_driver_id": "lewis_hamilton",
    "fastest_lap_time": "1:32.345",
    "pole_position": "Charles Leclerc",
    "pole_position_driver_id": "charles_leclerc",
    "fastest_pit_stop": "Sergio Perez",
    "fastest_pit_stop_driver_id": "sergio_perez",
    "fastest_pit_stop_time": "2.345"
  }
  ```

#### 4. Get Drivers' Standings for a Specific Year

- **URL**: `/drivers/<int:year>/standings/`
- **Method**: `GET`
- **Description**: Retrieves drivers' current points tally and names for the given season.
- **Sample Request**:

  ```
  GET /drivers/2023/standings/
  ```

- **Sample Response**:

  ```json
  {
    "driver_standings": [
      {
        "position": "1",
        "points": "365",
        "wins": "11",
        "driver_id": "max_verstappen",
        "driver_name": "Max Verstappen",
        "driver_nationality": "Dutch",
        "constructor_id": "red_bull",
        "constructor_name": "Red Bull Racing",
        "constructor_nationality": "Austrian"
      },
      {
        "position": "2",
        "points": "280",
        "wins": "4",
        "driver_id": "lewis_hamilton",
        "driver_name": "Lewis Hamilton",
        "driver_nationality": "British",
        "constructor_id": "mercedes",
        "constructor_name": "Mercedes",
        "constructor_nationality": "German"
      },
      {
        "position": "3",
        "points": "210",
        "wins": "2",
        "driver_id": "charles_leclerc",
        "driver_name": "Charles Leclerc",
        "driver_nationality": "Monégasque",
        "constructor_id": "ferrari",
        "constructor_name": "Ferrari",
        "constructor_nationality": "Italian"
      }
      // More driver standings...
    ]
  }
  ```

#### 5. Get Constructors' Standings for a Specific Year

- **URL**: `/constructors/<int:year>/standings/`
- **Method**: `GET`
- **Description**: Retrieves constructors' current points tally and names for the specified season.
- **Sample Request**:

  ```
  GET /constructors/2023/standings/
  ```

- **Sample Response**:

  ```json
  {
    "constructors_standings": [
      {
        "position": "1",
        "points": "675",
        "wins": "13",
        "constructor_name": "Red Bull",
        "constructor_id": "red_bull"
      },
      {
        "position": "2",
        "points": "590",
        "wins": "5",
        "constructor_name": "Mercedes",
        "constructor_id": "mercedes"
      },
      {
        "position": "3",
        "points": "480",
        "wins": "3",
        "constructor_name": "Ferrari",
        "constructor_id": "ferrari"
      }
      // More constructors standings...
    ]
  }
  ```

#### 6. Get Lap-by-Lap Positions (Every 3rd Lap)

- **URL**: `/race/<int:year>/<int:round>/positions/`
- **Method**: `GET`
- **Description**: Retrieves the positions of each driver at every 3rd lap of a specified race.
- **Sample Request**:

  ```
  GET /race/2023/1/positions/
  ```

- **Sample Response**:

  ```json
  {
    "laps": [1, 4, 7, 10, 13, 16, 19, 22, 25, 28],
    "drivers": [
      {
        "driver_id": "max_verstappen",
        "driver_name": "Max Verstappen",
        "positions": [15, 7, 5, 3, 2, 2, 1, 1, 1, 1]
      },
      {
        "driver_id": "lewis_hamilton",
        "driver_name": "Lewis Hamilton",
        "positions": [5, 5, 4, 2, 3, 3, 3, 2, 2, 2]
      },
      {
        "driver_id": "charles_leclerc",
        "driver_name": "Charles Leclerc",
        "positions": [1, 1, 1, 1, 1, 1, 2, 3, 3, 3]
      },
      // ... additional drivers ...
    ]
  }
  ```

#### 7. Get Driver's Lap-by-Lap Data

- **URL**: `/race/<int:year>/<int:round>/driver/<string:driver_id>/lap_data/`
- **Method**: `GET`
- **Description**: Retrieves lap-by-lap data for a specific driver in a given race, including their lap times, positions, and basic driver information.

- **URL Parameters**:
  - `year` (int): The year of the race (e.g., `2023`).
  - `round` (int): The round number of the race in that season (e.g., `1` for the first race).
  - `driver_id` (string): The unique identifier of the driver (e.g., `max_verstappen`).

- **Sample Request**:

  ```
  GET /race/2023/1/driver/max_verstappen/lap_data/
  ```

- **Sample Response**:

  ```json
  {
    "driver_id": "max_verstappen",
    "driver_name": "Max Verstappen",
    "laps": [
      {
        "lap_number": 1,
        "lap_time": "1:32.123",
        "position": 1
      },
      {
        "lap_number": 2,
        "lap_time": "1:31.987",
        "position": 1
      },
      {
        "lap_number": 3,
        "lap_time": "1:32.045",
        "position": 1
      },
      {
        "lap_number": 4,
        "lap_time": "1:31.897",
        "position": 1
      }
      // ... additional laps ...
    ]
  }
  ```
  
---

### Race Screen Views

#### 1. Get List of All Races in Selected Year

- **URL**: `/races/<int:year>/`
- **Method**: `GET`
- **Description**: Retrieves a list of all races in the specified year.
- **Path Parameters**:
  - `year` (int): The year for which to retrieve races.
- **Sample Request**:

  ```
  GET /races/2023/
  ```

- **Sample Response**:

  ```json
  [
    {
      "date": "2023-03-05",
      "race_name": "Bahrain Grand Prix",
      "race_id": "1",
      "circuit_name": "Bahrain International Circuit",
      "round": "1/22",
      "location": "Sakhir, Bahrain",
      "winner": "Max Verstappen",
      "winner_driver_id": "max_verstappen",
      "winning_time": "1:33:56.736",
      "fastest_lap": "Sergio Perez",
      "fastest_lap_driver_id": "sergio_perez",
      "fastest_lap_time": "1:32.627",
      "pole_position": "Charles Leclerc",
      "pole_position_driver_id": "charles_leclerc"
    },
    // ... other races
  ]
  ```

#### 2. Get Detailed Results for a Specific Race

- **URL**: `/race/<int:year>/<int:round>/results/`
- **Method**: `GET`
- **Description**: Retrieves detailed results for a specific race.
- **Path Parameters**:
  - `year` (int): The year of the race.
  - `round` (int): The round number of the race.
- **Sample Request**:

  ```
  GET /race/2023/13/results/
  ```

- **Sample Response**:

  ```json
  [
    {
      "position": "1",
      "driver": "Max Verstappen",
      "driver_id": "max_verstappen",
      "team": "Red Bull",
      "team_id": "red_bull",
      "time": "1:25:38.426",
      "grid": "1",
      "laps": "70",
      "points": "25"
    },
    {
      "position": "2",
      "driver": "Lewis Hamilton",
      "driver_id": "lewis_hamilton",
      "team": "Mercedes",
      "team_id": "mercedes",
      "time": "+5.123",
      "grid": "3",
      "laps": "70",
      "points": "18"
    },
    // ... other drivers
  ]
  ```

#### 3. Get Lap by Lap Details for Specific Driver in a Race

- **URL**: `/race/<int:year>/<int:round>/driver/<string:driver_id>/laps/`
- **Method**: `GET`
- **Description**: Retrieves lap-by-lap timing data for a specific driver in a race.
- **Path Parameters**:
  - `year` (int): The year of the race.
  - `round` (int): The round number of the race.
  - `driver_id` (string): The unique ID of the driver.
- **Sample Request**:

  ```
  GET /race/2023/13/driver/lewis_hamilton/laps/
  ```

- **Sample Response**:

  ```json
  [
    {
      "lap_number": 1,
      "lap_time": "1:34.567"
    },
    {
      "lap_number": 2,
      "lap_time": "1:33.789"
    },
    // ... other laps
  ]
  ```

#### 4. Get Pit Stop Data

- **URL**: `/race/<int:year>/<int:round>/pitstops/`
- **Method**: `GET`
- **Description**: Retrieves pit stop data for a specific race.
- **Path Parameters**:
  - `year` (int): The year of the race.
  - `round` (int): The round number of the race.
- **Sample Request**:

  ```
  GET /race/2023/13/pitstops/
  ```

- **Sample Response**:

  ```json
  [
    {
      "driver": "lewis_hamilton",
      "total_duration": 4.5,
      "stops": [
        {
          "lap": "15",
          "time_of_day": "14:30:15",
          "duration": 2.2
        },
        {
          "lap": "45",
          "time_of_day": "15:15:45",
          "duration": 2.3
        }
      ]
    },
    {
      "driver": "max_verstappen",
      "total_duration": 2.0,
      "stops": [
        {
          "lap": "30",
          "time_of_day": "14:50:30",
          "duration": 2.0
        }
      ]
    },
    // ... other drivers
  ]
  ```

---

### Drivers Screen Views

#### 1. Get All Drivers in a Given Year

- **URL**: `/drivers/<int:year>/`
- **Method**: `GET`
- **Description**: Retrieves a list of all drivers who participated in the specified year.
- **Path Parameters**:
  - `year` (int): The year for which to retrieve drivers.
- **Sample Request**:

  ```
  GET /drivers/2023/
  ```

- **Sample Response**:

  ```json
  [
    {
      "driver_name": "Lewis Hamilton",
      "driver_id": "lewis_hamilton"
    },
    {
      "driver_name": "Max Verstappen",
      "driver_id": "max_verstappen"
    },
    // ... other drivers
  ]
  ```

#### 2. Get Driver Career and Season Stats

- **URL**: `/driver/<string:driver_id>/<int:year>/stats/`
- **Method**: `GET`
- **Description**: Retrieves career and current season statistics for a specific driver.
- **Path Parameters**:
  - `driver_id` (string): The unique ID of the driver.
  - `year` (int): The current season year.
- **Sample Request**:

  ```
  GET /driver/max_verstappen/2023/stats/
  ```

- **Sample Response**:

  ```json
  {
    "general_info": {
      "full_name": "Max Verstappen",
      "date_of_birth": "1997-09-30",
      "age": 26,
      "nationality": "Dutch",
      "driver_number": "33",
    },
    "all_time_stats": {
      "total_races": 150,
      "total_wins": 35,
      "total_podiums": 60,
      "total_championships": 2,
      "total_pole_positions": 20
    },
    "current_season_stats": {
      "num_races": 13,
      "wins": 8,
      "podiums": 11,
      "pole_positions": 6
    },
    "season_results": [
      {
        "year": "2023",
        "position": "1",
        "points": "310",
        "num_races": 13,
        "wins": 8,
        "team": "Red Bull",
        "podiums": 10,
        "pole_positions": 8
      },
      // ... previous seasons
    ]
  }
  ```

#### 3. Get Driver Race Stats for a Given Year

- **URL**: `/driver/<string:driver_id>/<int:year>/races/`
- **Method**: `GET`
- **Description**: Retrieves race-by-race statistics for a specific driver in a given year.
- **Path Parameters**:
  - `driver_id` (string): The unique ID of the driver.
  - `year` (int): The year for which to retrieve race stats.
- **Sample Request**:

  ```
  GET /driver/charles_leclerc/2023/races/
  ```

- **Sample Response**:

  ```json
  [
    {
      "race_id": "1",
      "race_name": "Bahrain Grand Prix",
      "qualifying_position": "1",
      "grid": "1",
      "result": "2"
    },
    {
      "race_id": "2",
      "race_name": "Saudi Arabian Grand Prix",
      "qualifying_position": "3",
      "grid": "3",
      "result": "1"
    },
    // ... other races
  ]
  ```

---

### Teams Screen Views

#### 1. Get Teams in a Year

- **URL**: `/teams/<int:year>/`
- **Method**: `GET`
- **Description**: Retrieves a list of all teams (constructors) that participated in a given year.
- **Path Parameters**:
  - `year` (int): The year for which to retrieve teams.
- **Sample Request**:

  ```
  GET //teams/2023/
  ```

- **Sample Response**:

  ```json
  [
    {
      "team_id": "mercedes",
      "team_name": "Mercedes",
      "year_wins": 2,
      "year_podiums": 7,
      "drivers": ["Lewis Hamilton", "George Russell"]
    },
    {
      "team_id": "red_bull",
      "team_name": "Red Bull",
      "year_wins": 8,
      "year_podiums": 12,
      "drivers": ["Max Verstappen", "Sergio Perez"]
    },
    // ... other teams
  ]
  ```

#### 2. Get Detailed Team Stats

- **URL**: `/team/<string:team_id>/<int:year>/stats/`
- **Method**: `GET`
- **Description**: Retrieves detailed statistics for a specific team, including all-time stats and current season stats.
- **Path Parameters**:
  - `team_id` (string): The unique ID of the team.
  - `year` (int): The current season year.
- **Sample Request**:

  ```
  GET //team/ferrari/2023/stats/
  ```

- **Sample Response**:

  ```json
  {
    "all_time_stats": {
      "total_races": 1010,
      "total_wins": 240,
      "total_podiums": 770,
      "total_championships": 16,
      "total_pole_positions": 230
    },
    "current_season_stats": {
      "num_races": 13,
      "wins": 1,
      "podiums": 4,
      "pole_positions": 2
    },
    "season_results": [
      {
        "year": "2023",
        "num_races": 13,
        "wins": 1,
        "podiums": 4,
        "pole_positions": 2,
        "position": "3",
        "points": "220",
        "drivers": ["Charles Leclerc", "Carlos Sainz"]
      },
      // ... previous seasons
    ]
  }
  ```

---

## Making Requests

### HTTP Methods

- **GET**: Used for retrieving data from the server.

### Headers

- **Accept**: Set to `application/json` to receive responses in JSON format.
- **Example**:

  ```
  Accept: application/json
  ```

### Example Request

```http
GET /drivers/2023/ HTTP/1.1
Host: 127.0.0.1:5000
Accept: application/json
```

---