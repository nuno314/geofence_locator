import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/location.dart';
import '../../repositories/location_repository.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationRepository _locationRepository;

  LocationBloc({required LocationRepository locationRepository})
    : _locationRepository = locationRepository,
      super(LocationInitial()) {
    on<LoadLocations>(_onLoadLocations);
    on<FetchLocationsFromBackend>(_onFetchLocationsFromBackend);
    on<UpdateLocationStatus>(_onUpdateLocationStatus);
    on<AddLocation>(_onAddLocation);
    on<DeleteLocation>(_onDeleteLocation);
  }

  Future<void> _onLoadLocations(
    LoadLocations event,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationLoading());
    try {
      final locations = await _locationRepository.getLocations();
      final activeLocations = locations.where((loc) => loc.isActive).toList();
      emit(
        LocationLoaded(locations: locations, activeLocations: activeLocations),
      );
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }

  Future<void> _onFetchLocationsFromBackend(
    FetchLocationsFromBackend event,
    Emitter<LocationState> emit,
  ) async {
    try {
      final backendLocations = await _locationRepository
          .fetchLocationsFromBackend();
      final currentLocations = await _locationRepository.getLocations();

      // Merge with existing locations
      final allLocations = <Location>[];
      allLocations.addAll(currentLocations);

      for (var backendLocation in backendLocations) {
        final existingIndex = allLocations.indexWhere(
          (loc) => loc.id == backendLocation.id,
        );
        if (existingIndex == -1) {
          allLocations.add(backendLocation);
        }
      }

      await _locationRepository.saveLocations(allLocations);

      final activeLocations = allLocations
          .where((loc) => loc.isActive)
          .toList();
      emit(
        LocationLoaded(
          locations: allLocations,
          activeLocations: activeLocations,
        ),
      );
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }

  Future<void> _onUpdateLocationStatus(
    UpdateLocationStatus event,
    Emitter<LocationState> emit,
  ) async {
    try {
      await _locationRepository.updateLocationStatus(
        event.locationId,
        event.isActive,
      );
      emit(
        LocationStatusUpdated(
          locationId: event.locationId,
          isActive: event.isActive,
        ),
      );

      // Reload locations to reflect changes
      add(const LoadLocations());
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }

  Future<void> _onAddLocation(
    AddLocation event,
    Emitter<LocationState> emit,
  ) async {
    try {
      final currentLocations = await _locationRepository.getLocations();
      currentLocations.add(event.location);
      await _locationRepository.saveLocations(currentLocations);

      final activeLocations = currentLocations
          .where((loc) => loc.isActive)
          .toList();
      emit(
        LocationLoaded(
          locations: currentLocations,
          activeLocations: activeLocations,
        ),
      );
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }

  Future<void> _onDeleteLocation(
    DeleteLocation event,
    Emitter<LocationState> emit,
  ) async {
    try {
      final currentLocations = await _locationRepository.getLocations();
      currentLocations.removeWhere((loc) => loc.id == event.locationId);
      await _locationRepository.saveLocations(currentLocations);

      final activeLocations = currentLocations
          .where((loc) => loc.isActive)
          .toList();
      emit(
        LocationLoaded(
          locations: currentLocations,
          activeLocations: activeLocations,
        ),
      );
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }
}
