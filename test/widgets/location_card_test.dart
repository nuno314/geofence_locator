import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geofence_locator/widgets/location_card.dart';
import 'package:geofence_locator/models/location.dart';

void main() {
  group('LocationCard', () {
    late Location testLocation;
    late Position testPosition;

    setUp(() {
      testLocation = Location(
        id: '1',
        name: 'Test Location',
        address: 'Test Address',
        latitude: 10.0,
        longitude: 20.0,
        radius: 100,
        description: 'Test Description',
        createdAt: DateTime.now(),
      );

      testPosition = Position(
        latitude: 10.001, // Very close to location
        longitude: 20.001,
        timestamp: DateTime.now(),
        accuracy: 5.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0,
      );
    });

    testWidgets('should display location information', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LocationCard(
              location: testLocation,
              currentPosition: testPosition,
            ),
          ),
        ),
      );

      expect(find.text('Test Location'), findsOneWidget);
      expect(find.text('Test Address'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
      expect(find.text('100m'), findsOneWidget);
    });

    testWidgets('should show inside geofence when position is within radius', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LocationCard(
              location: testLocation,
              currentPosition: testPosition,
            ),
          ),
        ),
      );

      expect(find.text('✅ INSIDE GEOFENCE'), findsOneWidget);
      expect(find.byIcon(Icons.location_on), findsOneWidget);
    });

    testWidgets(
      'should show outside geofence when position is outside radius',
      (WidgetTester tester) async {
        final farPosition = Position(
          latitude: 11.0, // Far from location
          longitude: 21.0,
          timestamp: DateTime.now(),
          accuracy: 5.0,
          altitude: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
          altitudeAccuracy: 0.0,
          headingAccuracy: 0.0,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: LocationCard(
                location: testLocation,
                currentPosition: farPosition,
              ),
            ),
          ),
        );

        expect(find.text('❌ OUTSIDE GEOFENCE'), findsOneWidget);
        expect(find.byIcon(Icons.location_off), findsOneWidget);
      },
    );

    testWidgets('should display switch for active status', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LocationCard(
              location: testLocation,
              currentPosition: testPosition,
            ),
          ),
        ),
      );

      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('should handle null current position', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LocationCard(location: testLocation, currentPosition: null),
          ),
        ),
      );

      expect(find.text('Test Location'), findsOneWidget);
      expect(find.text('Test Address'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
      // Should not show distance info when position is null
      expect(find.text('Distance:'), findsNothing);
    });

    testWidgets('should be tappable', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LocationCard(
              location: testLocation,
              currentPosition: testPosition,
              onTap: (location) => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector));
      expect(tapped, isTrue);
    });
  });
}
