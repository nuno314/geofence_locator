import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

abstract class LocationTrackingEvent extends Equatable {
  const LocationTrackingEvent();

  @override
  List<Object?> get props => [];
}

class InitializeLocationTracking extends LocationTrackingEvent {
  const InitializeLocationTracking();
}

class StartLocationTracking extends LocationTrackingEvent {
  const StartLocationTracking();
}

class StopLocationTracking extends LocationTrackingEvent {
  const StopLocationTracking();
}

class LocationUpdated extends LocationTrackingEvent {
  final Position position;

  const LocationUpdated(this.position);

  @override
  List<Object?> get props => [position];
}

class GetCurrentLocation extends LocationTrackingEvent {
  const GetCurrentLocation();
}
