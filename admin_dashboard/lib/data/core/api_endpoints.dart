import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  static final String _ipAddr = dotenv.env['IP_ADDR'] ?? "192.168.63.132";
  static final String _baseUrl = "http://$_ipAddr:8000/";
  static final String _apiUrl = "${_baseUrl}api/v1/";

  // End Points

  // Email Auth Apis
  static final String _emailAuthApi = "${_apiUrl}auth/email/";
  static final String emailLogin = "${_emailAuthApi}login";
  static final String emailForgotPassword = "${_emailAuthApi}forgot-password";
  static final String emailResetPassword = "${_emailAuthApi}reset-password";
  static final String emailChangePassword = "${_emailAuthApi}change-password";
  static final String emailCheckEmail = "${_emailAuthApi}check-email";
}
