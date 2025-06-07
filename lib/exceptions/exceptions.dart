/// Base exception class for the application.
abstract class AppException implements Exception {
  /// Creates a new instance of [AppException].
  const AppException(this.message);

  /// The error message.
  final String message;

  @override
  String toString() => message;
}

/// Exception thrown when authentication fails.
class AuthenticationException extends AppException {
  /// Creates a new instance of [AuthenticationException].
  const AuthenticationException([
    super.message = 'Authentication failed',
  ]);
}

/// Exception thrown when credentials are missing.
class MissingCredentialsException extends AppException {
  /// Creates a new instance of [MissingCredentialsException].
  const MissingCredentialsException([
    super.message = 'Missing credentials',
  ]);
}

/// Exception thrown when the web page fails to load.
class WebPageLoadException extends AppException {
  /// Creates a new instance of [WebPageLoadException].
  const WebPageLoadException([
    super.message = 'Failed to load web page',
  ]);
}

/// Exception thrown when JavaScript execution fails.
class JavaScriptExecutionException extends AppException {
  /// Creates a new instance of [JavaScriptExecutionException].
  const JavaScriptExecutionException([
    super.message = 'Failed to execute JavaScript',
  ]);
} 