# Formula 1 Data Sources
This document provides a list of public data sources currently being used for our Formula 1 project(subject to update/change).

## Kaggle - Formula 1 World Championship 1950-2024

**Datasets:**
*Circuits.csv* - circuitId, circuitRef, name, location, country, lat, long, alt, url.
*Constructor_results.csv* - constructorResultsId, raceId, constructorId, points, status.
*Constructor_standings.csv* - constructorStandingsId, raceId, constructorId, points, position, positionText, wins.
*Constructors.csv* - constructorId, constructorRef, name, nationality, url.
*Driver_standings.csv* - driverStandingsId, raceId, driverId, points, position, positionText, wins.
*Drivers.csv* - driverId, driverRef, number, code, forename, surname, dob, nationality, url.
*Pit_stops.csv* - raceId, driverId, stop, lap, time, duration, milliseconds.
*Lap_times.csv* - raceId, driverId, lap, position, time, milliseconds.
*Qualifying.csv* - qualifyId, raceId, driverId, constructorId, number, position, q1, q2, q3.
*Races.csv* - raceId, year, round, circuitId, name, date, time, url, fp1_date, fp1_time.
*Results.csv* - resultId, raceId, driverId, constructorId, number, grid, position, positionText, positionOrder, points.
*Seasons.csv* - year, url.
*Sprint_results.csv* - resultId, raceId, driverId, constructorId, number, grid, position, positionText, positionOrder, points.
*Status.csv* - statusId, status.

### Accessibility
The datasets are publicly accessible for download after registering on Kaggle. Kaggle provides the data in CSV formats.

### Usage Terms
The datasets aew subject to Kaggle's terms of service, and users must comply with the respective licensing and attributions where required.