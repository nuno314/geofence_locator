import '../models/geofence_event.dart';
import '../services/storage_service.dart';

abstract class GeofenceRepository {
  Future<List<GeofenceEvent>> getEvents();
  Future<void> addEvent(GeofenceEvent event);
  Future<List<GeofenceEvent>> getEventsForLocation(String locationId);
  Future<List<GeofenceEvent>> getRecentEvents();
  Future<void> clearAllEvents();
}

class GeofenceRepositoryImpl implements GeofenceRepository {
  final StorageService _storageService;

  GeofenceRepositoryImpl({StorageService? storageService})
    : _storageService = storageService ?? StorageService();

  @override
  Future<List<GeofenceEvent>> getEvents() async {
    try {
      return await _storageService.loadEvents();
    } catch (e) {
      print('Error loading events: $e');
      return [];
    }
  }

  @override
  Future<void> addEvent(GeofenceEvent event) async {
    try {
      await _storageService.addEvent(event);
    } catch (e) {
      print('Error adding event: $e');
      rethrow;
    }
  }

  @override
  Future<List<GeofenceEvent>> getEventsForLocation(String locationId) async {
    try {
      return await _storageService.getEventsForLocation(locationId);
    } catch (e) {
      print('Error getting events for location: $e');
      return [];
    }
  }

  @override
  Future<List<GeofenceEvent>> getRecentEvents() async {
    try {
      return await _storageService.getRecentEvents();
    } catch (e) {
      print('Error getting recent events: $e');
      return [];
    }
  }

  @override
  Future<void> clearAllEvents() async {
    try {
      await _storageService.clearAllEvents();
    } catch (e) {
      print('Error clearing events: $e');
      rethrow;
    }
  }
}
