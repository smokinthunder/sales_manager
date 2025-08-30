import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  static final String _ipAddr = dotenv.env['IP_ADDR'] ?? "192.168.63.132";
  static final String _baseUrl = "http://$_ipAddr:8000/";
  static final String _apiUrl = "${_baseUrl}api/v1/";

  // End Points

  //Auth Apis
  static final String _authApi = "${_apiUrl}auth/";
  static final String generateOtp = "${_authApi}otp/generate";
  static final String verifyOtp = "${_authApi}otp/verify";
  static final String refreshToken = "${_authApi}token/refresh";
  static final String logout = "${_authApi}logout";
  static final String getCurrentUser = "${_authApi}me";

  //User Apis
  static final String _userApi = "${_apiUrl}users/";
  static final String getUserProfile = "${_userApi}profile/me";
}
