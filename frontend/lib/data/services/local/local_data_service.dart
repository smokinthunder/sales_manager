import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:sales_manager/config/assets.dart';
import 'package:sales_manager/data/services/local/models/login_response.dart';
import 'package:sales_manager/utils/result.dart';

import 'models/login_request.dart';

class LocalDataService {
  /// checks if the phone number is registered
  Future<bool> isPhoneRegistered(String phoneNumber) async {
    final json = await _loadStringAsset(Assets.localAuthData);
    final List<LoginRequest> localLoginData = json
        .map<LoginRequest>(LoginRequest.fromJson)
        .toList();
    return localLoginData.any(
      (loginRequest) => loginRequest.phoneNumber == phoneNumber,
    );
  }

  /// validates the input with the values in local asset
  Future<Result<LoginResponse>> loginWithOtp(LoginRequest loginRequest) async {
    final json = await _loadStringAsset(Assets.localAuthData);
    final List<LoginRequest> localLoginData = json
        .map<LoginRequest>(LoginRequest.fromJson)
        .toList();
    final userDataJson = await _loadStringAsset(Assets.localUserData);
    final List<LoginResponse> localUserData = userDataJson
        .map<LoginResponse>(LoginResponse.fromJson)
        .toList();
    if (localLoginData.contains(loginRequest)) {
      final userData = localUserData.firstWhere(
        (user) => user.phoneNumber == loginRequest.phoneNumber,
      );
      return Result.ok(userData);
    } else {
      return Result.error(Exception("Credentials didn't match"));
    }
  }

  /// Loads json assets from the input folder and convert to List of Map
  Future<List<Map<String, dynamic>>> _loadStringAsset(String asset) async {
    final localData = await rootBundle.loadString(asset);
    return (jsonDecode(localData) as List).cast<Map<String, dynamic>>();
  }
}
