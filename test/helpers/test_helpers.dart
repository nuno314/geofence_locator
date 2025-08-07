import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geofence_locator/l10n/app_localizations.dart';
import 'package:geofence_locator/extensions/localization_extension.dart';

/// Test helper class for setting up test environment
class TestHelpers {
  /// Create a test app with localization support
  static Widget createTestApp({required Widget child, String locale = 'en'}) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      locale: Locale(locale),
      supportedLocales: const [Locale('en'), Locale('vi'), Locale('ms')],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: child,
    );
  }

  /// Create a test app with BLoC providers
  static Widget createTestAppWithBloc({
    required Widget child,
    String locale = 'en',
    List<BlocProvider> providers = const [],
  }) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      locale: Locale(locale),
      supportedLocales: const [Locale('en'), Locale('vi'), Locale('ms')],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: MultiBlocProvider(providers: providers, child: child),
    );
  }

  /// Wait for localization to load
  static Future<void> waitForLocalization(WidgetTester tester) async {
    await tester.pumpAndSettle();
    // Wait a bit more to ensure localization is loaded
    await Future.delayed(const Duration(milliseconds: 100));
  }

  /// Get localized string safely
  static String getLocalizedString(String key, {String fallback = ''}) {
    return L10n.getString(key, fallback: fallback);
  }

  /// Mock location data for testing
  static Map<String, dynamic> getMockLocationData() {
    return {
      'latitude': 10.8231,
      'longitude': 106.6297,
      'accuracy': 5.0,
      'altitude': 10.0,
      'speed': 0.0,
      'speed_accuracy': 0.0,
      'heading': 0.0,
      'time': DateTime.now().millisecondsSinceEpoch,
      'isMock': false,
      'verticalAccuracy': 0.0,
      'headingAccuracy': 0.0,
      'elapsedRealtimeNanos': 0,
      'elapsedRealtimeUncertaintyNanos': 0,
      'satelliteNumber': 0,
      'provider': 'gps',
    };
  }

  /// Mock location model for testing
  static Map<String, dynamic> getMockLocationModel() {
    return {
      'id': '1',
      'name': 'Test Location',
      'latitude': 10.8231,
      'longitude': 106.6297,
      'radius': 100.0,
      'description': 'Test location for testing',
      'isActive': true,
      'address': 'Test Address',
    };
  }

  /// Mock geofence event for testing
  static Map<String, dynamic> getMockGeofenceEvent() {
    return {
      'id': '1',
      'locationId': '1',
      'locationName': 'Test Location',
      'eventType': 'enter',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'latitude': 10.8231,
      'longitude': 106.6297,
      'distance': 50.0,
    };
  }

  /// Common test setup
  static Future<void> setupTestEnvironment(WidgetTester tester) async {
    // Ensure test binding is initialized
    TestWidgetsFlutterBinding.ensureInitialized();

    // Wait for any async operations
    await tester.pumpAndSettle();
  }

  /// Common test teardown
  static Future<void> teardownTestEnvironment(WidgetTester tester) async {
    // Clean up any resources
    await tester.pumpAndSettle();
  }
}

/// Extension for common test assertions
extension TestAssertions on WidgetTester {
  /// Assert that a widget with specific text exists
  Future<void> expectText(String text) async {
    expect(find.text(text), findsOneWidget);
  }

  /// Assert that a widget with specific text exists (multiple)
  Future<void> expectTextMultiple(String text) async {
    expect(find.text(text), findsWidgets);
  }

  /// Assert that a widget with specific text does not exist
  Future<void> expectNoText(String text) async {
    expect(find.text(text), findsNothing);
  }

  /// Assert that a widget with specific icon exists
  Future<void> expectIcon(IconData icon) async {
    expect(find.byIcon(icon), findsOneWidget);
  }

  /// Assert that a widget with specific type exists
  Future<void> expectWidgetType(Type type) async {
    expect(find.byType(type), findsOneWidget);
  }

  /// Assert that a widget with specific type exists (multiple)
  Future<void> expectWidgetTypeMultiple(Type type) async {
    expect(find.byType(type), findsWidgets);
  }

  /// Tap on a widget with specific text
  Future<void> tapText(String text) async {
    await tap(find.text(text));
    await pumpAndSettle();
  }

  /// Tap on a widget with specific icon
  Future<void> tapIcon(IconData icon) async {
    await tap(find.byIcon(icon));
    await pumpAndSettle();
  }

  /// Enter text in a text field
  Future<void> enterTextInField(String text) async {
    await enterText(find.byType(TextField), text);
    await pumpAndSettle();
  }

  /// Wait for widget to be ready
  Future<void> waitForWidget() async {
    await pumpAndSettle();
    await Future.delayed(const Duration(milliseconds: 100));
  }
}
