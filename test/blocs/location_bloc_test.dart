import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geofence_locator/blocs/location/location_bloc.dart';
import 'package:geofence_locator/blocs/location/location_event.dart';
import 'package:geofence_locator/blocs/location/location_state.dart';
import 'package:geofence_locator/models/location.dart';
import 'package:geofence_locator/repositories/location_repository.dart';

void main() {
  group('LocationBloc', () {
    late LocationBloc locationBloc;
    late LocationRepository repository;

    setUp(() {
      repository = LocationRepositoryImpl();
      locationBloc = LocationBloc(locationRepository: repository);
    });

    tearDown(() {
      locationBloc.close();
    });

    test('initial state should be LocationInitial', () {
      expect(locationBloc.state, isA<LocationInitial>());
    });

    test(
      'should emit LocationLoading and LocationLoaded when LoadLocations is added',
      () async {
        final expectedStates = [
          isA<LocationInitial>(),
          isA<LocationLoading>(),
          isA<LocationLoaded>(),
        ];

        expectLater(locationBloc.stream, emitsInOrder(expectedStates));

        locationBloc.add(const LoadLocations());
      },
    );

    test(
      'should emit LocationLoading and LocationLoaded when FetchLocationsFromBackend is added',
      () async {
        final expectedStates = [
          isA<LocationInitial>(),
          isA<LocationLoading>(),
          isA<LocationLoaded>(),
        ];

        expectLater(locationBloc.stream, emitsInOrder(expectedStates));

        locationBloc.add(const FetchLocationsFromBackend());
      },
    );

    test(
      'should emit LocationStatusUpdated when UpdateLocationStatus is added',
      () async {
        // First load locations
        locationBloc.add(const LoadLocations());
        await Future.delayed(const Duration(milliseconds: 100));

        final expectedStates = [
          isA<LocationLoaded>(),
          isA<LocationStatusUpdated>(),
        ];

        expectLater(locationBloc.stream, emitsInOrder(expectedStates));

        locationBloc.add(
          const UpdateLocationStatus(locationId: '1', isActive: false),
        );
      },
    );

    test('should emit LocationLoaded when AddLocation is added', () async {
      // First load locations
      locationBloc.add(const LoadLocations());
      await Future.delayed(const Duration(milliseconds: 100));

      final newLocation = Location(
        id: '2',
        name: 'New Location',
        address: 'New Address',
        latitude: 15.0,
        longitude: 25.0,
        radius: 150,
        description: 'New Description',
        createdAt: DateTime.now(),
      );

      final expectedStates = [isA<LocationLoaded>(), isA<LocationLoaded>()];

      expectLater(locationBloc.stream, emitsInOrder(expectedStates));

      locationBloc.add(AddLocation(newLocation));
    });
  });
}
