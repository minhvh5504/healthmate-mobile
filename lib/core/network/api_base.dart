import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiBaseDev {
  static String get baseUrlDevelopment => dotenv.env['BASE_URL_DEV'] ?? '';
}

class ApiBaseProd {
  static String get baseUrlProduction => dotenv.env['BASE_URL_PROD'] ?? '';
}

class ApiSocket {
  static String get urlNotifications =>
      dotenv.env['SOCKET_URL_NOTIFICATIONS'] ?? '';
}

class ApiKey {
  static String get googleApiKey => dotenv.env['GOOGLE_API_KEY'] ?? '';

  static String get firebaseApiKey => dotenv.env['FIREBASE_API_KEY'] ?? '';

  static String get mapboxPublicToken =>
      dotenv.env['MAPBOX_PUBLIC_TOKEN'] ?? '';

  static String get goongBaseUrl => 'https://rsapi.goong.io';
  static String get goongApiKey => dotenv.env['GOONG_API_KEY'] ?? '';
  static String get goongMaptilesKey => dotenv.env['GOONG_MAPTILES_KEY'] ?? '';
}
