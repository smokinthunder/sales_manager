enum UserType {
  areaManager("areaManager", "Area Manager"),
  executive("executive", "Executive");

  final String typeName;
  final String displayName;
  const UserType(this.typeName, this.displayName);

  @override
  String toString() => displayName;

  static UserType fromBackend(String role) {
    switch (role) {
      case "area_manager":
        return UserType.areaManager;
      case "sales_executive":
        return UserType.executive;
      default:
        throw ArgumentError("Unsupported role: $role");
    }
  }
}

class AppUser {
  final String id;
  // final String firstName;
  // final String lastName;
  final String name;
  final String email;
  final String phoneNumber;
  final String pictureUrl;
  final String location;
  final UserType type;

  AppUser({
    // required this.lastName,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.pictureUrl,
    required this.id,
    required this.type,
    // required this.firstName,
    required this.location,
  });

  /// Named constructor for an empty/default user
  factory AppUser.empty() {
    return AppUser(
      id: "",
      type: UserType.executive,
      // firstName: "",
      // lastName: "",
      name: "",
      email: "",
      phoneNumber: "",
      pictureUrl: "",
      location: "",
    );
  }
}
