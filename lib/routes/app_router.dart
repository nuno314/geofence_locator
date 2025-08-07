import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/add_location_screen.dart';
import '../screens/history_screen.dart';

class AppRouter {
  static const String home = '/';
  static const String addLocation = '/add-location';
  static const String history = '/history';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case addLocation:
        return MaterialPageRoute(builder: (_) => const AddLocationScreen());
      case history:
        return MaterialPageRoute(builder: (_) => const HistoryScreen());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
