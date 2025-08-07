import 'package:flutter/foundation.dart';
import '../models/job.dart';
import '../models/location.dart';
import '../models/geofence_event.dart';
import '../services/location_service.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';
import '../services/mock_api_service.dart';
import 'package:geolocator/geolocator.dart';

class GeofenceProvider extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  final NotificationService _notificationService = NotificationService();
  final StorageService _storageService = StorageService();
  final MockApiService _mockApiService = MockApiService();

  List<Job> _jobs = [];
  List<Location> _locations = [];
  List<GeofenceEvent> _events = [];
  bool _isLocationTracking = false;
  bool _isInitialized = false;
  bool _isLoading = false;

  List<Job> get jobs => _jobs;
  List<Location> get locations => _locations;
  List<GeofenceEvent> get events => _events;
  bool get isLocationTracking => _isLocationTracking;
  bool get isInitialized => _isInitialized;
  bool get isLoading => _isLoading;
  Position? get currentPosition => _locationService.currentPosition;

  // Initialize the provider
  Future<void> initialize() async {
    if (_isInitialized) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Initialize notification service
      await _notificationService.initialize();

      // Load saved data
      await loadJobs();
      await loadLocations();
      await loadEvents();

      // Fetch locations from backend (mock)
      await fetchLocationsFromBackend();

      // Initialize location service
      bool locationInitialized = await _locationService.initialize();
      if (locationInitialized) {
        _isInitialized = true;
      }
    } catch (e) {
      print('Error initializing: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void setState(VoidCallback fn) {
    fn();
    notifyListeners();
  }

  // Load jobs from storage
  Future<void> loadJobs() async {
    _jobs = await _storageService.loadJobs();
    notifyListeners();
  }

  // Load locations from storage
  Future<void> loadLocations() async {
    _locations = await _storageService.loadLocations();
    notifyListeners();
  }

  // Load events from storage
  Future<void> loadEvents() async {
    _events = await _storageService.loadEvents();
    notifyListeners();
  }

  // Fetch locations from backend
  Future<void> fetchLocationsFromBackend() async {
    try {
      final backendLocations = await _mockApiService.fetchLocations();

      // Merge with existing locations
      for (var backendLocation in backendLocations) {
        final existingIndex = _locations.indexWhere(
          (loc) => loc.id == backendLocation.id,
        );
        if (existingIndex == -1) {
          _locations.add(backendLocation);
        }
      }

      await _storageService.saveLocations(_locations);
      notifyListeners();
    } catch (e) {
      print('Error fetching locations: $e');
    }
  }

  // Add a new job
  Future<void> addJob(Job job) async {
    _jobs.add(job);
    await _storageService.saveJobs(_jobs);

    // Update location service with new jobs
    _locationService.updateJobs(_jobs);

    notifyListeners();
  }

  // Update an existing job
  Future<void> updateJob(Job updatedJob) async {
    final index = _jobs.indexWhere((job) => job.id == updatedJob.id);
    if (index != -1) {
      _jobs[index] = updatedJob;
      await _storageService.saveJobs(_jobs);

      // Update location service with updated jobs
      _locationService.updateJobs(_jobs);

      notifyListeners();
    }
  }

  // Delete a job
  Future<void> deleteJob(String jobId) async {
    _jobs.removeWhere((job) => job.id == jobId);
    await _storageService.saveJobs(_jobs);

    // Update location service with updated jobs
    _locationService.updateJobs(_jobs);

    notifyListeners();
  }

  // Update location status
  Future<void> updateLocationStatus(String locationId, bool isActive) async {
    final index = _locations.indexWhere(
      (location) => location.id == locationId,
    );
    if (index != -1) {
      final location = _locations[index];
      _locations[index] = location.copyWith(isActive: isActive);
      await _storageService.saveLocations(_locations);
      notifyListeners();
    }
  }

  // Start location tracking
  void startLocationTracking() {
    if (!_isInitialized) return;

    // Convert locations to jobs for tracking
    final trackingJobs = _locations
        .where((location) => location.isActive)
        .map(
          (location) => Job(
            id: location.id,
            title: location.name,
            description: location.description,
            latitude: location.latitude,
            longitude: location.longitude,
            radius: location.radius,
            workerId: 'current_user', // You can replace with actual user ID
            createdAt: location.createdAt,
          ),
        )
        .toList();

    _locationService.startLocationTracking(
      jobs: trackingJobs,
      onEnterGeofence: _onEnterGeofence,
      onExitGeofence: _onExitGeofence,
      onPositionUpdate: _onPositionUpdate,
    );

    _isLocationTracking = true;
    notifyListeners();
  }

  // Handle position updates
  void _onPositionUpdate(Position position) {
    // This will be called whenever location updates
    // The UI will automatically refresh through notifyListeners()
    print('Position updated: ${position.latitude}, ${position.longitude}');

    // Notify listeners to update UI
    notifyListeners();
  }

  // Stop location tracking
  void stopLocationTracking() {
    _locationService.stopLocationTracking();
    _isLocationTracking = false;
    notifyListeners();
  }

  // Handle geofence entry
  void _onEnterGeofence(Job job) async {
    // Find the corresponding location
    final location = _locations.firstWhere((loc) => loc.id == job.id);

    // Create event
    final event = GeofenceEvent(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      locationId: location.id,
      locationName: location.name,
      eventType: EventType.enter,
      latitude: _locationService.currentPosition?.latitude ?? 0,
      longitude: _locationService.currentPosition?.longitude ?? 0,
      timestamp: DateTime.now(),
    );

    // Save event
    await _storageService.addEvent(event);
    _events.add(event);

    // Show notification
    await _notificationService.showGeofenceNotification(
      title: '🔔 Geofence Entered',
      body: 'You have entered: ${location.name}',
      locationName: location.name,
      isEntering: true,
    );

    print('Entered geofence for location: ${location.name}');
    notifyListeners();
  }

  // Handle geofence exit
  void _onExitGeofence(Job job) async {
    // Find the corresponding location
    final location = _locations.firstWhere((loc) => loc.id == job.id);

    // Create event
    final event = GeofenceEvent(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      locationId: location.id,
      locationName: location.name,
      eventType: EventType.exit,
      latitude: _locationService.currentPosition?.latitude ?? 0,
      longitude: _locationService.currentPosition?.longitude ?? 0,
      timestamp: DateTime.now(),
    );

    // Save event
    await _storageService.addEvent(event);
    _events.add(event);

    // Show notification
    await _notificationService.showGeofenceNotification(
      title: '🚪 Geofence Exited',
      body: 'You have left: ${location.name}',
      locationName: location.name,
      isEntering: false,
    );

    print('Exited geofence for location: ${location.name}');
    notifyListeners();
  }

  // Get current location
  Future<dynamic> getCurrentLocation() async {
    return await _locationService.getCurrentLocation();
  }

  // Get active locations
  List<Location> getActiveLocations() {
    return _locations.where((location) => location.isActive).toList();
  }

  // Get recent events
  List<GeofenceEvent> getRecentEvents() {
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    return _events
        .where((event) => event.timestamp.isAfter(thirtyDaysAgo))
        .toList();
  }

  // Get events for a specific location
  List<GeofenceEvent> getEventsForLocation(String locationId) {
    return _events.where((event) => event.locationId == locationId).toList();
  }

  // Toggle job active status
  Future<void> toggleJobStatus(String jobId) async {
    final index = _jobs.indexWhere((job) => job.id == jobId);
    if (index != -1) {
      final job = _jobs[index];
      final updatedJob = job.copyWith(isActive: !job.isActive);
      await updateJob(updatedJob);
    }
  }

  // Clear all jobs
  Future<void> clearAllJobs() async {
    _jobs.clear();
    await _storageService.clearAllJobs();
    _locationService.updateJobs(_jobs);
    notifyListeners();
  }

  // Clear all events
  Future<void> clearAllEvents() async {
    _events.clear();
    await _storageService.clearAllEvents();
    notifyListeners();
  }
}
