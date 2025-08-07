import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/location.dart';
import '../models/geofence_event.dart';
import 'storage_service.dart';
import 'notification_service.dart';
import 'mock_api_service.dart';

class BackgroundService {
  static final BackgroundService _instance = BackgroundService._internal();
  factory BackgroundService() => _instance;
  BackgroundService._internal();

  final StorageService _storageService = StorageService();
  final NotificationService _notificationService = NotificationService();
  final MockApiService _mockApiService = MockApiService();

  List<Location> _activeLocations = [];
  Map<String, bool> _locationEnteredStatus = {};
  StreamSubscription<Position>? _locationSubscription;
  bool _isRunning = false;

  Future<void> initialize() async {
    await _notificationService.initialize();

    // Reset geofence status for fresh start
    _resetGeofenceStatus();

    await _loadActiveLocations();

    await _startBackgroundTracking();
  }

  void _resetGeofenceStatus() {
    _locationEnteredStatus.clear();
    print('Background: Reset geofence status for fresh start');
  }

  Future<void> _startBackgroundTracking() async {
    if (_isRunning) {
      return;
    }

    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Background: Location permission denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Background: Location permission denied forever');
        return;
      }

      // Check location services
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Background: Location services disabled');
        return;
      }

      _locationSubscription =
          Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
              distanceFilter:
                  20, // Update every 20 meters for background efficiency
              timeLimit: Duration(seconds: 30), // Timeout after 30 seconds
            ),
          ).listen(
            (Position position) {
              _checkGeofencesInBackground(position);
            },
            onError: (error) {
              print('Background location error: $error');
              _isRunning = false;
            },
          );

      _isRunning = true;
      print('Background: Location tracking started successfully');
    } catch (e) {
      print('Background: Error starting tracking: $e');
      _isRunning = false;
    }
  }

  Future<void> _loadActiveLocations() async {
    try {
      // Load from storage
      final locations = await _storageService.loadLocations();
      _activeLocations = locations.where((loc) => loc.isActive).toList();

      // Also fetch from backend to get latest data
      final backendLocations = await _mockApiService.fetchLocations();
      final backendActiveLocations = backendLocations
          .where((loc) => loc.isActive)
          .toList();

      // Merge and prioritize backend data
      for (var backendLocation in backendActiveLocations) {
        final existingIndex = _activeLocations.indexWhere(
          (loc) => loc.id == backendLocation.id,
        );
        if (existingIndex != -1) {
          _activeLocations[existingIndex] = backendLocation;
        } else {
          _activeLocations.add(backendLocation);
        }
      }

      // Initialize status
      for (var location in _activeLocations) {
        _locationEnteredStatus[location.id] = false;
      }

      print('Background: Loaded ${_activeLocations.length} active locations');
    } catch (e) {
      print('Background: Error loading locations: $e');
    }
  }

  void _checkGeofencesInBackground(Position position) {
    print(
      'Background: Checking geofences at ${position.latitude}, ${position.longitude}',
    );

    for (Location location in _activeLocations) {
      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        location.latitude,
        location.longitude,
      );

      bool isInside = distance <= location.radius;
      bool wasInside = _locationEnteredStatus[location.id] ?? false;

      print(
        'Background: ${location.name} - Distance: ${distance.toStringAsFixed(1)}m, Radius: ${location.radius}m, Inside: $isInside, WasInside: $wasInside',
      );

      if (isInside && !wasInside) {
        // Entered geofence - only notify once
        _locationEnteredStatus[location.id] = true;
        _onEnterGeofenceInBackground(location, position);
      } else if (!isInside && wasInside) {
        // Exited geofence - reset status to allow re-entry notification
        _locationEnteredStatus[location.id] = false;
        _onExitGeofenceInBackground(location, position);
      }
      // If already inside and still inside, do nothing (no repeated notifications)
      // If already outside and still outside, do nothing
    }
  }

  void _onEnterGeofenceInBackground(
    Location location,
    Position position,
  ) async {
    print('Background: 🎯 ENTERED GEOFENCE: ${location.name}');

    // Create event
    final event = GeofenceEvent(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      locationId: location.id,
      locationName: location.name,
      eventType: EventType.enter,
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: DateTime.now(),
    );

    // Save event
    await _storageService.addEvent(event);

    // Show notification
    await _notificationService.showGeofenceNotification(
      title: '🔔 Geofence Entered',
      body: 'You have entered: ${location.name}',
      locationName: location.name,
      isEntering: true,
    );

    print('Background: ✅ Notification sent for ${location.name}');
  }

  void _onExitGeofenceInBackground(Location location, Position position) async {
    print('Background: 🚪 EXITED GEOFENCE: ${location.name}');

    // Create event
    final event = GeofenceEvent(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      locationId: location.id,
      locationName: location.name,
      eventType: EventType.exit,
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: DateTime.now(),
    );

    // Save event
    await _storageService.addEvent(event);

    // Show notification
    await _notificationService.showGeofenceNotification(
      title: '🚪 Geofence Exited',
      body: 'You have left: ${location.name}',
      locationName: location.name,
      isEntering: false,
    );

    print('Background: ✅ Exit notification sent for ${location.name}');
  }

  Future<void> stopBackgroundTracking() async {
    await _locationSubscription?.cancel();
    _locationSubscription = null;
    _isRunning = false;
    print('Background: Location tracking stopped');
  }

  Future<void> refreshLocations() async {
    await _loadActiveLocations();
    print('Background: Locations refreshed');
  }

  bool get isRunning => _isRunning;

  List<Location> get activeLocations => _activeLocations;
}
