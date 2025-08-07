import 'package:equatable/equatable.dart';
import '../../models/geofence_event.dart' as model;

abstract class GeofenceEvent extends Equatable {
  const GeofenceEvent();

  @override
  List<Object?> get props => [];
}

class LoadGeofenceEvents extends GeofenceEvent {
  const LoadGeofenceEvents();
}

class AddGeofenceEventItem extends GeofenceEvent {
  final model.GeofenceEvent event;

  const AddGeofenceEventItem(this.event);

  @override
  List<Object?> get props => [event];
}

class GetEventsForLocation extends GeofenceEvent {
  final String locationId;

  const GetEventsForLocation(this.locationId);

  @override
  List<Object?> get props => [locationId];
}

class GetRecentEvents extends GeofenceEvent {
  const GetRecentEvents();
}

class ClearAllEvents extends GeofenceEvent {
  const ClearAllEvents();
}
