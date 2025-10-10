import 'package:flutter_test/flutter_test.dart';
import 'package:sales_manager/domain/models/user/user.dart';
import 'package:sales_manager/domain/models/user/user_role.dart';
import 'package:sales_manager/domain/models/user/user_status.dart';

void main() {
  group('AppUser', () {
    test('should create user with territoryId', () {
      const territoryId = 'TER_001';
      final user = AppUser(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        phoneNumber: '+1234567890',
        pictureUrl: '',
        location: 'Location',
        role: UserRole.salesExecutive,
        status: UserStatus.active,
        territoryId: territoryId,
      );

      expect(user.territoryId, equals(territoryId));
      expect(user.hasTerritory, isTrue);
    });

    test('should create user without territoryId', () {
      final user = AppUser(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        phoneNumber: '+1234567890',
        pictureUrl: '',
        location: 'Location',
        role: UserRole.salesExecutive,
        status: UserStatus.active,
        territoryId: null,
      );

      expect(user.territoryId, isNull);
      expect(user.hasTerritory, isFalse);
    });

    test('should create user with empty territoryId', () {
      final user = AppUser(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        phoneNumber: '+1234567890',
        pictureUrl: '',
        location: 'Location',
        role: UserRole.salesExecutive,
        status: UserStatus.active,
        territoryId: '',
      );

      expect(user.territoryId, equals(''));
      expect(user.hasTerritory, isFalse);
    });

    test('empty user factory should have null territoryId', () {
      final user = AppUser.empty();

      expect(user.territoryId, isNull);
      expect(user.hasTerritory, isFalse);
    });

    test('hasTerritory should return true only for non-empty territoryId', () {
      final userWithTerritory = AppUser(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        phoneNumber: '+1234567890',
        pictureUrl: '',
        location: 'Location',
        role: UserRole.salesExecutive,
        status: UserStatus.active,
        territoryId: 'TER_001',
      );

      final userWithoutTerritory = AppUser(
        id: '2',
        name: 'Jane Doe',
        email: 'jane@example.com',
        phoneNumber: '+1234567891',
        pictureUrl: '',
        location: 'Location',
        role: UserRole.salesExecutive,
        status: UserStatus.active,
        territoryId: null,
      );

      final userWithEmptyTerritory = AppUser(
        id: '3',
        name: 'Bob Smith',
        email: 'bob@example.com',
        phoneNumber: '+1234567892',
        pictureUrl: '',
        location: 'Location',
        role: UserRole.salesExecutive,
        status: UserStatus.active,
        territoryId: '',
      );

      expect(userWithTerritory.hasTerritory, isTrue);
      expect(userWithoutTerritory.hasTerritory, isFalse);
      expect(userWithEmptyTerritory.hasTerritory, isFalse);
    });
  });
}