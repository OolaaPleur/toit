# Toit App

A Flutter application for automating login to the Toit system.

## Features

- Automatic login to Toit system
- Save and manage login credentials
- Support for both light and dark themes
- Modern Material Design 3 UI

## Getting Started

### Prerequisites

- Flutter 3.x
- Dart SDK ^3.7.2

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/toit.git
   ```

2. Navigate to the project directory:
   ```bash
   cd toit
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## Configuration

1. Open the app and go to Settings
2. Enter your Toit code and password
3. Save the credentials
4. Return to the main screen and use the refresh button to auto-login

## Development

The project follows Clean Architecture principles and uses:
- BLoC for state management
- GetIt for dependency injection
- GoRouter for navigation
- Dio for HTTP requests
- FlexColorScheme for theming

## License

This project is proprietary and confidential.
