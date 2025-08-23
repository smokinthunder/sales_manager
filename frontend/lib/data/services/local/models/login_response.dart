import 'package:sales_manager/domain/models/user/user.dart';

class LoginResponse {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String picture;
  final UserType type;
  const LoginResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.picture,
    required this.type,
  });
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      id: json['id'] as String,
      firstName: json['firstname'] as String,
      lastName: json['lastname'] as String,
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String,
      picture: json['picture'] as String,
      type: UserType.values.firstWhere(
        (e) => e.typeName == json['type'] as String,
      ),
    );
  }
}
