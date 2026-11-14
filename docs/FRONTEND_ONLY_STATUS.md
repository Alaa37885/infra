# InfraMind — Frontend-Only Status & Architecture Guide

This document outlines the frontend-only state of the **InfraMind Egypt** application, prepared independently of the Backend and Computer Vision teams.

---

## 1. Removed & Disabled Backend Integrations
- **HTTP REST Requests**: All outgoing REST calls (`http.get`, `http.post`) in data sources have been disconnected to ensure the application works 100% offline (except for online OpenStreetMap map tiles).
- **WebSocket / Live Streams**: Real-time socket connections have been disabled, replaced by local frame capture and sample detection overlays.
- **Remote Authentication**: Authentication data sources (`AuthDataSource`) now operate purely via local mock responses.
- **Local TFLite Inference**: Removed `flutter_vision` and local `.tflite` model loading to align with the FastAPI backend-only AI architecture.

---

## 2. Preserved Frontend Functionality
- **All 13 Screens**: Splash, Onboarding, Login, Sign Up, Forgot Password, Dashboard (Citizen & Maintenance Company roles), Live Camera Scanner, Add Report, Damage Details, OpenStreetMap, Reports List, Profile, Settings, and Notifications.
- **Navigation & Routing**: Complete navigation flow and bottom navigation bar (`MainNavigation`).
- **OpenStreetMap (`flutter_map`)**: Interactive OSM maps with Geolocator GPS tracking, custom markers colored by priority, and recenter controls.
- **Local Camera & GPS**: Camera preview initialization, local frame capture, and location services.
- **Local Mock Data**: Local mock data source providing realistic road defect records and observations for UI testing.

---

## 3. Temporary Mock Implementations
- **`LocalRoadIssueDataSource`**: Provides structured road issue observations and reports for testing maps, home dashboard, and reports screen.
- **`LocalAuthDataSource`**: Handles login and registration locally with test user credentials.
- **`AiInferenceService`**: Generates sample bounding box detections for the live scanner UI without network or local AI model overhead.

---

## 4. Future Integration Points for the Backend Team
When the official API contract and backend services are ready, integration will require:
1. Providing the confirmed FastAPI `Base URL` in `ApiConfig`.
2. Implementing `RemoteRoadIssueDataSource` using the confirmed REST endpoints.
3. Implementing `RemoteAuthDataSource` using confirmed authentication endpoints.
4. Implementing the confirmed real-time transport protocol (e.g., WebSocket) for live road damage monitoring.
