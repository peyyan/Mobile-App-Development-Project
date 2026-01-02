# Mobile-App-Development-Project

## Group 3

- MUHAMMAD ATFAN SYAHIR BIN AMRAN (2216291)
- MUHAMMAD FIKHRY IZZ BIN KHIRULFAZAL ()
- MOHAMAD QAYS BIN MOHAMAD IBRAHIM (2010901))
## Project Title
NutriScan – Smart Food Calorie Scanner Mobile Application
## Introduction
Monitoring daily calorie intake is essential for maintaining a healthy lifestyle. However, estimating calories manually can be inconvenient and inaccurate, especially for individuals with busy schedules. Many existing applications require users to input food details manually, which reduces usability.

NutriScan aims to solve this problem by providing a mobile application that allows users to scan food items using a smartphone camera. The application analyzes the captured food image and displays an estimated calorie value using food recognition technology. This project is relevant as it promotes health awareness while demonstrating the practical application of mobile development and cloud technologies.
## Objectives
- To develop a mobile application that scans food images and estimates calorie values
- To provide a simple and user-friendly calorie tracking experience
- To store users’ food scan history using cloud-based storage
- To apply Flutter and Firebase technologies learned in the course
- To complete a functional mobile application within the given timeframe
## Target Users
- University students
- Individuals who want to monitor daily calorie intake
- Users who prefer a fast and simple food calorie estimation tool
## Features and Functionalities
## UI Mock-up
<img width="349" height="770" alt="image" src="https://github.com/user-attachments/assets/48e7092c-9c17-4608-88f4-f393fbef5c82" /> <img width="336" height="764" alt="image" src="https://github.com/user-attachments/assets/ca3ab7ba-c95b-45e6-bf85-33084f361633" />
<img width="336" height="769" alt="image" src="https://github.com/user-attachments/assets/49ee5757-923e-4d25-a0fb-0199b59b149a" /> <img width="339" height="705" alt="image" src="https://github.com/user-attachments/assets/9cbcdd01-f540-44a6-ac8b-d6c01eb3b3d8" />
<img width="251" height="795" alt="image" src="https://github.com/user-attachments/assets/8c4b0b33-e8dc-4350-b149-349ba03489dc" />




## Architecture / Technical Design
NutriScan follows a client–server architecture using Flutter for the frontend and Firebase as the backend. The application is designed to be modular, scalable, and easy to maintain.

Frontend (Flutter)
- Built using Flutter framework
- Uses Material UI components
- Handles user interaction, navigation, and UI rendering
- Integrates device camera for food image capture

Backend (Firebase)
- Firebase Authentication: Handles user login and registration
- Cloud Firestore: Stores user profiles and food scan history
- Firebase Storage (optional): Stores uploaded food images
- External Food Recognition API: Processes food images and returns estimated calorie data

Widget / Component Structure
-main.dart – Application entry point and route management
- auth/ – Login and registration screens
- screens/ – Home, scan, result, history, and settings screens
- widgets/ – Reusable UI components (buttons, cards, list tiles)
- services/ – Firebase services and API integration
- models/ – Data models such as User and FoodLog

State Management
- setState() is used for basic UI state handling (loading, results display)
- Firebase Firestore streams are used for real-time data updates in history views
## Data Model
NutriScan uses Cloud Firestore, which follows a collection–document structure.

Collections
Users
- userId (String) – Firebase Authentication UID
- email (String)
- createdAt (Timestamp)

FoodLogs
- logId (String)
- userId (String) – Reference to Users collection
- foodName (String)
- estimatedCalories (Number)
- protein (Number, optional)
- carbohydrates (Number, optional)
- fat (Number, optional)
- imageUrl (String, optional)
- timestamp (Timestamp)
- dateKey (String – used for grouping daily logs)

Relationship
- One User can have many FoodLogs
- Each FoodLog belongs to one User
## Flowchart or Sequence Diagram
## References
