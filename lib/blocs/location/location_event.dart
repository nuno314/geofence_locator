import 'package:equatable/equatable.dart';
import '../../models/location.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object?> get props => [];
}

class LoadLocations extends LocationEvent {
  const LoadLocations();
}

class FetchLocationsFromBackend extends LocationEvent {
  const FetchLocationsFromBackend();
}

class UpdateLocationStatus extends LocationEvent {
  final String locationId;
  final bool isActive;

  const UpdateLocationStatus({
    required this.locationId,
    required this.isActive,
  });

  @override
  List<Object?> get props => [locationId, isActive];
}

class AddLocation extends LocationEvent {
  final Location location;

  const AddLocation(this.location);

  @override
  List<Object?> get props => [location];
}

class DeleteLocation extends LocationEvent {
  final String locationId;

  const DeleteLocation(this.locationId);

  @override
  List<Object?> get props => [locationId];
}


