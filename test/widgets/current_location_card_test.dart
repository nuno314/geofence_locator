import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geofence_locator/widgets/current_location_card.dart';

void main() {
  group('CurrentLocationCard', () {
    testWidgets('should display current location when position is available', (
      WidgetTester tester,
    ) async {
      final position = Position(
        latitude: 10.0,
        longitude: 20.0,
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
          home: Scaffold(body: CurrentLocationCard(currentPosition: position)),
        ),
      );

      expect(find.text('Current Location'), findsOneWidget);
      expect(find.text('LIVE'), findsOneWidget);
      expect(find.text('Latitude: 10.000000'), findsOneWidget);
      expect(find.text('Longitude: 20.000000'), findsOneWidget);
      expect(find.text('Auto-updating every 5 meters'), findsOneWidget);
    });

    testWidgets('should display location not available when position is null', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CurrentLocationCard(currentPosition: null)),
        ),
      );

      expect(find.text('Current Location'), findsOneWidget);
      expect(find.text('LIVE'), findsOneWidget);
      expect(find.text('Location not available'), findsOneWidget);
      expect(find.text('Enable location tracking to start'), findsOneWidget);
    });

    testWidgets('should display location icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CurrentLocationCard(currentPosition: null)),
        ),
      );

      expect(find.byIcon(Icons.my_location), findsOneWidget);
    });

    testWidgets('should display live status container', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CurrentLocationCard(currentPosition: null)),
        ),
      );

      expect(find.byType(Container), findsWidgets);
      expect(find.text('LIVE'), findsOneWidget);
    });
  });
}
