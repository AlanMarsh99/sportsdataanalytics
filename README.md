# F1 Sports Data Analytics Tool

## Overview

This project is a **Sports Data Analytics Tool** focused on **Formula 1** racing calles **RACEVISION**. The tool enables users to explore, visualize, and make predictions using F1 race data. It includes dashboards for data exploration, predictive analytics models and gamification elements. The goal is to make complex data accessible to both technical and non-technical users, offering insights and trends about F1 races, drivers, and teams. To enhace user engagement, motivation, and interaction, the platform will incorporate various gamification features.

## Features

- **Data Exploration**: Filter and slice F1 data by race, driver, team, and more.
- **Visualization**: Interactive charts and graphs for race results, driver performance, and historical trends.
- **Predictive Analytics**: Machine learning models to forecast outcomes of future races based on historical data.
- **User Experience**: Designed to be intuitive for F1 fans, teams, broadcasters and journalists.
- **Gamification**: Make predictions of the upcoming race and compete with your friends to win points, avatars and badges to be the first of the leaderboard!

## Technology Stack

- **Frontend**: Flutter
- **Backend**: Django
- **Machine Learning**: Python for predictive analytics models
- **Database**: PostgreSQL and Firebase Cloud Firestore for data storage
- **Visualization Tools**: To be decided
- **Version Control**: Git, GitHub for code repository

## Setup and Installation

### Prerequisites

- Django
- Flutter
- Python
- Git
- PostgreSQL


### Installation Steps

1. Clone the repository:

    git clone https://github.com/AlanMarsh99/sports-data-analytics.git

2. Navigate to the project directory:

    cd sports-data-analytics

3. Navigate to the backend directory:

    cd backend

4. Run the Django development server using the command:

    python manage.py runserver

5. Go back to the project directory and navigate to the frontend directory:

    cd ..
    cd frontend

6. To serve your app from localhost in Chrome, enter the following command:

    flutter run -d chrome