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

## Summary of Achieved Features

### User Authentication
- Email and password sign-up and login using Firebase Authentication
- Google Sign-In integration
- Authentication gate routes users correctly based on login state

### Onboarding & Calorie Intake Setup
- Multi-step onboarding profile form collecting:
  - Age
  - Gender
  - Height
  - Weight
  - Activity level
  - Health goal
- Daily calorie target (TDEE) is calculated automatically
- User profile and calorie target saved to Firestore
- Users are redirected to the main application after completing setup

### Food Scanning & Analysis
- Camera screen with live preview and flash control
- Food image capture and analysis using the Gemini API
- Result screen displays detected food name and estimated calories

### Alternate Input Methods
- Gallery image selection for food analysis
- Manual text-based food entry for logging meals without image scanning

### History & Results
- Analysis results can be saved as food logs in Firestore
- History screen displays logged meals per user
- Consistent UI styling applied across all screens

---

## Technical Explanation

### Framework & UI
- Developed using Flutter (Dart) with Material UI
- Typography implemented using Google Fonts
- Custom color extension `Color.o(...)` used to manage opacity without deprecated APIs

### Authentication & Data
- Firebase Authentication handles user registration and login
- Cloud Firestore stores:
  - User profiles (daily calorie target, activity level, goal, etc.)
  - Food logs (food name, calories, timestamp, userId)

### Camera & Media
- `camera` plugin used for live camera preview and image capture
- `image_picker` plugin used for selecting images from the gallery

### AI Integration
- Gemini API integrated using the `google_generative_ai` package
- Image bytes and structured prompts sent to Gemini for food analysis
- API responses parsed into a `FoodResult` model containing:
  - Food name
  - Estimated calories

### Navigation & Application Flow
- AuthGate controls routing based on authentication and onboarding completion
- ScanScreen navigates to ResultScreen after analysis
- Manual input and gallery selection reuse the same analysis pipeline

---

## Limitations and Future Enhancements

### Current Limitations
- Gemini API responses can be inconsistent or fail in some cases
- Food scanning requires a valid API key and active internet connection
- Nutrient breakdown (protein, carbohydrates, fat) is currently placeholder data
- History entries use placeholder images
- Meal filtering is limited to "All" (meal type not stored in logs)
- Error handling is basic and mainly uses SnackBar notifications

### Future Enhancements
- Improve AI prompt reliability and add retry and error recovery mechanisms
- Save actual food images in meal history
- Add meal type selection (Breakfast, Lunch, Dinner)
- Store macronutrients and micronutrients in FoodLog
- Implement offline caching and synchronization
- Allow users to edit and delete food logs
- Add analytics features such as daily and weekly summary charts
- Add in-app settings for API key management and usage tracking


## References
- Flutter Documentation: https://docs.flutter.dev
- Firebase Documentation: https://firebase.google.com/docs
- Flutter Packages Repository: https://pub.dev
- UI Design Inspiration: https://dribbble.com
- Mobile UX Best Practices: https://material.io/design
