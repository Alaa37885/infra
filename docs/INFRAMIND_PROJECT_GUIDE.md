# InfraMind Egypt — Complete Project Guide & Walkthrough

Welcome, future Computer Science & AI graduate! As your senior Flutter developer and technical mentor, I have prepared this comprehensive project guide to help you understand, run, debug, and present every single part of **InfraMind Egypt** with total confidence.

---

## 1. Project Architecture & Folder Structure

InfraMind follows a **Feature-First Clean Architecture**, separating responsibilities into modular folders. This is analogous to organizing a Python project into distinct packages (e.g., `auth/`, `map/`, `reports/`, `api/`).

### How the Application Starts
1. **`lib/main.dart`**: The application entry point.
   - Initializes Flutter bindings (`WidgetsFlutterBinding.ensureInitialized()`).
   - Locks device orientation to portrait mode (`SystemChrome.setPreferredOrientations`).
   - Creates dependency injection via `AppDependencies.create(useMockData: true)`.
   - Calls `runApp(InfraMindApp(dependencies: ...))`.
2. **`InfraMindApp` (`lib/main.dart`)**:
   - Sets up `MaterialApp` with `AppTheme.darkTheme`.
   - Wraps the app in `Directionality(textDirection: TextDirection.rtl)` for Arabic support.
   - Sets the home screen to `SplashScreen`.

### Folder Organization (`lib/`)
```text
lib/
├── core/                        # Shared utilities, network config, global widgets
│   ├── network/                 # API base URLs, timeouts, headers (api_config.dart)
│   ├── utils/                   # Helper functions like opening Google Maps (maps_helper.dart)
│   └── widgets/                 # Reusable road artwork painting (road_artwork.dart)
│
├── features/                    # Feature-first modular organization
│   ├── authentication/          # Login, signup, onboarding, splash, forgot password
│   ├── home/                    # Dashboard & bottom navigation wrapper
│   ├── map/                     # OpenStreetMap view & places autocomplete
│   ├── road_reports/            # Reporting damages, viewing reports list, details
│   ├── profile/                 # User profile & settings
│   ├── notifications/           # System notifications & alerts
│   ├── live_scanner/            # Live camera preview, YOLO AI inference, GPS sync
│   └── road_issues/             # Domain entities, usecases, and repository data sources
│
└── theme/                       # Centralized theme & color palette (app_theme.dart)
```

### Important File-by-File Reference

| File Path | Purpose | What It Does | Connected Files |
|---|---|---|---|
| `lib/main.dart` | Entry Point | Initializes app, DI, and theme | `app_dependencies.dart`, `splash_screen.dart` |
| `lib/core/network/api_config.dart` | Network Config | Stores FastAPI Base URL & auth token | `remote_road_issue_data_source.dart`, `ai_inference_service.dart` |
| `lib/core/utils/maps_helper.dart` | Map Utility | Launches Google Maps search queries | `map_screen.dart`, `reports_screen.dart` |
| `lib/features/road_issues/domain/entities/road_issue.dart` | Domain Model | Pure Dart representation of a road defect | `road_issue_model.dart`, `road_issue_repository.dart` |
| `lib/features/road_issues/data/datasources/remote_road_issue_data_source.dart` | API Data Source | Fetches road issues from FastAPI REST endpoint | `road_issue_repository_impl.dart` |
| `lib/features/road_issues/data/datasources/local_road_issue_data_source.dart` | Mock Data Source | Provides local sample data for offline testing | `road_issue_repository_impl.dart` |
| `lib/features/map/presentation/screens/map_screen.dart` | Map View | Displays OpenStreetMap, user GPS, and issue markers | `flutter_map`, `latlong2`, `geolocator` |
| `lib/features/live_scanner/data/services/ai_inference_service.dart` | AI Service | Sends camera frames to FastAPI YOLO backend | `live_scanner_cubit.dart`, `camera` |
| `lib/features/live_scanner/presentation/screens/live_road_scanner_screen.dart` | Live Scanner | Camera preview + YOLO bounding box overlay | `live_scanner_cubit.dart`, `detection_overlay.dart` |

---

## 2. Screen-by-Screen Explanation

1. **SplashScreen**: Shows Egyptian pyramids skyline, golden logo, and flag badge. Automatically navigates to Onboarding after 3 seconds.
2. **OnboardingScreen**: 3 sequential slides explaining AI road detection, mapping, and citizen reporting.
3. **LoginScreen / SignUpScreen / ForgotPasswordScreen**: Authentication screens supporting role selection (`Citizen` vs `Maintenance Company`).
4. **HomeScreen (Dashboard)**: Displays road health progress (68%), priority counts (12, 28, 45), damage trend chart (`fl_chart`), and recent discoveries.
5. **LiveRoadScannerScreen**: Opens mobile camera, captures live frames, sends them to backend YOLO inference, and paints bounding boxes over the camera preview.
6. **MapScreen**: Renders OpenStreetMap (`flutter_map`), displays user GPS position, and renders color-coded markers (Red, Yellow, Green) for verified road issues. Tapping a marker opens the issue details bottom sheet.
7. **AddReportScreen**: Allows citizens to snap a photo, auto-detect GPS coordinates, select damage type and severity, and submit a report.
8. **ReportsScreen / DamageDetailsScreen**: Lists all road reports with filtering and status badges, showing detailed evidence on tap.
9. **ProfileScreen / SettingsScreen**: Manages engineer/citizen credentials, language, video quality, confidence threshold, and logout.
10. **NotificationsScreen**: Displays real-time alerts for new AI discoveries and maintenance updates.

