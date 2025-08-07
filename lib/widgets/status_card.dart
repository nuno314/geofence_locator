import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/geofence/geofence_bloc.dart';
import '../blocs/geofence/geofence_state.dart';
import '../extensions/localization_extension.dart';

class StatusCard extends StatelessWidget {
  final int activeLocationsCount;
  final bool isLocationTracking;

  const StatusCard({
    super.key,
    required this.activeLocationsCount,
    this.isLocationTracking = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              L10n.trans?.status ?? 'Status',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${L10n.trans?.activeLocations ?? 'Active Locations'}: $activeLocationsCount',
            ),
            Text(
              '${L10n.trans?.locationTracking ?? 'Location Tracking'}: ${isLocationTracking ? (L10n.trans?.on ?? 'ON') : (L10n.trans?.off ?? 'OFF')}',
              style: TextStyle(
                color: isLocationTracking ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            BlocBuilder<GeofenceBloc, GeofenceState>(
              builder: (context, geofenceState) {
                int recentEvents = 0;
                if (geofenceState is GeofenceLoaded) {
                  recentEvents = geofenceState.recentEvents.length;
                }
                return Text(
                  '${L10n.trans?.recentEvents ?? 'Recent Events'}: $recentEvents',
                );
              },
            ),
            const SizedBox(height: 4),
            Text(
              isLocationTracking
                  ? (L10n.trans?.continuouslyMonitoring ??
                        '🔄 Continuously monitoring location')
                  : '⏸️ Location tracking paused',
              style: TextStyle(
                color: isLocationTracking ? Colors.green : Colors.orange,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
