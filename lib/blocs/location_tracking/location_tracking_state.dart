import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

abstract class LocationTrackingState extends Equatable {
  const LocationTrackingState();

  @override
  List<Object?> get props => [];
}

class LocationTrackingInitial extends LocationTrackingState {}

class LocationTrackingLoading extends LocationTrackingState {}

class LocationTrackingInitialized extends LocationTrackingState {
  final bool isInitialized;

  const LocationTrackingInitialized({required this.isInitialized});

  @override
  List<Object?> get props => [isInitialized];
}

class LocationTrackingActive extends LocationTrackingState {
  final Position? currentPosition;
  final bool isTracking;

  const LocationTrackingActive({
    this.currentPosition,
    required this.isTracking,
  });

  @override
  List<Object?> get props => [currentPosition, isTracking];

  LocationTrackingActive copyWith({
    Position? currentPosition,
    bool? isTracking,
  }) {
    return LocationTrackingActive(
      currentPosition: currentPosition ?? this.currentPosition,
      isTracking: isTracking ?? this.isTracking,
    );
  }
}

class LocationTrackingError extends LocationTrackingState {
  final String message;

  const LocationTrackingError(this.message);

  @override
  List<Object?> get props => [message];
}
