class AppConfig {
  static const ANDROID_APIKEY = String.fromEnvironment('API_KEY_ANDROID');
  static const WEB_APIKEY = String.fromEnvironment('API_KEY_WEB');
  static const WINDOWS_APIKEY = String.fromEnvironment('API_KEY_WINDOWS');
  static const APP_ID = String.fromEnvironment('APP_ID');
  static const MESSAGE_SENDING_ID = String.fromEnvironment(
    'MESSAGE_SENDING_ID',
  );
  static const PROJECT_ID = String.fromEnvironment('PROJECT_ID');
  static const STORAGE_BUCKET = String.fromEnvironment('STORAGE_BUCKET');
}
