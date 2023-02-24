import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment{
  static String get apiScheme => dotenv.get('API_SCHEME', fallback: 'http');
  static String get apiHost => dotenv.get('API_HOST', fallback: '10.0.2.2');
  static int get apiPort => int.parse(dotenv.get('API_PORT', fallback: '1024'));
  static String get apiEndpoint => dotenv.get('API_ENDPOINT', fallback: '/api');

  static Uri uri = Uri(scheme: apiScheme, host: apiHost, port: apiPort, path: apiEndpoint);
}