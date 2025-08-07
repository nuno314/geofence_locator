import 'package:flutter_test/flutter_test.dart';
import 'package:geofence_locator/models/location.dart';

void main() {
  group('Location Model', () {
    test('should create Location instance with all properties', () {
      final location = Location(
        id: '1',
        name: 'Test Location',
        address: 'Test Address',
        latitude: 10.0,
        longitude: 20.0,
        radius: 100,
        description: 'Test Description',
        createdAt: DateTime(2024, 1, 1),
      );

      expect(location.id, equals('1'));
      expect(location.name, equals('Test Location'));
      expect(location.address, equals('Test Address'));
      expect(location.latitude, equals(10.0));
      expect(location.longitude, equals(20.0));
      expect(location.radius, equals(100));
      expect(location.description, equals('Test Description'));
      expect(location.isActive, isTrue);
      expect(location.createdAt, equals(DateTime(2024, 1, 1)));
    });

    test('should convert to JSON and back', () {
      final location = Location(
        id: '1',
        name: 'Test Location',
        address: 'Test Address',
        latitude: 10.0,
        longitude: 20.0,
        radius: 100,
        description: 'Test Description',
        isActive: false,
        createdAt: DateTime(2024, 1, 1),
      );

      final json = location.toJson();
      final fromJson = Location.fromJson(json);

      expect(fromJson.id, equals(location.id));
      expect(fromJson.name, equals(location.name));
      expect(fromJson.address, equals(location.address));
      expect(fromJson.latitude, equals(location.latitude));
      expect(fromJson.longitude, equals(location.longitude));
      expect(fromJson.radius, equals(location.radius));
      expect(fromJson.description, equals(location.description));
      expect(fromJson.isActive, equals(location.isActive));
      expect(fromJson.createdAt.year, equals(location.createdAt.year));
      expect(fromJson.createdAt.month, equals(location.createdAt.month));
      expect(fromJson.createdAt.day, equals(location.createdAt.day));
    });

    test('should copy with new values', () {
      final original = Location(
        id: '1',
        name: 'Original Name',
        address: 'Original Address',
        latitude: 10.0,
        longitude: 20.0,
        radius: 100,
        description: 'Original Description',
        createdAt: DateTime(2024, 1, 1),
      );

      final copied = original.copyWith(name: 'New Name', isActive: false);

      expect(copied.id, equals(original.id));
      expect(copied.name, equals('New Name'));
      expect(copied.address, equals(original.address));
      expect(copied.latitude, equals(original.latitude));
      expect(copied.longitude, equals(original.longitude));
      expect(copied.radius, equals(original.radius));
      expect(copied.description, equals(original.description));
      expect(copied.isActive, isFalse);
      expect(copied.createdAt, equals(original.createdAt));
    });

    test('should have default isActive value', () {
      final location = Location(
        id: '1',
        name: 'Test Location',
        address: 'Test Address',
        latitude: 10.0,
        longitude: 20.0,
        radius: 100,
        description: 'Test Description',
        createdAt: DateTime(2024, 1, 1),
      );

      expect(location.isActive, isTrue);
    });
  });
}
