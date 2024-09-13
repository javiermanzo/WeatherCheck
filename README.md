# WeatherCheck iOS Application

## Description

WeatherCheck is an iOS application that helps users track weather conditions in their favorite cities.

## Features

- [x] **City List**: View a list of registered cities.
- [x] **Current City with Location**: Display the current city based on the user's location.
- [x] **Add City Using Map**: Add a new city by selecting a location on the map.
- [x] **City Weather Details**: View detailed weather information for each city.
- [x] **Offline Mode**: Cities are stored locally to provide offline access to weather information.
- [x] **Calendar Event Creation**: Create events in the calendar to check the weather.
- [x] **Local Notifications**: Receive notifications when significant weather changes are detected.
- [x] **Background Fetch**: Continuously fetch weather updates in the background and alert users about weather changes.
- [x] **Empty State**: Show Empty State View when the current locations is not available and the cities are empty.
- [x] **Delete City**: Delete saved cites.
- [x] **Storage Framework Tests**: Test framework.
- [x] **RemoteImage Framework Tests**: Test framework.
- [x] **WeatherData Framework Tests**: Test framework.
- [ ] Improve design and user interface.
- [ ] Text localization.
- [ ] Display the last updated date for each city.
- [ ] Implement better error handling across the application.
- [ ] Add support for environment variables by using a `.env` script.
- [ ] Write integration tests.

## Setup

1. Clone the repository.
2. Navigate to the `Environment` class and add your API key:

```swift
class Environment {
    static let apiKey = "YOUR_API_KEY"
}
```

3. Build and run the application using Xcode.

