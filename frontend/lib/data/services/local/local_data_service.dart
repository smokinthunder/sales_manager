import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:sales_manager/config/assets.dart';
import 'package:sales_manager/utils/result.dart';

import 'models/login_request/login_request.dart';

class LocalDataService {

  /// validates the input with the values in local asset
  Future<Result<String>> loginWithOtp(LoginRequest loginRequest) async {
    final json = await _loadStringAsset(Assets.localAuthData);
    final List<LoginRequest> localLoginData = json
        .map<LoginRequest>(LoginRequest.fromJson)
        .toList();
    if (localLoginData.contains(loginRequest)) {
      return Result.ok("logged In");
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
