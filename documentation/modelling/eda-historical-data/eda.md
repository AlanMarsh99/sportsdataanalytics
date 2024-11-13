# Formula 1 EDA
This document outlines the steps taken during the Exploratory Data Analysis(EDA) of our historical F1 data dating from 1950-2024. The analysis will go over steps including loading the data, examining missing values, checking outliers in key columns and viewing the distributions of select columns to better understand the data.

### Load the data
We begin by loading the various datasets which include data on circuits, constructors, drivers, races, lap times, pit stops, and more. Each dataset is loaded into pandas dataframes for manipulation and analysis.

### Missing values
We performed checks for missing values across all the datasets. Identifying where and how much data is missing allows us to make informed decisions on how to address these gaps, whether through imputation, removal or simply leaving the data as is.

### Outliers
Outliers can impact analysis so we check outliers in various relevant columns. To detect outliers, we use boxplots and the Interquartile Range (IQR) method, which helps to flag data points that fall outside the expected range.

### Distributions
We examine the distribution of individual columns across the various datasets. This step is crucial for understanding the underlying data and identifying patterns, skewness, or irregularities within each feature.

### Merging relevant columns
For the purpose of creating a dataset suitable for multivariate analysis, a lot of the datasets were merged based on common keys such as raceId, driverId, and constructorId. These merges aim to consolidate critical information related to drivers, constructors, qualifying times, pit stops, lap times, and race results into a unified dataframe for further correlation analysis. The following steps detail the merging process for each dataset:

1. Merging with Drivers Data
The drivers dataset provides personal information about the drivers, such as their name, surname, date of birth, and nationality. Before merging with the results dataset, columns in the drivers DataFrame were renamed to avoid potential naming conflicts and to clarify the meaning of each variable. For instance:

nationality was renamed to drivers_nationality.
dob was renamed to driver_dob.
forename was renamed to driver_name.
surname was renamed to driver_surname.

2. Merging with Constructors Data
The constructors dataset provides metadata about each constructor (team), including the constructor’s name and nationality. Before merging with the existing merged_df, columns in the constructors DataFrame were renamed to avoid potential naming conflicts and to clarify the meaning of each variable:

nationality was renamed to constructors_nationality.
name was renamed to constructors_name.

3. Merging with Races Data
The races dataset provides metadata about each race, including the year the race was held, the round number, the circuit on which the race took place, and the race date. By merging this data with the merged_df, we are able to add details about the race environment.

4. Merging with Lap Times Data
The lap_times dataset provides detailed information about the performance of each driver on a lap-by-lap basis, including the lap number and the time (in milliseconds) taken to complete each lap. Before merging, the lap column in the lap_times dataset was renamed to lap_number to clearly indicate that it refers to the number of the lap within a race.

5. Merging with Qualifying Data
The qualifying dataset contains information about the driver's performance during the qualifying sessions, including the qualifying position and the lap times from the three qualifying rounds (q1, q2, and q3). Before merging, the position column in the qualifying dataset was renamed to qualifying_position to avoid confusion with the final race position in the results dataset.

6. Merging with Pit Stops Data
The pit_stops dataset contains information about the number of pit stops each driver made, the lap on which the pit stop occurred, and the duration of each pit stop. Before merging, the lap column was renamed to pit_lap to clarify that it refers to the lap when the pit stop occurred, avoiding confusion with the general lap data from the race.

### Correlation analysis
We explore the relationships between numerical columns through a correlation matrix. This is a key step for identifying linear relationships between different race performance metrics. By examining correlations, we can determine how features like qualifying position, lap times, final race positions and more are related to each other, which can guide feature selection for predictive modeling.

The process begins by selecting only the numerical columns from the dataset that are relevant for the analysis. These include:

race_grid: The starting position of the driver in the race.
final_position: The final race position of the driver.
points: The number of points the driver scored in the race.
lap_number, lap_milliseconds: Data relating to the laps during the race, including the lap number and the time it took to complete each lap.
pit_lap, pit_duration: Information about pit stops, including the lap the pit stop occurred and its duration.
qualifying_position: The driver’s starting grid position based on qualifying performance.
q1_milliseconds, q2_milliseconds, q3_milliseconds: The times (in milliseconds) from the different qualifying rounds (Q1, Q2, and Q3).

We then visualise these correlations using a heatmap which uses color coding to indicate the strength of the correlations, with red representing strong positive correlations, blue indicating strong negative correlations, and neutral colors for weak or no correlations.