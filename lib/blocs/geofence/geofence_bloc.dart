import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/geofence_repository.dart';
import 'geofence_event.dart';
import 'geofence_state.dart';

class GeofenceBloc extends Bloc<GeofenceEvent, GeofenceState> {
  final GeofenceRepository _geofenceRepository;

  GeofenceBloc({required GeofenceRepository geofenceRepository})
    : _geofenceRepository = geofenceRepository,
      super(GeofenceInitial()) {
    on<LoadGeofenceEvents>(_onLoadGeofenceEvents);
    on<AddGeofenceEventItem>(_onAddGeofenceEvent);
    on<GetEventsForLocation>(_onGetEventsForLocation);
    on<GetRecentEvents>(_onGetRecentEvents);
    on<ClearAllEvents>(_onClearAllEvents);
  }

  Future<void> _onLoadGeofenceEvents(
    LoadGeofenceEvents event,
    Emitter<GeofenceState> emit,
  ) async {
    emit(GeofenceLoading());
    try {
      final events = await _geofenceRepository.getEvents();
      final recentEvents = await _geofenceRepository.getRecentEvents();
      emit(GeofenceLoaded(events: events, recentEvents: recentEvents));
    } catch (e) {
      emit(GeofenceError(e.toString()));
    }
  }

  Future<void> _onAddGeofenceEvent(
    AddGeofenceEventItem event,
    Emitter<GeofenceState> emit,
  ) async {
    try {
      await _geofenceRepository.addEvent(event.event);

      // Reload events to reflect changes
      final events = await _geofenceRepository.getEvents();
      final recentEvents = await _geofenceRepository.getRecentEvents();
      emit(GeofenceLoaded(events: events, recentEvents: recentEvents));
    } catch (e) {
      emit(GeofenceError(e.toString()));
    }
  }

  Future<void> _onGetEventsForLocation(
    GetEventsForLocation event,
    Emitter<GeofenceState> emit,
  ) async {
    try {
      final events = await _geofenceRepository.getEventsForLocation(
        event.locationId,
      );
      emit(LocationEventsLoaded(locationId: event.locationId, events: events));
    } catch (e) {
      emit(GeofenceError(e.toString()));
    }
  }

  Future<void> _onGetRecentEvents(
    GetRecentEvents event,
    Emitter<GeofenceState> emit,
  ) async {
    try {
      final recentEvents = await _geofenceRepository.getRecentEvents();
      final allEvents = await _geofenceRepository.getEvents();
      emit(GeofenceLoaded(events: allEvents, recentEvents: recentEvents));
    } catch (e) {
      emit(GeofenceError(e.toString()));
    }
  }

  Future<void> _onClearAllEvents(
    ClearAllEvents event,
    Emitter<GeofenceState> emit,
  ) async {
    try {
      await _geofenceRepository.clearAllEvents();
      emit(const GeofenceLoaded(events: [], recentEvents: []));
    } catch (e) {
      emit(GeofenceError(e.toString()));
    }
  }
}
