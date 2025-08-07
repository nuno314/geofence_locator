import 'package:flutter_test/flutter_test.dart';
import 'package:geofence_locator/repositories/location_repository.dart';
import 'package:geofence_locator/models/location.dart';

void main() {
  group('LocationRepository', () {
    late LocationRepository repository;

    setUp(() {
      repository = LocationRepositoryImpl();
    });

    test('should get locations from storage', () async {
      final locations = await repository.getLocations();
      expect(locations, isA<List<Location>>());
    });

    test('should fetch locations from backend', () async {
      final locations = await repository.fetchLocationsFromBackend();
      expect(locations, isA<List<Location>>());
      expect(locations.isNotEmpty, isTrue);
    });

    test('should save locations', () async {
      final testLocations = [
        Location(
          id: '1',
          name: 'Test Location',
          address: 'Test Address',
          latitude: 10.0,
          longitude: 20.0,
          radius: 100,
          description: 'Test Description',
          createdAt: DateTime.now(),
        ),
      ];

      await repository.saveLocations(testLocations);
      final savedLocations = await repository.getLocations();

      expect(savedLocations.length, equals(1));
      expect(savedLocations[0].id, equals('1'));
      expect(savedLocations[0].name, equals('Test Location'));
    });

    test('should update location status', () async {
      final testLocation = Location(
        id: '1',
        name: 'Test Location',
        address: 'Test Address',
        latitude: 10.0,
        longitude: 20.0,
        radius: 100,
        description: 'Test Description',
        createdAt: DateTime.now(),
      );

      await repository.saveLocations([testLocation]);
      await repository.updateLocationStatus('1', false);

      final locations = await repository.getLocations();
      expect(locations[0].isActive, isFalse);
    });

    test('should handle empty locations list', () async {
      final locations = await repository.getLocations();
      expect(locations, isEmpty);
    });
  });
}
