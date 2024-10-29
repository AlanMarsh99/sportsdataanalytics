# API Documentation for F1 Backend

## Overview

This document provides an overview of the F1 Backend API and explains how the frontend developer (David) can interact with it to retrieve data for the frontend application.

## Running the Server

When you run the Django development server using the command `python manage.py runserver`, you're starting a local web server that listens for HTTP requests on port 8000 by default. This server hosts the backend application, including all the API endpoints.

### What the Server Does

- **Handles HTTP Requests**: Listens for incoming HTTP requests.
- **Processes Requests**: Routes each request to the appropriate view based on the URL patterns defined in `urls.py`.
- **Interacts with the Database**: Uses Django ORM to retrieve or manipulate data in the PostgreSQL database hosted on Railway.app.
- **Returns Responses**: Sends back HTTP responses, typically in JSON format, containing the requested data or status messages.

---

## Using the API

### Base URL

- **Local Development**: `http://127.0.0.1:8000/api/v1/`
- **Production**: Replace with the deployed server's URL when available.

### Authentication

- **No Authentication Required**: The API is public and doesn't require authentication for access.

### CORS Configuration

- **CORS Allowance**: Cross-Origin Resource Sharing (CORS) is configured to allow requests from all origins during development.

---

## Endpoints

### Driver Endpoints

#### 1. Get All Drivers

- **URL**: `/driver/`
- **Method**: `GET`
- **Description**: Retrieves a list of all drivers.
- **Query Parameters**:
  - `search` (string): Search drivers by first name or last name.
  - `nationality` (string): Filter drivers by nationality.
  - `limit` (int): Number of records to return (default is 50).
  - `offset` (int): Number of records to skip (for pagination).
- **Sample Request**:

  ```
  GET /api/v1/driver/?search=Hamilton&nationality=British
  ```

- **Sample Response**:

  ```json
  [
    {
      "id": "hamilton",
      "name": "Lewis Hamilton",
      "first_name": "Lewis",
      "last_name": "Hamilton",
      "full_name": "Lewis Hamilton",
      "abbreviation": "HAM",
      "permanent_number": "44",
      "gender": "Male",
      "date_of_birth": "1985-01-07",
      "nationality": "British",
      "total_championship_wins": 7,
      // ... other fields
    },
    // ... other drivers
  ]
  ```

#### 2. Get Driver Details

- **URL**: `/driver/<str:id>/`
- **Method**: `GET`
- **Description**: Retrieves detailed information about a specific driver.
- **Path Parameters**:
  - `id` (string): The unique ID of the driver.
- **Sample Request**:

  ```
  GET /api/v1/driver/hamilton/
  ```

- **Sample Response**:

  ```json
  {
    "id": "hamilton",
    "name": "Lewis Hamilton",
    "first_name": "Lewis",
    "last_name": "Hamilton",
    "full_name": "Lewis Hamilton",
    // ... other fields
  }
  ```

#### 3. Get Driver Results

- **URL**: `/driver/<str:id>/results/`
- **Method**: `GET`
- **Description**: Retrieves race results for a specific driver.
- **Sample Request**:

  ```
  GET /api/v1/driver/hamilton/results/
  ```

- **Sample Response**:

  ```json
  [
    {
      "race_id": 101,
      "year": 2023,
      "grand_prix": "British Grand Prix",
      "date": "2023-07-18",
      // ... other fields
    },
    // ... other races
  ]
  ```

### Constructor Endpoints

#### 1. Get All Constructors

- **URL**: `/constructor/`
- **Method**: `GET`
- **Description**: Retrieves a list of all constructors.
- **Sample Request**:

  ```
  GET /api/v1/constructor/
  ```

- **Sample Response**:

  ```json
  [
    {
      "id": "mercedes",
      "name": "Mercedes",
      "country": "Germany",
      // ... other fields
    },
    // ... other constructors
  ]
  ```

#### 2. Get Constructor Details

- **URL**: `/constructor/<str:id>/`
- **Method**: `GET`
- **Description**: Retrieves detailed information about a specific constructor.
- **Sample Request**:

  ```
  GET /api/v1/constructor/mercedes/
  ```

### Circuit Endpoints

#### 1. Get All Circuits

- **URL**: `/circuit/`
- **Method**: `GET`
- **Description**: Retrieves a list of all circuits.

#### 2. Get Circuit Details

- **URL**: `/circuit/<str:id>/`
- **Method**: `GET`
- **Description**: Retrieves detailed information about a specific circuit.

### Race Endpoints

#### 1. Get All Races

- **URL**: `/race/`
- **Method**: `GET`
- **Description**: Retrieves a list of all races.
- **Query Parameters**:
  - `year` (int): Filter races by year.
  - `search` (string): Search races by official name.
  - `limit` (int): Number of records to return.
  - `offset` (int): Number of records to skip.
- **Sample Request**:

  ```
  GET /api/v1/race/?year=2023
  ```

#### 2. Get Race Details

- **URL**: `/race/<int:id>/`
- **Method**: `GET`
- **Description**: Retrieves detailed information about a specific race.
- **Sample Request**:

  ```
  GET /api/v1/race/101/
  ```

#### 3. Get Race Results

- **URL**: `/race/<int:id>/results/`
- **Method**: `GET`
- **Description**: Retrieves the results of a specific race.
- **Sample Request**:

  ```
  GET /api/v1/race/101/results/
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
GET /api/v1/driver/?search=Verstappen HTTP/1.1
Host: 127.0.0.1:8000
Accept: application/json
```

---

## Pagination

- **Parameters**:
  - `limit`: Number of items per page (default is 50).
  - `offset`: Number of items to skip.
- **Usage**:
  - **First Page**: `/api/v1/driver/?limit=50&offset=0`
  - **Second Page**: `/api/v1/driver/?limit=50&offset=50`

---

## Error Handling

### Standard HTTP Status Codes

- **200 OK**: The request has succeeded.
- **400 Bad Request**: The server could not understand the request due to invalid syntax.
- **404 Not Found**: The server can not find the requested resource.
- **500 Internal Server Error**: The server has encountered a situation it doesn't know how to handle.

### Example Error Response

- **404 Not Found**:

  ```json
  {
    "detail": "Not found."
  }
  ```

---

## Integration Notes

### Data Models

- **Consistency**: Ensure the field names and data types provided by the API match what the frontend expects.

### CORS Considerations

- The backend allows all origins during development, but in production, it's recommended to specify allowed origins for security.

### Testing the API

- **Tools**: Use tools like Postman, Insomnia, or curl to test API endpoints independently.

---

## Deployment and Environment

- **Development Server**: Run locally using `python manage.py runserver`.
- **Production Server**: The backend will be deployed to a production environment accessible to the frontend application.

---