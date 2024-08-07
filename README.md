# TMDBMovieApp iOS App

## Introduction
TMDBMovieApp is a mobile application built to showcase movies and TV shows using TMDB APIs. The app features a login screen, home screen displaying different media, and a details screen for selected movies or shows, with the ability to add favorites. The app implements secure authentication using OAuth 2.0 protocol and supports offline functionality through data caching.

## Features
* Authentication: OAuth 2.0 with Google as the provider using the AppAuth pod.
* Home Screen: Displays movies and TV shows fetched from TMDB APIs.
* Details Screen: Shows detailed information about selected movies or shows.
* Favorites: Users can add movies or shows to their favorites list.
* Offline Support: Caches API responses using CoreData for offline access.
* Biometric Authentication: Uses biometrics for quick login if the user is already authenticated.

## Design Patterns and Architecture
The application follows the MVVM design pattern with elements of Clean architecture:
* ViewController: Manages the UI and user interactions.
* ViewModel: Provides data and logic to the ViewController.
* Repository: Handles data operations, checking network reachability, and deciding whether to fetch data from the network or cache.
* Network Layer: Manages network requests using URLSession.
* CoreData: Used for caching and offline support.

## Selected Challenges
1. Advanced Networking and Data Handling
* Scalable Networking Layer: Implemented a fault-tolerant networking layer to handle concurrent connections and network disruptions.
* Custom Data Caching and Synchronization: Developed caching strategies based on network conditions and device resources.
* Advanced Data Serialization: Used efficient data transmission techniques to optimize performance.

2. Secure Authentication and User Management
* Multi-Factor Authentication: Integrated biometric authentication alongside OAuth 2.0.
* Encryption: Ensured access token saved in keychain for security.
* OAuth 2.0: Used AppAuth pod for seamless third-party authentication.

3. Robust Database Integration and Offline Support
* Distributed Database Integration: Utilized CoreData for local caching and synchronization.
* Adaptive Offline Synchronization: Implemented mechanisms to prioritize data sync based on user activity and network conditions.
* Conflict Resolution Strategies: Ensured duplication isn't there every time a new item saved.

## Installation
1. Clone the repository:
```
git clone https://github.com/ahmedsallamdd/TMDBMovieApp
cd TMDBMovieApp
```
2. Install dependencies:
```
pod install
```
3. Open the project:
```
open TMDBMovieApp.xcworkspace
```

## Usage
1. Login: Open the app and log in using your Google account.
2. Home Screen: Browse through the list of movies and TV shows.
3. Details Screen: Tap on any movie or show to view its details.
4. Add to Favorites: Tap the favorite button to add the item to your favorites list.
5. Offline Mode: Access previously viewed movies or shows even without an internet connection.

## Conclusion
TMDBMovieApp demonstrates advanced mobile development techniques, including secure authentication, robust networking, and offline support. The use of MVVM and Clean architecture ensures maintainable and scalable code. The application provides a seamless user experience with features like biometric authentication and adaptive data synchronization.
Contact
For any questions or support, please contact [ahmedsallamdd@gmail.com].
