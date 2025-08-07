import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geofence_locator/extensions/localization_extension.dart';

void main() {
  group('Localization Extension', () {
    test('should create navigator key', () {
      expect(navigatorKey, isA<GlobalKey<NavigatorState>>());
    });

    test('should have L10n helper class', () {
      expect(L10n, isA<Type>());
    });

    test('should have trans getter', () {
      // This test verifies the structure exists
      expect(L10n.trans, isNull); // Will be null without context
    });

    test('navigator key should be accessible', () {
      final key = navigatorKey;
      expect(key, isNotNull);
      expect(key.currentState, isNull); // No context in test
    });
  });
}
