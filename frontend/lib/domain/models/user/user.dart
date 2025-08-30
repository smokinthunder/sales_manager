
import 'package:sales_manager/domain/models/user/user_role.dart';
import 'package:sales_manager/domain/models/user/user_status.dart';

class AppUser {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String pictureUrl;
  final String location;
  final UserRole role;
  final UserStatus status;

  AppUser({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.pictureUrl,
    required this.id,
    required this.role,
    required this.location,
    required this.status,
  });

  /// Named constructor for an empty/default user
  factory AppUser.empty() {
    return AppUser(
      id: "",
      role: UserRole.salesExecutive,
      name: "",
      email: "",
      phoneNumber: "",
      pictureUrl: "",
      location: "",
      status: UserStatus.active,
    );
  }
}
