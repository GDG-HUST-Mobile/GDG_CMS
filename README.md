# 🧱 Flutter Feature-First Project Structure with Provider, HTTP, and GoRouter

This project follows a **feature-first architecture** using:
- 🧩 `Provider` for state management
- 🌐 `http` for API calls
- 🚀 `GoRouter` for navigation
- 📦 Repository pattern for clean data management

---

## 📁 Directory Structure
```
lib/ 
│ ├── core/ 
  │ ├── error/ # Custom exceptions (e.g. NetworkException, ParsingException) 
  │ ├── network/ # Shared API service (handles base URL, auth, errors) 
  │ ├── utils/ # App-wide constants, helpers
  │ ├── router/ # GoRouter setup
  │ └── theme/ # Default theme, colors, fonts
│ ├── features/ │
  └── posts/ # "Posts" feature module 
     │ ├── data/ # API + repository implementation 
     │ │ ├── models/ # PostModel (JSON-based) 
     │ │ └── repositories/ 
     │ ├── domain/ # Abstract entities + repository contract 
     │ ├── presentation/ # UI: Pages, Widgets, Provider/Notifier 
     │ └── posts_feature.dart # Exports all public classes for this feature 
│ ├── main.dart # Entry point with GoRouter + Provider setup 
```
## 💡 Folder Explanations

### 🔹 `core/`
Contains **shared logic** used across all features:
- `network/api_service.dart`: Handles `http` requests, headers, token, error handling
- `error/custom_exception.dart`: Sealed class for network, auth, parsing, etc.
- `utils/constants.dart`: Stores base URL and other constants

### 🔹 `features/{feature_name}/`
Each feature is **self-contained** with:
- `data/` - Handles API calls, local storage, and implements the repository
- `domain/` - Business logic interfaces and models (clean & independent)
- `presentation/` - UI layer: pages, widgets, and state providers
- `posts_feature.dart` - Re-exports public classes for easy use elsewhere

``Welcome to the Feature-First Flutter Project!Good luck building your app!``