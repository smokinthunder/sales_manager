class Shop {
  final String id;
  final String name;
  final String location;
  final String phoneNumber;
  final String logoUrl;
  final int points;
  final DateTime lastVisted;

  /// Indicates if the shop needs to be visited : to be placed in not visited list if true, else visited shops
  final bool needsVisiting;
  final bool isNewShop;
  final bool isBestCustomer;

  Shop({
    this.isBestCustomer = false,
    this.isNewShop = false,
    required this.logoUrl,
    this.needsVisiting = false,
    required this.id,
    required this.name,
    required this.location,
    required this.phoneNumber,
    required this.points,
    required this.lastVisted,
  });
}

final List<Shop> testShops = [
  Shop(
    id: '1',
    name: 'SuperMart',
    location: '123 Main St',
    phoneNumber: '555-1234',
    logoUrl: 'https://example.com/logos/supermart.png',
    points: 120,
    needsVisiting: true,
    isNewShop: true,
    lastVisted: DateTime.now().subtract(Duration(days: 2)),
  ),
  Shop(
    id: '2',
    name: 'FreshFoods',
    location: '456 Market Ave',
    phoneNumber: '555-5678',
    logoUrl: 'https://example.com/logos/freshfoods.png',
    points: 80,
    needsVisiting: false,
    lastVisted: DateTime.now().subtract(Duration(days: 5)),
  ),
  Shop(
    id: '3',
    name: 'TechZone',
    location: '789 Tech Blvd',
    phoneNumber: '555-9012',
    logoUrl: 'https://example.com/logos/techzone.png',
    points: 200,
    needsVisiting: true,
    lastVisted: DateTime.now().subtract(Duration(days: 1)),
  ),
  Shop(
    id: '4',
    name: 'BookNook',
    location: '321 Book St',
    phoneNumber: '555-3456',
    isBestCustomer: true,
    logoUrl: 'https://example.com/logos/booknook.png',
    points: 60,
    needsVisiting: false,
    lastVisted: DateTime.now().subtract(Duration(days: 10)),
  ),
  Shop(
    id: '5',
    name: 'GadgetWorld',
    location: '654 Gadget Ave',
    phoneNumber: '555-7890',
    isNewShop: true,
    logoUrl: 'https://example.com/logos/gadgetworld.png',
    points: 150,
    needsVisiting: true,
    lastVisted: DateTime.now().subtract(Duration(days: 3)),
  ),
  Shop(
    id: '6',
    name: 'ClothCorner',
    location: '987 Fashion Blvd',
    isBestCustomer: true,
    phoneNumber: '555-2345',
    logoUrl: 'https://example.com/logos/clothcorner.png',
    points: 90,
    needsVisiting: false,
    lastVisted: DateTime.now().subtract(Duration(days: 7)),
  ),
];
