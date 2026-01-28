# Mobile-App-Development-Project

## Group 3

- MUHAMMAD ATFAN SYAHIR BIN AMRAN (2216291)
- MUHAMMAD FIKHRY IZZ BIN KHIRULFAZAL (2128001)
- MOHAMAD QAYS BIN MOHAMAD IBRAHIM (2010901)
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
<table style="width: 100%; border-collapse: collapse;">
  <tr>
    <td align="center"><img src="https://github.com/user-attachments/assets/48e7092c-9c17-4608-88f4-f393fbef5c82" width="250"></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/ca3ab7ba-c95b-45e6-bf85-33084f361633" width="250"></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/49ee5757-923e-4d25-a0fb-0199b59b149a" width="250"></td>
  </tr>
  <tr>
    <td align="center"><img src="https://github.com/user-attachments/assets/9cbcdd01-f540-44a6-ac8b-d6c01eb3b3d8" width="250"></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/8c4b0b33-e8dc-4350-b149-349ba03489dc" width="250"></td>
    <td></td> </tr>
</table>




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
<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/8c0bfa98-d30a-4567-99bf-9e3e9a55337c" width="400"></td>
    <td><img src="https://github.com/user-attachments/assets/4b705719-6583-4a73-9232-59899250f648" width="266"></td>
  </tr>
</table>

### Final UI

<table style="width: 100%; border-collapse: collapse;">
  <tr>
    <td align="center"><img src="https://github.com/user-attachments/assets/9237d802-1f31-46c0-ad81-41a4c64bf71a" width="250"></td>
    <td align="center"><img src="![Image](https://github.com/user-attachments/assets/bf156caf-7b85-4af2-a773-459c7dfe140c)" width="250"></td>
    <td align="center"><img src="![Image](https://github.com/user-attachments/assets/7aa0a395-e078-4113-ab62-a169426fd8d3)" width="250"></td>
  </tr>
  <tr>
    <td align="center"><img src="![Image](https://github.com/user-attachments/assets/8c0f9485-823b-42de-9bb3-3320162ead28)" width="250"></td>
    <td align="center"><img src="![Image](https://github.com/user-attachments/assets/3823325d-b5c9-4923-bbe5-47410b794baf)" width="250"></td>
    <td align="center"><img src="![Image](https://github.com/user-attachments/assets/81df1a70-78e5-46c2-bfc4-77f96258252b)" width="250"></td>
  </tr>
  <tr>
    <td align="center"><img src="![Image](https://github.com/user-attachments/assets/91606bf6-41ea-4705-a138-ebbef0864edd)" width="250"></td>
    <td align="center"><img src="![Image](https://github.com/user-attachments/assets/a3b5e911-3364-4657-a75c-aea096e53af4)" width="250"></td>
    <td align="center"><img src="![Image](https://github.com/user-attachments/assets/7e1a4d1d-2cf0-4082-acbd-5584321ea56d)" width="250"></td>
  </tr>
  <tr>
    <td align="center"><img src="![Image](https://github.com/user-attachments/assets/9d6b69bd-2577-435b-860e-fc2448f6f013)" width="250"></td>
  </tr>
</table>

### Summary of achieved features 
The development of NutriScan achieved several key functional milestones. First, User Authentication and Security were successfully implemented using Firebase Authentication, ensuring that user sessions are managed securely and unauthenticated users are restricted from accessing the app. To provide value beyond simple logging, the team implemented a Personalized Calorie Estimation feature. This creates a unique profile for each user by collecting their health data during onboarding and automatically calculating a Total Daily Energy Expenditure (TDEE). This ensures that every user has a specific, scientifically calculated calorie goal stored in the cloud.

Regarding core functionality, the application supports Food Logging and Tracking via a robust manual entry system. While the initial plan relied heavily on AI scanning, the manual feature serves as a critical fallback, allowing users to input food names and calories effectively. As users submit logs, the application utilizes real-time streams to update the dashboard instantly. Additionally, the Camera Interface is fully integrated with the device hardware, successfully initializing the camera controller and displaying a live feed. Finally, all user data is backed by Cloud Storage using Firestore, ensuring that meal history is preserved and easily retrievable across sessions.

### Technical explanation
The application is architected using the Flutter framework for the frontend, employing a modular widget structure to ensure code maintainability. The backend is built on a Serverless Architecture using Firebase. Firebase Authentication manages identity, while Cloud Firestore serves as the NoSQL database to store hierarchical data, including User Profiles (containing fields for height, weight, and daily goals) and the FoodLogs collection.

A key algorithmic component of the application is the TDEE Calculation Logic. Rather than using static values, the application implements the Mifflin-St Jeor Equation directly within the Dart code. Upon profile submission, the system calculates the Basal Metabolic Rate (BMR) multiplied by the user's activity level to derive a daily calorie target, which is then written to the user’s Firestore document.

For the Camera Implementation, the application utilizes the camera plugin to manage the device's camera lifecycle and render the CameraPreview widget. While the image capture logic is fully scripted, the transmission of image bytes to the Gemini AI API is currently stubbed due to API key tier limitations. To compensate, the Manual Data Flow was optimized: when a user submits a manual log, a FoodLog object is instantiated, serialized into JSON, and pushed to Firestore. A stream listener on the Home Screen detects this database change and updates the UI in real-time without requiring a page refresh.

### Limitations and future enhancements
Despite the successful implementation of the core architecture, the project faces specific limitations. The primary constraint is that the AI Scanning feature is currently inactive; while the UI and capture logic function correctly, the connection to the food recognition API cannot process requests due to the lack of a production-tier API key. Consequently, the application relies on Manual Input, which places a burden on the user to know or look up the calorie content of their food. Additionally, the current logging system tracks only total calories, lacking a detailed breakdown of macronutrients such as proteins, fats, and carbohydrates.

To address these issues in future iterations, the immediate priority is to activate the AI Recognition capability by securing a commercial API key, which would allow the camera to automatically identify food items and estimate portion sizes. Furthermore, the manual logging experience could be significantly improved by integrating a third-party nutrition database (such as FatSecret or Edamam). This would allow users to search for food items and retrieve accurate calorie data automatically, removing the need for estimation. Finally, future updates should include Data Visualization tools, such as weekly charts and graphs, to help users analyze their long-term dietary trends.

## References
- Flutter Documentation: https://docs.flutter.dev
- Firebase Documentation: https://firebase.google.com/docs
- Flutter Packages Repository: https://pub.dev
- UI Design Inspiration: https://dribbble.com
- Mobile UX Best Practices: https://material.io/design
