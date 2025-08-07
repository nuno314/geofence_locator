import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/job.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  StreamSubscription<Position>? _locationSubscription;
  Position? _currentPosition;
  List<Job> _activeJobs = [];
  Function(Job)? _onEnterGeofence;
  Function(Job)? _onExitGeofence;
  Map<String, bool> _jobEnteredStatus = {};

  // Callback for current position updates
  Function(Position)? _onPositionUpdate;

  Position? get currentPosition => _currentPosition;
  List<Job> get activeJobs => _activeJobs;

  // Initialize location service
  Future<bool> initialize() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  // Start location tracking with auto-refresh
  void startLocationTracking({
    required List<Job> jobs,
    Function(Job)? onEnterGeofence,
    Function(Job)? onExitGeofence,
    Function(Position)? onPositionUpdate,
  }) {
    _activeJobs = jobs.where((job) => job.isActive).toList();
    _onEnterGeofence = onEnterGeofence;
    _onExitGeofence = onExitGeofence;
    _onPositionUpdate = onPositionUpdate;

    // Initialize job status
    for (var job in _activeJobs) {
      _jobEnteredStatus[job.id] = false;
    }

    // Start continuous location tracking with optimal settings
    _locationSubscription =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 5, // Update every 5 meters for better precision
            timeLimit: Duration(seconds: 30), // Timeout after 30 seconds
          ),
        ).listen(
          (Position position) {
            _currentPosition = position;
            _checkGeofences(position);
            _onPositionUpdate?.call(position);
          },
          onError: (error) {
            print('Location stream error: $error');
            // Retry after error
            Future.delayed(const Duration(seconds: 5), () {
              if (_locationSubscription != null) {
                startLocationTracking(
                  jobs: _activeJobs,
                  onEnterGeofence: _onEnterGeofence,
                  onExitGeofence: _onExitGeofence,
                  onPositionUpdate: _onPositionUpdate,
                );
              }
            });
          },
        );

    // Get initial position immediately
    _getInitialPosition();
  }

  // Get initial position
  Future<void> _getInitialPosition() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      _currentPosition = position;
      _onPositionUpdate?.call(position);
    } catch (e) {
      print('Error getting initial position: $e');
    }
  }

  // Stop location tracking
  void stopLocationTracking() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
  }

  // Check if current position is within any geofence
  void _checkGeofences(Position position) {
    for (Job job in _activeJobs) {
      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        job.latitude,
        job.longitude,
      );

      bool isInside = distance <= job.radius;
      bool wasInside = _jobEnteredStatus[job.id] ?? false;

      if (isInside && !wasInside) {
        // Worker entered geofence
        _jobEnteredStatus[job.id] = true;
        _onEnterGeofence?.call(job);
      } else if (!isInside && wasInside) {
        // Worker exited geofence
        _jobEnteredStatus[job.id] = false;
        _onExitGeofence?.call(job);
      }
    }
  }

  // Get current location once (for manual refresh if needed)
  Future<Position?> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      _currentPosition = position;
      return position;
    } catch (e) {
      print('Error getting current location: $e');
      return null;
    }
  }

  // Calculate distance between two points
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  // Check if a position is inside a specific geofence
  bool isInsideGeofence(Position position, Job job) {
    double distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      job.latitude,
      job.longitude,
    );
    return distance <= job.radius;
  }

  // Update jobs list
  void updateJobs(List<Job> jobs) {
    _activeJobs = jobs.where((job) => job.isActive).toList();

    // Reset status for new jobs
    for (var job in _activeJobs) {
      if (!_jobEnteredStatus.containsKey(job.id)) {
        _jobEnteredStatus[job.id] = false;
      }
    }

    // Remove status for deleted jobs
    _jobEnteredStatus.removeWhere(
      (jobId, _) => !_activeJobs.any((job) => job.id == jobId),
    );
  }

  // Check if location service is active
  bool get isTracking => _locationSubscription != null;
}
