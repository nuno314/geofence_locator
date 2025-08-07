import 'package:flutter_test/flutter_test.dart';
import 'package:geofence_locator/services/storage_service.dart';
import 'package:geofence_locator/models/location.dart';
import 'package:geofence_locator/models/geofence_event.dart';

void main() {
  group('StorageService', () {
    late StorageService storageService;

    setUpAll(() {
      // Initialize Flutter binding for SharedPreferences
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    setUp(() {
      storageService = StorageService();
    });

    tearDown(() async {
      // Clean up after each test
      await storageService.clearAllEvents();
      await storageService.clearAllJobs();
    });

    test('should save and retrieve locations', () async {
      final locations = [
        Location(
          id: '1',
          name: 'Test Location 1',
          address: 'Test Address 1',
          latitude: 10.0,
          longitude: 20.0,
          radius: 100,
          description: 'Test Description 1',
          createdAt: DateTime.now(),
        ),
        Location(
          id: '2',
          name: 'Test Location 2',
          address: 'Test Address 2',
          latitude: 15.0,
          longitude: 25.0,
          radius: 150,
          description: 'Test Description 2',
          createdAt: DateTime.now(),
        ),
      ];

      await storageService.saveLocations(locations);
      final retrieved = await storageService.loadLocations();

      expect(retrieved.length, equals(2));
      expect(retrieved[0].id, equals('1'));
      expect(retrieved[0].name, equals('Test Location 1'));
      expect(retrieved[1].id, equals('2'));
      expect(retrieved[1].name, equals('Test Location 2'));
    });

    test('should save and retrieve geofence events', () async {
      final events = [
        GeofenceEvent(
          id: '1',
          locationId: 'loc1',
          locationName: 'Test Location',
          eventType: EventType.enter,
          latitude: 10.0,
          longitude: 20.0,
          timestamp: DateTime.now(),
        ),
        GeofenceEvent(
          id: '2',
          locationId: 'loc1',
          locationName: 'Test Location',
          eventType: EventType.exit,
          latitude: 10.0,
          longitude: 20.0,
          timestamp: DateTime.now(),
        ),
      ];

      await storageService.saveEvents(events);
      final retrieved = await storageService.loadEvents();

      expect(retrieved.length, equals(2));
      expect(retrieved[0].id, equals('1'));
      expect(retrieved[0].eventType, equals(EventType.enter));
      expect(retrieved[1].id, equals('2'));
      expect(retrieved[1].eventType, equals(EventType.exit));
    });

    test('should return empty list when no locations saved', () async {
      final locations = await storageService.loadLocations();
      expect(locations, isEmpty);
    });

    test('should return empty list when no events saved', () async {
      final events = await storageService.loadEvents();
      expect(events, isEmpty);
    });

    test('should update location status', () async {
      final location = Location(
        id: '1',
        name: 'Test Location',
        address: 'Test Address',
        latitude: 10.0,
        longitude: 20.0,
        radius: 100,
        description: 'Test Description',
        createdAt: DateTime.now(),
      );

      await storageService.saveLocations([location]);
      await storageService.updateLocationStatus('1', false);

      final locations = await storageService.loadLocations();
      expect(locations[0].isActive, isFalse);
    });

    test('should add new event', () async {
      final event = GeofenceEvent(
        id: '1',
        locationId: 'loc1',
        locationName: 'Test Location',
        eventType: EventType.enter,
        latitude: 10.0,
        longitude: 20.0,
        timestamp: DateTime.now(),
      );

      await storageService.addEvent(event);
      final events = await storageService.loadEvents();

      expect(events.length, equals(1));
      expect(events[0].id, equals('1'));
      expect(events[0].eventType, equals(EventType.enter));
    });

    test('should get events for specific location', () async {
      final events = [
        GeofenceEvent(
          id: '1',
          locationId: 'loc1',
          locationName: 'Test Location 1',
          eventType: EventType.enter,
          latitude: 10.0,
          longitude: 20.0,
          timestamp: DateTime.now(),
        ),
        GeofenceEvent(
          id: '2',
          locationId: 'loc2',
          locationName: 'Test Location 2',
          eventType: EventType.exit,
          latitude: 15.0,
          longitude: 25.0,
          timestamp: DateTime.now(),
        ),
      ];

      await storageService.saveEvents(events);
      final loc1Events = await storageService.getEventsForLocation('loc1');
      final loc2Events = await storageService.getEventsForLocation('loc2');

      expect(loc1Events.length, equals(1));
      expect(loc1Events[0].locationId, equals('loc1'));
      expect(loc2Events.length, equals(1));
      expect(loc2Events[0].locationId, equals('loc2'));
    });

    test('should get recent events', () async {
      final events = [
        GeofenceEvent(
          id: '1',
          locationId: 'loc1',
          locationName: 'Test Location',
          eventType: EventType.enter,
          latitude: 10.0,
          longitude: 20.0,
          timestamp: DateTime.now(),
        ),
        GeofenceEvent(
          id: '2',
          locationId: 'loc1',
          locationName: 'Test Location',
          eventType: EventType.exit,
          latitude: 10.0,
          longitude: 20.0,
          timestamp: DateTime.now().subtract(const Duration(days: 31)),
        ),
      ];

      await storageService.saveEvents(events);
      final recentEvents = await storageService.getRecentEvents();

      expect(recentEvents.length, equals(1));
      expect(recentEvents[0].id, equals('1'));
    });

    test('should clear all events', () async {
      final events = [
        GeofenceEvent(
          id: '1',
          locationId: 'loc1',
          locationName: 'Test Location',
          eventType: EventType.enter,
          latitude: 10.0,
          longitude: 20.0,
          timestamp: DateTime.now(),
        ),
      ];

      await storageService.saveEvents(events);
      await storageService.clearAllEvents();

      final retrieved = await storageService.loadEvents();
      expect(retrieved, isEmpty);
    });

    test('should get events by date range', () async {
      final now = DateTime.now();
      final events = [
        GeofenceEvent(
          id: '1',
          locationId: 'loc1',
          locationName: 'Test Location',
          eventType: EventType.enter,
          latitude: 10.0,
          longitude: 20.0,
          timestamp: now,
        ),
        GeofenceEvent(
          id: '2',
          locationId: 'loc1',
          locationName: 'Test Location',
          eventType: EventType.exit,
          latitude: 10.0,
          longitude: 20.0,
          timestamp: now.subtract(const Duration(days: 5)),
        ),
      ];

      await storageService.saveEvents(events);
      final rangeEvents = await storageService.getEventsByDateRange(
        now.subtract(const Duration(days: 3)),
        now.add(const Duration(days: 1)),
      );

      expect(rangeEvents.length, equals(1));
      expect(rangeEvents[0].id, equals('1'));
    });
  });
}
