import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment{
  static String get apiScheme => dotenv.get('API_SCHEME', fallback: 'http');
  static String get apiHost => dotenv.get('API_HOST', fallback: '10.0.2.2');
  static int get apiPort => int.parse(dotenv.get('API_PORT', fallback: '1024'));

  static String get apiEndpoint1 => dotenv.get('API_ENDPOINT', fallback: '/api1');
  static String get apiEndpoint2 => dotenv.get('API_ENDPOINT2', fallback: '/api2');
  static String get loginEndpoint => dotenv.get('API_ENDPOINT_USER', fallback: '/api');
  static String get uploadEndpoint => dotenv.get('API_ENDPOINT_UPLOAD_IMAGE', fallback: '/api');
  static String get digestEndpoint => dotenv.get('API_ENDPOINT_DIGEST', fallback: '/api');
  static String get searchEndpoint => dotenv.get('API_ENDPOINT_SEARCH', fallback: '/api');
  static String get searchEndpointById => dotenv.get('API_ENDPOINT_SEARCH2', fallback: '/api');

  /*
  //Local
  static Uri uri1 = Uri(scheme: apiScheme, host: apiHost, port: apiPort, path: apiEndpoint1);
  static Uri uri2 = Uri(scheme: apiScheme, host: apiHost, port: apiPort, path: apiEndpoint2);
  static Uri uriLogin = Uri(scheme: apiScheme, host: apiHost, port: apiPort, path: loginEndpoint);
  static Uri uriDigest = Uri(scheme: apiScheme, host: apiHost, port: apiPort, path: digestEndpoint);
  */

  //Online
  static Uri uri1 = Uri(scheme: apiScheme, host: apiHost, path: apiEndpoint1);
  static Uri uri2 = Uri(scheme: apiScheme, host: apiHost, path: apiEndpoint2);
  static Uri uriLogin = Uri(scheme: apiScheme, host: apiHost, path: loginEndpoint);
  static Uri uriDigest = Uri(scheme: apiScheme, host: apiHost, path: digestEndpoint);

  Uri getUriUploadImage(int id, String digest, String path, String fileName){
    return Uri(scheme: apiScheme, host: apiHost, path: uploadEndpoint + id.toString(), queryParameters: {
      'digest': digest,
      'filePath': path,
      'fileName': fileName
    });
  }

  Uri getUriSearch(String code){
    return Uri(scheme: apiScheme, host: apiHost, path: searchEndpoint + "/" + code);
  }

  Uri getUriSearchForId(String id){
    return Uri(scheme: apiScheme, host: apiHost, path: searchEndpointById + "/" + id);
  }

}