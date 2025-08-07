import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geofence_locator/blocs/geofence/geofence_bloc.dart';
import 'package:geofence_locator/blocs/geofence/geofence_event.dart' as bloc_event;
import 'package:geofence_locator/blocs/geofence/geofence_event.dart';
import 'package:geofence_locator/blocs/geofence/geofence_state.dart';
import 'package:geofence_locator/models/geofence_event.dart' as model;
import 'package:geofence_locator/repositories/geofence_repository.dart';

void main() {
  group('GeofenceBloc', () {
    late GeofenceBloc geofenceBloc;
    late GeofenceRepository repository;

    setUp(() {
      repository = GeofenceRepositoryImpl();
      geofenceBloc = GeofenceBloc(geofenceRepository: repository);
    });

    tearDown(() {
      geofenceBloc.close();
    });

    test('initial state should be GeofenceInitial', () {
      expect(geofenceBloc.state, isA<GeofenceInitial>());
    });

    test(
      'should emit GeofenceLoading and GeofenceLoaded when LoadGeofenceEvents is added',
      () async {
        final expectedStates = [
          isA<GeofenceInitial>(),
          isA<GeofenceLoading>(),
          isA<GeofenceLoaded>(),
        ];

        expectLater(geofenceBloc.stream, emitsInOrder(expectedStates));

        geofenceBloc.add(const LoadGeofenceEvents());
      },
    );

    test(
      'should emit GeofenceLoaded when AddGeofenceEventItem is added',
      () async {
        // First load events
        geofenceBloc.add(const LoadGeofenceEvents());
        await Future.delayed(const Duration(milliseconds: 100));

        final newEvent = model.GeofenceEvent(
          id: '1',
          locationId: 'loc1',
          locationName: 'Test Location',
          eventType: model.EventType.enter,
          latitude: 10.0,
          longitude: 20.0,
          timestamp: DateTime.now(),
        );

        final expectedStates = [isA<GeofenceLoaded>(), isA<GeofenceLoaded>()];

        expectLater(geofenceBloc.stream, emitsInOrder(expectedStates));

        geofenceBloc.add(AddGeofenceEventItem(newEvent));
      },
    );

    test(
      'should emit LocationEventsLoaded when GetEventsForLocation is added',
      () async {
        // First load events
        geofenceBloc.add(const LoadGeofenceEvents());
        await Future.delayed(const Duration(milliseconds: 100));

        final expectedStates = [
          isA<GeofenceLoaded>(),
          isA<LocationEventsLoaded>(),
        ];

        expectLater(geofenceBloc.stream, emitsInOrder(expectedStates));

        geofenceBloc.add(const GetEventsForLocation('loc1'));
      },
    );

    test('should emit GeofenceLoaded when GetRecentEvents is added', () async {
      // First load events
      geofenceBloc.add(const LoadGeofenceEvents());
      await Future.delayed(const Duration(milliseconds: 100));

      final expectedStates = [isA<GeofenceLoaded>(), isA<GeofenceLoaded>()];

      expectLater(geofenceBloc.stream, emitsInOrder(expectedStates));

      geofenceBloc.add(const GetRecentEvents());
    });

    test('should emit GeofenceLoaded when ClearAllEvents is added', () async {
      // First load events
      geofenceBloc.add(const LoadGeofenceEvents());
      await Future.delayed(const Duration(milliseconds: 100));

      final expectedStates = [isA<GeofenceLoaded>(), isA<GeofenceLoaded>()];

      expectLater(geofenceBloc.stream, emitsInOrder(expectedStates));

      geofenceBloc.add(const ClearAllEvents());
    });
  });
}
