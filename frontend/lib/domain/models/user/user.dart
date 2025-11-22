
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
  final String? territoryId;

  AppUser({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.pictureUrl,
    required this.id,
    required this.role,
    required this.location,
    required this.status,
    this.territoryId,
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
      territoryId: null,
    );
  }

  /// Check if user has a territory assigned
  bool get hasTerritory => territoryId != null && territoryId!.isNotEmpty;
}