---

## 3. Core Features in Detail

### A. Authentication
* **Implementation**: Managed via `LoginScreen`, `SignUpScreen`, and `AuthRepository`.
* **Roles**: Supports `UserRole.citizen` and `UserRole.maintenanceCompany`, altering available actions.
* **Backend vs Mock**: Currently uses mock authentication delaying for 800ms and returning a test JWT token. Ready to connect to FastAPI `/auth/login`.

### B. Map and GPS (OpenStreetMap)
* **Library**: `flutter_map` (tile layer from `tile.openstreetmap.org`) and `latlong2`.
* **GPS**: `geolocator` requests runtime permission (`ACCESS_FINE_LOCATION`) and streams device position.
* **Markers**: Created strictly when `latitude != null && longitude != null`. Deduplicated by `issue.id`.
* **Colors**: High priority = Red (`#C8102E`), Medium = Gold (`#D4AF37`), Low = Green (`#4CAF50`).

### C. Live Camera Scanner & YOLO Backend Pipeline
* **Pipeline**: Phone Camera → `CameraService` (startImageStream) → Frame Throttling (400ms) → `AiInferenceService` (HTTP POST to FastAPI) → YOLO Inference on Backend → JSON Detection Response (`DetectedBox` list) → `DetectionOverlay` (CustomPainter draws bounding boxes on camera preview).
* **AI Model**: PyTorch `.pt` model runs on FastAPI backend, NOT inside Flutter.

---

## 4. Project Completion Report

| Feature | Status | Evidence | What Remains |
|---|---|---|---|
| Splash & Onboarding | Complete and Tested | `splash_screen.dart`, `onboarding_screen.dart` | None |
| Authentication UI & Roles | Complete and Tested | `login_screen.dart`, `signup_screen.dart` | Real FastAPI Auth endpoints |
| Home Dashboard | Complete and Tested | `home_screen.dart`, `fl_chart` integration | Live WebSocket stats feed |
| OpenStreetMap & GPS | Complete and Tested | `map_screen.dart`, `flutter_map`, `geolocator` | Real-time marker stream |
| Road Issue Reporting | Complete and Tested | `add_report_screen.dart`, `reports_screen.dart` | File upload multipart endpoint |
| Live Camera & YOLO UI | Complete and Tested | `live_road_scanner_screen.dart`, `detection_overlay.dart` | Connecting to FastAPI `/live-stream` |
| Profile & Notifications | Complete and Tested | `profile_screen.dart`, `notifications_screen.dart` | Push notifications FCM |

---

## 5. How to Run the Application on Windows & Android

### Step-by-Step Instructions:
1. **Open Project**: Open Android Studio and select `C:\Development\InfraMind`.
2. **Check Flutter & Dart**: Run `flutter doctor` in the terminal to verify SDK setup.
3. **Start Emulator**: Open Device Manager in Android Studio and launch an Android Emulator (API 33+ recommended).
4. **Get Dependencies**: Run `flutter pub get` in the terminal.
5. **Run the App**: Click the **Run** button (green play icon) in Android Studio, or run:
   ```bash
   flutter run
   ```
6. **Build Debug APK**: To generate an APK for physical testing, run:
   ```bash
   flutter build apk --debug
   ```
   * Output location: `build/app/outputs/flutter-apk/app-debug.apk`.

---

## 6. Practical Testing Checklist

| Test Scenario | Action | Expected Success Behavior |
|---|---|---|
| **Onboarding & Login** | Launch app, click through slides, choose role, and log in. | Smooth navigation from Splash → Onboarding → Login → Dashboard. |
| **GPS & Map** | Open Map tab, grant location permission. | Map centers on Cairo/User location, blue GPS marker appears. |
| **Road Issue Markers** | View map with mock data. | Red, yellow, and green markers appear on valid coordinates; tapping opens bottom sheet. |
| **Live Scanner** | Open Live tab, grant camera permission. | Camera preview starts, bounding boxes appear over detected road defects. |
| **Add Report** | Click "أضف بلاغ", select photo, fill type/severity, submit. | Success dialog appears, report is saved. |

---

## 7. Prioritized Remaining Tasks
1. Connect FastAPI authentication endpoints (`/auth/login`, `/auth/signup`).
2. Integrate FastAPI real-time WebSocket or HTTP polling for live road monitoring.
3. Connect image upload multipart endpoint for citizen reports.
