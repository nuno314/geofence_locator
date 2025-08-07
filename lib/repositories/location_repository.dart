import '../models/location.dart';
import '../services/mock_api_service.dart';
import '../services/storage_service.dart';

abstract class LocationRepository {
  Future<List<Location>> getLocations();
  Future<void> saveLocations(List<Location> locations);
  Future<void> updateLocationStatus(String locationId, bool isActive);
  Future<List<Location>> fetchLocationsFromBackend();
}

class LocationRepositoryImpl implements LocationRepository {
  final MockApiService _mockApiService;
  final StorageService _storageService;

  LocationRepositoryImpl({
    MockApiService? mockApiService,
    StorageService? storageService,
  }) : _mockApiService = mockApiService ?? MockApiService(),
       _storageService = storageService ?? StorageService();

  @override
  Future<List<Location>> getLocations() async {
    try {
      return await _storageService.loadLocations();
    } catch (e) {
      print('Error loading locations: $e');
      return [];
    }
  }

  @override
  Future<void> saveLocations(List<Location> locations) async {
    try {
      await _storageService.saveLocations(locations);
    } catch (e) {
      print('Error saving locations: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateLocationStatus(String locationId, bool isActive) async {
    try {
      await _storageService.updateLocationStatus(locationId, isActive);
    } catch (e) {
      print('Error updating location status: $e');
      rethrow;
    }
  }

  @override
  Future<List<Location>> fetchLocationsFromBackend() async {
    try {
      return await _mockApiService.getMockLocations();
    } catch (e) {
      print('Error fetching locations from backend: $e');
      return [];
    }
  }
}
