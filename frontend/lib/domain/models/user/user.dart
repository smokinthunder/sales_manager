enum UserType { areaManager, executive }

class AppUser {
  final String id;
  final UserType type;
  AppUser({required this.id, required this.type});
}
