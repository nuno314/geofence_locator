import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import '../blocs/location/location_bloc.dart';
import '../blocs/location/location_event.dart';
import '../blocs/location/location_state.dart';
import '../extensions/localization_extension.dart';
import '../routes/app_router.dart';
import '../widgets/current_location_card.dart';
import '../widgets/status_card.dart';
import '../widgets/locations_list.dart';
import '../widgets/language_selector.dart';
import '../models/location.dart';
import '../services/location_service.dart';
import '../services/notification_service.dart';
import '../models/job.dart';
import '../models/geofence_event.dart' as model;
import '../services/storage_service.dart';
import '../blocs/geofence/geofence_bloc.dart';
import '../blocs/geofence/geofence_event.dart' as bloc_event;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position? _currentPosition;
  StreamSubscription<Position>? _locationSubscription;
  bool _isLocationTracking = false;

  // Services
  final LocationService _locationService = LocationService();
  final NotificationService _notificationService = NotificationService();
  final StorageService _storageService = StorageService();

  // Track geofence status to avoid duplicate notifications
  Map<String, bool> _locationEnteredStatus = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    // Initialize notification service
    await _notificationService.initialize();

    // Reset geofence status for fresh start
    _resetGeofenceStatus();

    // Load locations from backend
    context.read<LocationBloc>().add(const FetchLocationsFromBackend());

    // Start location tracking with geofence
    await _startLocationTracking();
  }

  void _resetGeofenceStatus() {
    _locationEnteredStatus.clear();
    print('HomeScreen: Reset geofence status for fresh start');
  }

  Future<void> _startLocationTracking() async {
    try {
      // Check location permission first
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permission denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permission denied forever');
        return;
      }

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled');
        return;
      }

      // Get initial position
      try {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 10),
        );
        setState(() {
          _currentPosition = position;
        });
        print('Initial position: ${position.latitude}, ${position.longitude}');
      } catch (e) {
        print('Error getting initial position: $e');
      }

      // Start location stream for continuous updates
      _locationSubscription =
          Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
              distanceFilter: 5, // Update every 5 meters
            ),
          ).listen(
            (Position position) {
              print(
                'Location updated: ${position.latitude}, ${position.longitude}',
              );
              setState(() {
                _currentPosition = position;
                _isLocationTracking = true;
              });

              // Check geofences with current position
              _checkGeofences(position);
            },
            onError: (error) {
              print('Location stream error: $error');
              setState(() {
                _isLocationTracking = false;
              });
            },
          );

      setState(() {
        _isLocationTracking = true;
      });
      print('Location tracking started successfully');
    } catch (e) {
      print('Error starting location tracking: $e');
      setState(() {
        _isLocationTracking = false;
      });
    }
  }

  void _checkGeofences(Position position) {
    // Get active locations from BLoC
    final locationState = context.read<LocationBloc>().state;
    if (locationState is LocationLoaded) {
      final activeLocations = locationState.activeLocations;

      for (Location location in activeLocations) {
        double distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          location.latitude,
          location.longitude,
        );

        bool isInside = distance <= location.radius;
        bool wasInside = _locationEnteredStatus[location.id] ?? false;

        if (isInside && !wasInside) {
          // Entered geofence - only notify once
          _locationEnteredStatus[location.id] = true;
          _onEnterGeofence(location);
        } else if (!isInside && wasInside) {
          // Exited geofence - reset status to allow re-entry notification
          _locationEnteredStatus[location.id] = false;
          // Optionally handle exit event here if needed
        }
        // If already inside and still inside, do nothing (no repeated notifications)
        // If already outside and still outside, do nothing
      }
    }
  }

  void _onEnterGeofence(Location location) async {
    print('🎯 ENTERED GEOFENCE: ${location.name}');

    // Create geofence event
    final event = model.GeofenceEvent(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      locationId: location.id,
      locationName: location.name,
      eventType: model.EventType.enter,
      latitude: _currentPosition?.latitude ?? 0,
      longitude: _currentPosition?.longitude ?? 0,
      timestamp: DateTime.now(),
    );

    // Save event to storage
    await _storageService.addEvent(event);

    // Show notification
    await _notificationService.showGeofenceNotification(
      title: '🔔 Geofence Entered',
      body: 'You have entered: ${location.name}',
      locationName: location.name,
      isEntering: true,
    );

    // Event saved to storage, GeofenceBloc will load from storage

    print('✅ Geofence notification sent for: ${location.name}');
  }

  Future<void> _stopLocationTracking() async {
    await _locationSubscription?.cancel();
    setState(() {
      _isLocationTracking = false;
    });
    print('Location tracking stopped');
  }

  Future<void> _restartLocationTracking() async {
    await _stopLocationTracking();
    await _startLocationTracking();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.trans?.appTitle ?? 'Employee Geofence'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          const LanguageSelector(),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Refresh data from backend
              context.read<LocationBloc>().add(
                const FetchLocationsFromBackend(),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Refreshing data from backend...'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            tooltip: 'Refreshing data from backend...',
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.pushNamed(context, AppRouter.history),
          ),

          // Location tracking status indicator
        ],
      ),
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, locationState) {
          if (locationState is LocationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (locationState is LocationError) {
            return Center(child: Text('Error: ${locationState.message}'));
          }

          if (locationState is LocationLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CurrentLocationCard(
                    currentPosition: _currentPosition,
                    isTracking: _isLocationTracking,
                    onEnableLocation: _restartLocationTracking,
                  ),
                  const SizedBox(height: 16),
                  StatusCard(
                    activeLocationsCount: locationState.activeLocations.length,
                    isLocationTracking: _isLocationTracking,
                  ),
                  const SizedBox(height: 16),
                  LocationsList(
                    locations: locationState.locations,
                    currentPosition: _currentPosition,
                    onLocationTap: (location) => _showLocationDetails(location),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('Initializing...'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRouter.addLocation),
        tooltip: L10n.trans?.addCustomLocation ?? 'Add custom location',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showLocationDetails(Location location) {
    bool isInside = false;
    double distance = 0;

    if (_currentPosition != null) {
      distance = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        location.latitude,
        location.longitude,
      );
      isInside = distance <= location.radius;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(location.name),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${L10n.trans?.address ?? 'Address'}: ${location.address}'),
              const SizedBox(height: 8),
              Text(
                '${L10n.trans?.description ?? 'Description'}: ${location.description}',
              ),
              Text(
                '${L10n.trans?.location ?? 'Location'}: ${location.latitude.toStringAsFixed(6)}, ${location.longitude.toStringAsFixed(6)}',
              ),
              Text('${L10n.trans?.radius ?? 'Radius'}: ${location.radius}m'),
              if (_currentPosition != null) ...[
                const SizedBox(height: 8),
                Text(
                  '${L10n.trans?.distance ?? 'Distance'}: ${distance.toStringAsFixed(1)}m',
                ),
                Text(
                  isInside
                      ? '${L10n.trans?.status ?? 'Status'}: ${L10n.trans?.insideGeofence ?? 'INSIDE GEOFENCE'}'
                      : '${L10n.trans?.status ?? 'Status'}: ${L10n.trans?.outsideGeofence ?? 'OUTSIDE GEOFENCE'}',
                  style: TextStyle(
                    color: isInside ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(L10n.trans?.close ?? 'Close'),
          ),
        ],
      ),
    );
  }
}
