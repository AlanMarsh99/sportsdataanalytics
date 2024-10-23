# **Backend Requirements Document**

## **Serving Data from a PostgreSQL Backend Using the F1 Database**

---

## **Table of Contents**

1. [Introduction](#1-introduction)
2. [Objectives](#2-objectives)
3. [Technology Stack](#3-technology-stack)
   - [3.1 Backend Framework Selection](#31-backend-framework-selection)
4. [System Architecture](#4-system-architecture)
5. [Database Design](#5-database-design)
   - [5.1 Entity Definitions](#51-entity-definitions)
   - [5.2 Relationships](#52-relationships)
   - [5.3 Constraints and Indexes](#53-constraints-and-indexes)
6. [API Design](#6-api-design)
   - [6.1 Endpoint Structure](#61-endpoint-structure)
   - [6.2 Request and Response Formats](#62-request-and-response-formats)
   - [6.3 Authentication](#63-authentication)
   - [6.4 Error Handling](#64-error-handling)
   - [6.5 Pagination, Filtering, and Sorting](#65-pagination-filtering-and-sorting)
7. [Development Environment Setup](#7-development-environment-setup)
   - [7.1 Backend Setup](#71-backend-setup)
8. [Testing and Quality Assurance](#8-testing-and-quality-assurance)
9. [Deployment Plan](#9-deployment-plan)

---

## **1. Introduction**

This document outlines the requirements for developing a backend system that serves data from a PostgreSQL database using the chosen F1 (Formula 1) database. The backend will provide a RESTful API that can be consumed by any client application, such as our Flutter frontend. The goal is to establish a robust, scalable, and secure backend architecture that allows users to access and interact with Formula 1 racing data.

---

## **2. Objectives**

- Utilize the F1 database to provide comprehensive data on Formula 1 races, drivers, teams, circuits, and results.
- Develop a RESTful API using Django and Django REST Framework to interact with the PostgreSQL F1 database.
- Ensure secure and efficient data transmission between the backend and clients.
- Implement authentication and authorization mechanisms where necessary.
- Provide thorough documentation and testing to maintain code quality and facilitate future enhancements.

---

## **3. Technology Stack**

- **Programming Language:** Python 3.x
- **Web Framework:** Django with Django REST Framework (DRF)
- **Database:** PostgreSQL (using the F1 database schema and data)
- **Version Control:** Git
- **Deployment:**
  - **Hosting:** Cloud platform (e.g., AWS EC2, Heroku) - undecided at this stage
  - **Database Service:** Managed PostgreSQL service (e.g., AWS RDS, Heroku Postgres) - undecided at this stage

### **3.1 Backend Framework Selection**

**Decision:** Use **Django** with **Django REST Framework (DRF)** for the backend.

**Reasoning:**

- **Rapid Development:** Django's built-in features (ORM, admin interface, authentication) accelerate development.
- **RESTful API Support:** DRF simplifies creating RESTful APIs with minimal boilerplate.
- **Security:** Django provides robust security features out of the box.
- **Scalability:** Suitable for both simple and complex applications.
- **Community and Support:** Large community with extensive documentation and third-party packages.

---

## **4. System Architecture**

- **Backend (Django + DRF):** Processes requests, applies business logic, interacts with the F1 database, and returns responses.
- **Database (PostgreSQL with F1 Data):** Stores and manages Formula 1 racing data.

---

## **5. Database Design**

### **5.1 Entity Definitions**

The database schema is based on the F1 database which includes the following primary tables:

- **Drivers**
  - `driverId` (Primary Key)
  - `driverRef`
  - `number`
  - `code`
  - `forename`
  - `surname`
  - `dob` (Date of Birth)
  - `nationality`
  - `url`

- **Constructors**
  - `constructorId` (Primary Key)
  - `constructorRef`
  - `name`
  - `nationality`
  - `url`

- **Circuits**
  - `circuitId` (Primary Key)
  - `circuitRef`
  - `name`
  - `location`
  - `country`
  - `lat` (Latitude)
  - `lng` (Longitude)
  - `alt` (Altitude)
  - `url`

- **Races**
  - `raceId` (Primary Key)
  - `year`
  - `round`
  - `circuitId` (Foreign Key to Circuits)
  - `name`
  - `date`
  - `time`
  - `url`

- **Results**
  - `resultId` (Primary Key)
  - `raceId` (Foreign Key to Races)
  - `driverId` (Foreign Key to Drivers)
  - `constructorId` (Foreign Key to Constructors)
  - `number`
  - `grid`
  - `position`
  - `positionText`
  - `positionOrder`
  - `points`
  - `laps`
  - `time`
  - `milliseconds`
  - `fastestLap`
  - `rank`
  - `fastestLapTime`
  - `fastestLapSpeed`
  - `statusId` (Foreign Key to Status)

- **Status**
  - `statusId` (Primary Key)
  - `status`

- **LapTimes**
  - `raceId` (Foreign Key to Races)
  - `driverId` (Foreign Key to Drivers)
  - `lap`
  - `position`
  - `time`
  - `milliseconds`

- **PitStops**
  - `raceId` (Foreign Key to Races)
  - `driverId` (Foreign Key to Drivers)
  - `stop`
  - `lap`
  - `time`
  - `duration`
  - `milliseconds`

- **Qualifying**
  - `qualifyId` (Primary Key)
  - `raceId` (Foreign Key to Races)
  - `driverId` (Foreign Key to Drivers)
  - `constructorId` (Foreign Key to Constructors)
  - `number`
  - `position`
  - `q1`
  - `q2`
  - `q3`

### **5.2 Relationships**

- **Drivers and Results:** One-to-Many (One driver can have many results).
- **Constructors and Results:** One-to-Many (One constructor can have many results).
- **Circuits and Races:** One-to-Many (One circuit can host many races).
- **Races and Results:** One-to-Many (One race can have many results).
- **Races and LapTimes/PitStops/Qualifying:** Similar relationships as above.

### **5.3 Constraints and Indexes**

- **Primary Keys:** As specified in each table.
- **Foreign Keys:** Enforce referential integrity between related tables.
- **Unique Constraints:** Where applicable, such as on composite keys.
- **Indexes:** We'll consider indexing frequently queried fields like `year`, `driverId`, and `raceId` if time allows.

---

## **6. API Design**

### **6.1 Endpoint Structure**

- **Base URL:** `/api/v1/`

#### **6.1.1 Drivers Endpoints**

| Method | Endpoint             | Description                  | Authentication |
|--------|----------------------|------------------------------|----------------|
| GET    | `/api/v1/drivers/`     | Retrieve list of drivers     | No             |
| GET    | `/api/v1/drivers/{id}/`| Retrieve driver details      | No             |

#### **6.1.2 Constructors Endpoints**

| Method | Endpoint                  | Description                      | Authentication |
|--------|---------------------------|----------------------------------|----------------|
| GET    | `/api/v1/constructors/`     | Retrieve list of constructors    | No             |
| GET    | `/api/v1/constructors/{id}/`| Retrieve constructor details     | No             |

#### **6.1.3 Circuits Endpoints**

| Method | Endpoint               | Description                 | Authentication |
|--------|------------------------|-----------------------------|----------------|
| GET    | `/api/v1/circuits/`      | Retrieve list of circuits   | No             |
| GET    | `/api/v1/circuits/{id}/` | Retrieve circuit details    | No             |

#### **6.1.4 Races Endpoints**

| Method | Endpoint            | Description                | Authentication |
|--------|---------------------|----------------------------|----------------|
| GET    | `/api/v1/races/`      | Retrieve list of races     | No             |
| GET    | `/api/v1/races/{id}/` | Retrieve race details      | No             |

#### **6.1.5 Results Endpoints**

| Method | Endpoint                      | Description                    | Authentication |
|--------|-------------------------------|--------------------------------|----------------|
| GET    | `/api/v1/results/`              | Retrieve race results          | No             |
| GET    | `/api/v1/results/{id}/`         | Retrieve specific result       | No             |
| GET    | `/api/v1/races/{race_id}/results/` | Retrieve results for a race    | No             |
| GET    | `/api/v1/drivers/{driver_id}/results/` | Retrieve results for a driver | No             |

#### **6.1.6 Additional Endpoints**

Similar endpoints can be created for:

- **Lap Times**
- **Pit Stops**
- **Qualifying**

### **6.2 Request and Response Formats**

- **Data Format:** Use JSON for request and response bodies.
- **Example Response for Driver Details:**

  - **Endpoint:** `GET /api/v1/drivers/1/`
  - **Response:**

    ```json
    {
      "driverId": 1,
      "driverRef": "hamilton",
      "number": 44,
      "code": "HAM",
      "forename": "Lewis",
      "surname": "Hamilton",
      "dob": "1985-01-07",
      "nationality": "British",
      "url": "http://en.wikipedia.org/wiki/Lewis_Hamilton"
    }
    ```

### **6.3 Authentication**
Method: Since the data is public, authentication may not be required for read-only access.

### **6.4 Error Handling**

- Return appropriate HTTP status codes:
  - `200 OK` for successful requests.
  - `400 Bad Request` for invalid parameters.
  - `404 Not Found` when resources are not found.
  - `500 Internal Server Error` for server-side errors.
- Provide error messages in JSON format:

  ```json
  {
    "error": "Driver not found."
  }
  ```

### **6.5 Pagination, Filtering, and Sorting**

- **Pagination:**
  - Use limit and offset parameters.
  - Example:

    ```
    GET /api/v1/drivers/?limit=50&offset=100
    ```

- **Filtering:**
  - Allow filtering based on fields.
  - Examples:

    ```
    GET /api/v1/drivers/?nationality=British
    GET /api/v1/races/?year=2023
    ```

- **Sorting:**
  - Use a sort parameter.
  - Example:

    ```
    GET /api/v1/races/?sort=-date
    ```

---

## **7. Development Environment Setup**

### **7.1 Backend Setup**

#### **7.1.1 Prerequisites**

- **Python 3.x:** Ensure Python is installed.
- **PostgreSQL:** Install and configure PostgreSQL.
- **F1 Database Data:**
  - Download the F1 database SQL file from the provided link.
  - Unzip the file to obtain the SQL script.

#### **7.1.2 Database Setup**

- **Create Database:**
  - Use PostgreSQL tools to create a new database for the F1 data.
- **Import Data:**
  - Execute the SQL script to populate the database with the F1 data.

#### **7.1.3 Project Initialization**

- **Create Django Project:**
  - Initialize a new Django project.
- **Configure Database Settings:**
  - Create a `settings.py` file with the database connection details.

#### **7.1.4 Model Integration**

- **Database Introspection:**
  - Use Django's `inspectdb` command to generate models based on existing tables.

#### **7.1.5 API Development**

- **Serializers:**
  - Create serializers for each model to control data representation.
- **Views and URLs:**
  - Develop API views using DRF's generic views or viewsets.
  - Define URL patterns for each endpoint.

---

## **8. Testing and Quality Assurance**

### **8.1 Testing**

- **Integration Tests:**
  - Test API endpoints to ensure accurate data retrieval.
- **Performance Testing:**
  - Assess response times and optimize queries.

### **8.2 Documentation**

- **API Documentation:**
  - Use DRF's built-in documentation to provide API docs.
- **Code Comments:**
  - Include comments and docstrings for maintainability.

---

## **9. Deployment Plan**

### **9.1 Backend Deployment**

- **Hosting Platform:**
  - We need to choose a suitable cloud platform that supports Django, Flutter and PostgreSQL.

### **9.2 Database Deployment**

- **Managed PostgreSQL Service:**
  - We will use a cloud provider's managed database for reliability and maintenance.

### **9.3 Security Measures**

- **HTTPS:**
  - Enforce HTTPS for all communications.
- **Rate Limiting:**
  - Implement rate limiting to prevent abuse.

---