class ApiEndpoints {
  // Should change this wrt your network
  static const String _ipAddr = "192.168.63.95";
  static const String _baseUrl = "http://$_ipAddr:8000/";
  static const String _apiUrl = "${_baseUrl}api/v1/";

  // End Points

  //Auth Apis
  static const String _authApi = "${_apiUrl}auth/";
  static const String generateOtp = "${_authApi}otp/generate";
  static const String verifyOtp = "${_authApi}otp/verify";
  static const String refreshToken = "${_authApi}token/refresh";
  static const String logout = "${_authApi}logout";
  static const String userProfile = "${_authApi}me";
}
