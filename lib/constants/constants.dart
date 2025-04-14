/// Application-wide constants.
class AppConstants {
  /// Private constructor to prevent instantiation.
  AppConstants._();

  /// The base URL for the Toit application.
  static const String baseUrl = 'https://toit.thermory.com/et';

  /// The key for storing the code in SharedPreferences.
  static const String codeKey = 'code';

  /// The key for storing the password in SharedPreferences.
  static const String passwordKey = 'password';

  /// The delay between button clicks during auto-login (in milliseconds).
  static const int buttonClickDelay = 100;

  /// The delay after clicking the OK button (in milliseconds).
  static const int okButtonDelay = 300;
}
