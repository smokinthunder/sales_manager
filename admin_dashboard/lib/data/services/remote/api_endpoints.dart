import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndPoints {
  static final String _ipAddr = dotenv.env['IP_ADDR'] ?? "192.168.63.132";
  static final String _baseUrl = "http://$_ipAddr:8000/";
  static final String _apiUrl = "${_baseUrl}api/v1/";

  //Auth Apis
  static final String _emailauth = "${_apiUrl}auth/email/";
  static final String login = "${_emailauth}login";
  static final String _authApi = "${_apiUrl}auth/";
  static final String refreshToken = "${_authApi}token/refresh";
  static final String logout = "${_authApi}logout";
  static final String getCurrentUser = "${_authApi}me";
}
