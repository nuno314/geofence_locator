import 'package:equatable/equatable.dart';
import '../../models/location.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final List<Location> locations;
  final List<Location> activeLocations;

  const LocationLoaded({
    required this.locations,
    required this.activeLocations,
  });

  @override
  List<Object?> get props => [locations, activeLocations];

  LocationLoaded copyWith({
    List<Location>? locations,
    List<Location>? activeLocations,
  }) {
    return LocationLoaded(
      locations: locations ?? this.locations,
      activeLocations: activeLocations ?? this.activeLocations,
    );
  }
}

class LocationError extends LocationState {
  final String message;

  const LocationError(this.message);

  @override
  List<Object?> get props => [message];
}

class LocationStatusUpdated extends LocationState {
  final String locationId;
  final bool isActive;

  const LocationStatusUpdated({
    required this.locationId,
    required this.isActive,
  });

  @override
  List<Object?> get props => [locationId, isActive];
}
