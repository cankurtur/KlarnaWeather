# KlarnaWeather

KlarnaWeather is an iOS application developed using SwiftUI. It provides users with weather information for both their current location and any searched location.

## Features

- Displays weather information for the user's current location.
- Allows users to search and view weather information for any location.

## Tech Stack

- Combine: For reactive programming.
- Swift Concurrency (async/await): For streamlined asynchronous code.
- MVVM (Model-View-ViewModel): Adopted as the architectural pattern.

## API

The application uses the OpenWeatherMap API to fetch weather data and perform geographical city searches:

1. https://openweathermap.org/current
1. https://openweathermap.org/api/geocoding-api

## Design Decisions

KlarnaWeather features two main screens:

1. `WeatherView`: Displays weather information for the current or searched location. This is the primary focus of the application.
1. `SearchView`: Allows users to search for weather information by city. While search functionality is available, the main emphasis is on presenting the weather information clearly on the `WeatherView`.

The design prioritizes simplicity and ease of use, ensuring that the core functionality—displaying weather information—is immediately accessible and user-friendly.

## Technial Decisions

- In alignment with SOLID principles, managers are injected into view models as needed. Although it would have been possible to use shared managers as environment objects across both screens, this approach was avoided. The reason for this is that view models require access to the variables within the managers. Passing variables from views to view models would not align with the MVVM architecture. Therefore, injecting managers directly into view models was preferred.

- In the `SearchView`, instead of making an API request for every keystroke, Combine's debounce operator is utilized. This approach delays the API request until the user has stopped typing for a brief period, reducing the number of requests sent to the server. This optimization reduce server load and minimizes unnecessary API calls.

- To ensure testability, protocols were employed in each manager. 

- To persist the last weather response, `UserDefaults` was used. A custom `@propertyWrapper` named `UserDefaultsProperty` was created to facilitate this functionality. This wrapper supports the storage of Codable responses in UserDefaults, allowing the application to display cached weather data when there is no internet connection.

- To safeguard sensitive information such as API keys and base URLs, a `Config` file was created. This approach helps prevent direct access to sensitive strings by centralizing their management and ensuring that such values are securely handled within the application.

- Reusable components were created to avoid redundant coding of identical views.

- All strings, fonts, images, and colors used within the app are consolidated under the resources directory. Extensions were created for fonts and colors to manage them efficiently, and all app-specific fonts and colors are maintained within these extensions. For images and strings, `Images` and `Localizable` structs were created, respectively. This organization prevents direct usage of strings and system image names within views.

- KlarnaWeather supports multiple units for temperature. To optimize performance and reduce unnecessary API calls, temperature conversions are computed locally within the app rather than making repeated requests for the same information. This approach minimizes network traffic. Once the user selects a temperature unit via a toggle, the app updates subsequent API requests to use the most recently selected unit.

## Notes:

- The functions in the `SearchViewModel` are private, which is why unit tests have not been written for this view model.
- The `isReachable` value in the `NetworkMonitorManager` may exhibit inconsistencies when tested on the simulator, as it directly relies on the macOS internet connection. For more accurate results, testing on a physical device is recommended. This link could be helpful: https://forums.developer.apple.com/forums/thread/713330
- The application supports multiple temperature units; however, changes to temperature units may not be consistent when tested in the iOS Simulator. This functionality works as expected on a physical device.
