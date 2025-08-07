// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geofence_locator/main.dart';
import 'package:geofence_locator/blocs/location/location_bloc.dart';
import 'package:geofence_locator/blocs/geofence/geofence_bloc.dart';
import 'package:geofence_locator/blocs/language/language_bloc.dart';
import 'package:geofence_locator/repositories/location_repository.dart';
import 'package:geofence_locator/repositories/geofence_repository.dart';

void main() {
  group('App Widget Tests', () {
    testWidgets('App should render without crashing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('App should show home screen by default', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.text('Employee Geofence'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.history), findsOneWidget);
      expect(find.byIcon(Icons.language), findsOneWidget);
    });
  });
}
