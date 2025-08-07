import 'package:flutter_test/flutter_test.dart';
import 'package:geofence_locator/models/geofence_event.dart';

void main() {
  group('GeofenceEvent Model', () {
    test('should create GeofenceEvent instance with all properties', () {
      final event = GeofenceEvent(
        id: '1',
        locationId: 'loc1',
        locationName: 'Test Location',
        eventType: EventType.enter,
        latitude: 10.0,
        longitude: 20.0,
        timestamp: DateTime(2024, 1, 1, 12, 0),
        notes: 'Test notes',
      );

      expect(event.id, equals('1'));
      expect(event.locationId, equals('loc1'));
      expect(event.locationName, equals('Test Location'));
      expect(event.eventType, equals(EventType.enter));
      expect(event.latitude, equals(10.0));
      expect(event.longitude, equals(20.0));
      expect(event.timestamp, equals(DateTime(2024, 1, 1, 12, 0)));
      expect(event.notes, equals('Test notes'));
    });

    test('should convert to JSON and back', () {
      final event = GeofenceEvent(
        id: '1',
        locationId: 'loc1',
        locationName: 'Test Location',
        eventType: EventType.exit,
        latitude: 10.0,
        longitude: 20.0,
        timestamp: DateTime(2024, 1, 1, 12, 0),
        notes: 'Test notes',
      );

      final json = event.toJson();
      final fromJson = GeofenceEvent.fromJson(json);

      expect(fromJson.id, equals(event.id));
      expect(fromJson.locationId, equals(event.locationId));
      expect(fromJson.locationName, equals(event.locationName));
      expect(fromJson.eventType, equals(event.eventType));
      expect(fromJson.latitude, equals(event.latitude));
      expect(fromJson.longitude, equals(event.longitude));
      expect(fromJson.timestamp.year, equals(event.timestamp.year));
      expect(fromJson.timestamp.month, equals(event.timestamp.month));
      expect(fromJson.timestamp.day, equals(event.timestamp.day));
      expect(fromJson.notes, equals(event.notes));
    });

    test('should return correct event type text', () {
      final enterEvent = GeofenceEvent(
        id: '1',
        locationId: 'loc1',
        locationName: 'Test Location',
        eventType: EventType.enter,
        latitude: 10.0,
        longitude: 20.0,
        timestamp: DateTime.now(),
      );

      final exitEvent = GeofenceEvent(
        id: '2',
        locationId: 'loc1',
        locationName: 'Test Location',
        eventType: EventType.exit,
        latitude: 10.0,
        longitude: 20.0,
        timestamp: DateTime.now(),
      );

      expect(enterEvent.eventTypeText, equals('Entered'));
      expect(exitEvent.eventTypeText, equals('Exited'));
    });

    test('should return correct event icon', () {
      final enterEvent = GeofenceEvent(
        id: '1',
        locationId: 'loc1',
        locationName: 'Test Location',
        eventType: EventType.enter,
        latitude: 10.0,
        longitude: 20.0,
        timestamp: DateTime.now(),
      );

      final exitEvent = GeofenceEvent(
        id: '2',
        locationId: 'loc1',
        locationName: 'Test Location',
        eventType: EventType.exit,
        latitude: 10.0,
        longitude: 20.0,
        timestamp: DateTime.now(),
      );

      expect(enterEvent.eventIcon, equals('→'));
      expect(exitEvent.eventIcon, equals('←'));
    });

    test('should handle null notes', () {
      final event = GeofenceEvent(
        id: '1',
        locationId: 'loc1',
        locationName: 'Test Location',
        eventType: EventType.enter,
        latitude: 10.0,
        longitude: 20.0,
        timestamp: DateTime.now(),
      );

      expect(event.notes, isNull);
    });
  });
}
