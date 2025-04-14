# Toit App Internals

## Architecture

The app follows Clean Architecture principles with the following layers:

1. **Presentation Layer**

   - Screens: Main screen (WebView) and Settings screen
   - Widgets: Reusable UI components
   - BLoC: State management for each feature

2. **Domain Layer**

   - Entities: Core business objects
   - Repositories: Abstract interfaces
   - Use Cases: Business logic

3. **Data Layer**
   - Repositories: Concrete implementations
   - Data Sources: Local (SharedPreferences) and Remote (WebView)

## Key Components

### WebView Integration

- Uses `flutter_inappwebview` for web page interaction
- Implements JavaScript injection for automated login
- Handles button clicks and form submissions

### State Management

- Uses BLoC pattern with `flutter_bloc`
- Separates UI logic from business logic
- Manages loading states and error handling

### Navigation

- Uses `go_router` for routing
- Implements deep linking support
- Handles navigation state management

### Storage

- Uses `shared_preferences` for credential storage
- Implements secure storage practices
- Manages user preferences

## Future Improvements

1. Add biometric authentication
2. Implement offline mode
3. Add error reporting
4. Improve performance monitoring
5. Add automated tests
