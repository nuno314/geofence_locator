import 'package:equatable/equatable.dart';
import '../../models/geofence_event.dart';

abstract class GeofenceState extends Equatable {
  const GeofenceState();

  @override
  List<Object?> get props => [];
}

class GeofenceInitial extends GeofenceState {}

class GeofenceLoading extends GeofenceState {}

class GeofenceLoaded extends GeofenceState {
  final List<GeofenceEvent> events;
  final List<GeofenceEvent> recentEvents;

  const GeofenceLoaded({required this.events, required this.recentEvents});

  @override
  List<Object?> get props => [events, recentEvents];

  GeofenceLoaded copyWith({
    List<GeofenceEvent>? events,
    List<GeofenceEvent>? recentEvents,
  }) {
    return GeofenceLoaded(
      events: events ?? this.events,
      recentEvents: recentEvents ?? this.recentEvents,
    );
  }
}

class GeofenceError extends GeofenceState {
  final String message;

  const GeofenceError(this.message);

  @override
  List<Object?> get props => [message];
}

class LocationEventsLoaded extends GeofenceState {
  final String locationId;
  final List<GeofenceEvent> events;

  const LocationEventsLoaded({required this.locationId, required this.events});

  @override
  List<Object?> get props => [locationId, events];
}
