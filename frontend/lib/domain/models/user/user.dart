enum UserType {
  areaManager("areaManager", "Area Manager"),
  executive("executive", "Executive");

  final String typeName;
  final String displayName;
  const UserType(this.typeName, this.displayName);

  @override
  String toString() => displayName;
}

class AppUser {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String pictureUrl;

  final UserType type;
  AppUser({
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.pictureUrl,
    required this.id,
    required this.type,
    required this.firstName,
  });
}
