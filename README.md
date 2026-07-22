# Weather App 🌤️

A simple Flutter app that lets a user search for a city and view its current weather (temperature, condition, icon, humidity, wind speed), powered by [WeatherAPI.com](https://www.weatherapi.com/).

---

## Requirements

| Tool | Version |
|---|---|
| Flutter SDK | **3.44.4** |
| Dart SDK | **3.12.2** |

> The project's `pubspec.yaml` is pinned to:
> ```yaml
> environment:
>   sdk: '>=3.12.0 <4.0.0'
>   flutter: '>=3.44.0'
> ```
> If you're on an older version, you'll likely need to run `flutter upgrade` or adjust the constraint.

Check your installed version with:
```bash
flutter --version
```

---

## Dependencies

| Package | Used for |
|---|---|
| `dio` | Making the HTTP request to WeatherAPI.com and mapping network errors into readable messages |
| `flutter_bloc` | State management (Bloc pattern) — loading, success, and failure states |
| `equatable` | Efficient equality checks for states/events, avoiding unnecessary UI rebuilds |
| `cached_network_image` | Loading and disk-caching the weather condition icon |
| `shared_preferences` | Persisting the last successful API response so it can be shown offline |

---

## Getting Started

```bash
flutter pub get
flutter run
```

The API key is already wired into `lib/core/constants.dart` (the same key provided in the task spec), so no extra setup is needed.

---

## Project Structure

```
lib/
├── core/
│   ├── constants.dart          # Base URL, API key, cache keys
│   └── theme/
│       └── app_theme.dart      # Sky-blue Material 3 theme + gradient background
│
├── models/
│   └── weather_model.dart      # Parses raw JSON into a clean, immutable Dart model (Equatable)
│
├── services/
│   ├── weather_api_service.dart    # Dio request + mapping network errors into user-facing messages
│   └── weather_cache_service.dart  # Save/load the last response via SharedPreferences
│
├── bloc/
│   ├── weather_event.dart      # WeatherFetchRequested / WeatherUnitToggled / WeatherCacheLoadRequested
│   ├── weather_state.dart      # Initial / Loading / Success / Failure + TemperatureUnit enum
│   └── weather_bloc.dart       # Orchestrates the API and cache services, falls back to cache on failure
│
├── widgets/
│   ├── city_search_field.dart      # TextField + search button
│   ├── weather_display_card.dart   # Result card (city, temperature, icon, humidity, wind)
│   ├── unit_toggle.dart            # °C / °F toggle
│   ├── loading_view.dart           # Loading indicator
│   └── error_view.dart             # Error message display
│
├── screens/
│   └── home_screen.dart        # Main screen, wires the Bloc to all widgets above
│
└── main.dart                    # Entry point: BlocProvider + MaterialApp
```

General principle: each file has a single responsibility — parsing is separate from the API call, the API is separate from caching, and the UI is separate from all of it, connected only through Events/States.

---

## How the Task Requirements Are Covered

- **UI**: TextField for the city name, a Search button, a card showing city name/temperature/description/icon, and a loading indicator while fetching.
- **API Integration**: `Dio` performs a GET to `current.json`, swapping `q` for whatever city the user types.
- **State Management**: `flutter_bloc` — all UI changes are driven by states (`WeatherInitial`, `WeatherLoadInProgress`, `WeatherLoadSuccess`, `WeatherLoadFailure`).
- **Error Handling**: clear messages for an invalid city, no internet connection, or any other server error — all handled in `weather_api_service.dart`.
- **Code Quality**: full separation between layers (Models / Services / Bloc / Widgets / Screens) with comments on the important parts.

### Bonus:
- **Responsive Design**: `LayoutBuilder` in `home_screen.dart` caps the content width at 500px on larger screens (tablets) instead of letting the card stretch awkwardly, while still using the full width on phones.
- **Caching**: every successful response is saved to `SharedPreferences`. On launch, the app tries to show the last cached data immediately. If a later search fails (e.g. no internet), the Bloc falls back to the cached data and shows it **alongside** the error message with an "offline data" banner, instead of leaving the screen blank.

---

## Possible Next Steps

- Add debounce/autocomplete to the search field.
- Store a "recent searches" list using the same caching pattern.
- Add unit tests for `WeatherBloc` (the services are constructor-injected, so they're easy to mock).
