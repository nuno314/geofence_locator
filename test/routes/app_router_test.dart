import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geofence_locator/routes/app_router.dart';

void main() {
  group('AppRouter', () {
    test('should have correct route constants', () {
      expect(AppRouter.home, equals('/'));
      expect(AppRouter.addLocation, equals('/add-location'));
      expect(AppRouter.history, equals('/history'));
    });

    test('should generate home route', () {
      final route = AppRouter.generateRoute(const RouteSettings(name: '/'));

      expect(route, isA<MaterialPageRoute>());
    });

    test('should generate add location route', () {
      final route = AppRouter.generateRoute(
        const RouteSettings(name: '/add-location'),
      );

      expect(route, isA<MaterialPageRoute>());
    });

    test('should generate history route', () {
      final route = AppRouter.generateRoute(
        const RouteSettings(name: '/history'),
      );

      expect(route, isA<MaterialPageRoute>());
    });

    test('should generate default route for unknown route', () {
      final route = AppRouter.generateRoute(
        const RouteSettings(name: '/unknown'),
      );

      expect(route, isA<MaterialPageRoute>());
    });

    test('should handle null route name', () {
      final route = AppRouter.generateRoute(const RouteSettings(name: null));

      expect(route, isA<MaterialPageRoute>());
    });
  });
}
