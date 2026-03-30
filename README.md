# Crypto Trade Mobile App

A premium Flutter crypto trading application built with **Clean Architecture**, **SOLID** principles, and **DRY** mechanisms.

## ✨ Features
- **Splash Screen**: Initial loading with smooth navigation.
- **Onboarding**: 3-step interactive walkthrough.
- **Authentication**: Modern Login and Register screens.
- **Profile**: Dashboard with balance and action items.
- **Settings**: Comprehensive app preferences.

## 🛠 Tech Stack
- **State Management**: flutter_bloc
- **Routing**: go_router
- **Dependency Injection**: get_it
- **Theming**: Centralized `AppColors` and `AppAssets`.
- **Localization**: arb files (configured in `lib/l10n`).

## 📁 Project Structure
```text
lib/
├── core/             # Shared essentials
│   ├── constants/    # Strings, Assets
│   ├── routes/       # GoRouter setup
│   ├── theme/        # AppColors, Themes
│   └── widgets/      # Reusable components
├── features/         # Feature-based folders
│   ├── auth/         # Login & Register
│   ├── onboarding/   # App introduction
│   ├── profile/      # User dashboard
│   ├── settings/     # App settings
│   └── splash/       # Start screen
└── main.dart         # App entry point
```
