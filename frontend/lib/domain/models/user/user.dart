enum UserType { areaManager, executive }

class AppUser {
  final String name;
  final String id;
  final UserType type;
  AppUser({required this.id, required this.type, required this.name});
  String userTypetoString() {
    switch (type) {
      case UserType.areaManager:
        return "Area Manager";
      case UserType.executive:
        return "Executive";
    }
  }
}
