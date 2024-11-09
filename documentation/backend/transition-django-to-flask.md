# Transition from Django to Flask

## Introduction

As our project requirements evolved, so did the need to re-evaluate our backend framework. Initially developed in Django, our backend was cumbersome, with an architectural complexity that didn’t align well with the needs of an API-focused application. After several iterations, we opted to transition to Flask, a micro-framework better suited for agile API development. This document outlines the key reasons for the shift, the benefits realised, and the lessons learned through the transition.

---

## Why Move from Django to Flask?

### 1. **Framework Complexity and Flexibility**
   - **Django** is a full-featured framework with built-in tools for templating, ORM, authentication, and more. However, this extensive structure can be limiting for applications that don’t need these features, especially API-centric projects.
   - **Flask**, in contrast, offers a micro-framework approach, giving developers essential tools and the freedom to add only what’s necessary. This flexibility allowed us to build an API-centric backend without the restrictions of Django’s layered architecture.

### 2. **Direct API Integration**
   - Our application relies on data from external sources, namely the **ergast API**. Django’s ORM and templating layers added unnecessary complexity and overhead to direct API integrations, requiring additional configurations for database management that weren’t needed.
   - Flask’s minimalistic approach allowed us to streamline integration with the ergast API, bypassing unnecessary middleware and focusing directly on API requests and responses.

### 3. **Control Over Application Structure**
   - **Django** enforces a specific project structure that, while beneficial for larger applications, proved restrictive in this case. Customisation often required navigating Django’s conventions, which significantly slowed development.
   - **Flask** allowed us to define our own application structure, giving us greater control over how we handled routes, views, and middleware. This freedom enabled a more efficient, API-focused design.

---

## Key Benefits of Using Flask

### 1. **Simplified Development Process**
   - Flask’s straightforward setup meant we could rapidly re-implement the backend with a focus on lean, efficient code. The lack of enforced structure gave us the flexibility we needed, which reduced development time.
   - By removing Django’s ORM and templating layers, we streamlined our backend, reducing the overhead associated with database management.

### 2. **Improved Performance**
   - Flask’s lightweight nature enhances our application’s performance by minimising overhead and focusing resources directly on handling HTTP requests.
   - Flask’s compatibility with caching tools like **Redis** allowed us to implement caching mechanisms that significantly improved load times and response efficiency.

### 3. **Greater Control Over Dependencies**
   - With Flask, we have complete control over the dependencies we integrate. We can select only the libraries needed, reducing bloat and making it easier to manage project dependencies.
   - This level of control allowed us to optimise the backend specifically for API functionality, making it more maintainable in the long run.

---

## Challenge(s) Faced During the Transition

### Refactoring Existing Code
   - Converting Django-specific logic to Flask-compatible code required some refactoring, particularly for routes and views. We restructured views, removed Django’s ORM calls, and replaced them with direct API interactions.
   - Adjusting to Flask’s minimalistic approach required a learning curve, but it was a lot more manageable than Django.

---

## Lessons Learned

1. **Select Frameworks Aligned with Project Requirements**: Moving to Flask underscored the importance of matching a framework to the application’s specific needs. Flask’s flexibility and simplicity proved a far better fit for our API-focused project.

2. **Value of Lightweight, Modular Architecture**: Flask’s modular approach enabled a more focused development process. We implemented only the tools and libraries necessary for API functionality, resulting in a leaner and faster backend.

3. **Importance of Caching for Performance**: With Flask, we explored caching mechanisms, including **Redis with Upstash**, which provided significant performance improvements. This caching setup proved essential for optimising load times and handling higher traffic.

---