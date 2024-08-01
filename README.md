# KlarnaWeather

KlarnaWeather is an iOS application developed using SwiftUI. It provides users with weather information for both their current location and any searched location.

## Features

- Displays weather information for the user's current location.
- Allows users to search and view weather information for any location.

## Frameworks

KlarnaWeather utilizes the following frameworks:
- Combine: For reactive programming.
- Swift Concurrency (async/await): For streamlined asynchronous code.

## API

The application uses the OpenWeatherMap API to fetch weather data and perform geographical city searches:
https://openweathermap.org/current
https://openweathermap.org/api/geocoding-api

## Design Decisions

KlarnaWeather features two main screens:

1- WeatherView: Displays weather information for the current or searched location. This is the primary focus of the application.
2- SearchView: Allows users to search for weather information by city. While search functionality is available, the main emphasis is on presenting the weather information clearly on the WeatherView.

The design prioritizes simplicity and ease of use, ensuring that the core functionality—displaying weather information—is immediately accessible and user-friendly.

## Technial Decisions

- In alignment with SOLID principles, managers are injected into view models as needed. Although it would have been possible to use shared managers as environment objects across both screens, this approach was avoided. The reason for this is that view models require access to the variables within the managers. Passing variables from views to view models would not align with the MVVM architecture. Therefore, injecting managers directly into view models was preferred.

- To ensure testability, protocols were employed in each manager. 

- To persist the last weather response, UserDefaults was used. A custom @propertyWrapper named UserDefaultsProperty was created to facilitate this functionality. This wrapper supports the storage of Codable responses in UserDefaults, allowing the application to display cached weather data when there is no internet connection.

- To safeguard sensitive information such as API keys and base URLs, a Config plist file was created. This approach helps prevent direct access to sensitive strings by centralizing their management and ensuring that such values are securely handled within the application.

- Reusable components were created to avoid redundant coding of identical views.

- All strings, fonts, images, and colors used within the app are consolidated under the resources directory.
 - 1 Extensions were created for fonts and colors to manage them efficiently, and all app-specific fonts and colors are maintained within these extensions. 
 - 2 For images and strings, Images and Localizable structs were created, respectively. This organization prevents direct usage of strings and system image names within views.
