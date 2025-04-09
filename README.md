# Space Launch Atlas

Space Launch Atlas is a cross-platform app for tracking upcoming space launches, available in two flavors: a React Native mobile app and a Flutter app (with web deployment on Vercel). Explore mission details, filter launches, and follow real-time countdowns, all powered by The Space Devs API.

## Overview

- **Cross-Platform Experience:**  
  Enjoy the same intuitive and immersive experience on both mobile and web devices. The application is developed using two popular frameworks:
  - **React Native Mobile App:** For a smooth, native-like mobile experience on both iOS and Android.
  - **Flutter App:** For the web, deployed using Firebase, ensuring high performance and a responsive design across all devices.

- **Real-Time Space Launch Information:**  
  Utilize data powered by [The Space Devs API](https://thespacedevs.com/) to explore detailed mission information, filter launches according to your preferences, and follow real-time countdowns to lift-off.

## Key Features

- **Mission Details:**  
  Explore comprehensive details about each space mission including launch site, payload specifics, and mission objectives.

- **Launch Filtering:**  
  Efficiently sort and filter upcoming space launches based on criteria such as date, rocket type, and mission provider.

- **Real-Time Countdown:**  
  Engage with live countdowns to launches, ensuring you never miss an upcoming event.

- **Cross-Platform Deployment:**  
  - **React Native:** Enjoy a full-featured mobile app experience that runs on both iOS and Android devices.
  - **Flutter + Firebase:** Experience a fast, responsive web app powered by Flutter and deployed on Firebase.

## Technologies & Tools

- **Frontend:**  
  - [React Native](https://reactnative.dev/) for mobile app development.
  - [Flutter](https://flutter.dev/) for building the web app version.
  
- **Deployment:**  
  - Mobile apps are distributed through platform-specific app stores.
  - Web deployment is handled via [Firebase Hosting](https://firebase.google.com/docs/hosting), ensuring seamless scaling and high performance.

- **API Integration:**  
  - All space-related data is fetched from [The Space Devs API](https://thespacedevs.com/), which aggregates mission-critical data from various space agencies and commercial providers.

## Getting Started

### Prerequisites

- **Node.js & npm:** Required for React Native development.  
- **Flutter SDK:** For building and running the Flutter web app.
- **Firebase CLI:** To deploy the Flutter web app on Firebase Hosting.

### Installation

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/your-username/space-launch-tracker.git
   cd space-launch-tracker
   ```

2. **Setting Up the React Native Mobile App:**
   - Navigate to the React Native folder:
     ```bash
     cd mobile
     ```
   - Install dependencies:
     ```bash
     npm install
     ```
   - Run on your emulator or physical device:
     ```bash
     npm run ios  # For iOS
     npm run android  # For Android
     ```

3. **Setting Up the Flutter Web App:**
   - Navigate to the Flutter folder:
     ```bash
     cd flutter
     ```
   - Install dependencies:
     ```bash
     flutter pub get
     ```
   - Run the web app:
     ```bash
     flutter run -d chrome
     ```

4. **Deployment on Firebase:**
   - Build your Flutter web app:
     ```bash
     flutter build web
     ```
   - Deploy using Firebase CLI:
     ```bash
     firebase login
     firebase init hosting  # Configure your project and select the build/web directory as your public root.
     firebase deploy
     ```

## Usage

After starting the application on either platform, users can:
- Browse detailed information on upcoming space launches.
- Filter and sort launch events based on specific criteria.
- View live countdowns to each launch, ensuring timely updates on launch events.

## Contributing

Contributions are welcome! If you have suggestions, improvements, or bug fixes:
1. Fork the repository.
2. Create a new feature branch.
3. Commit your changes and open a pull request.

## License

Distributed under the MIT License. See `LICENSE` for more information.

## Acknowledgements

- **The Space Devs API:** For powering the space mission data.  
- **React Native and Flutter communities:** For providing robust frameworks and support.
- **Firebase:** For seamless web deployment and reliable hosting.