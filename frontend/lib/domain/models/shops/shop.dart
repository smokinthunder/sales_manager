class Shop {
  final String id;
  final String name;
  final String location;
  final String phoneNumber;
  final int points;
  final bool needsVisiting;
  final DateTime lastVisted;
  Shop({
    this.needsVisiting = false,
    required this.id,
    required this.name,
    required this.location,
    required this.phoneNumber,
    required this.points,
    required this.lastVisted,
  });
}
