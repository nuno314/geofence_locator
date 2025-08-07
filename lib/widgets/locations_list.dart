import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/location.dart';
import '../extensions/localization_extension.dart';
import 'location_card.dart';

class LocationsList extends StatelessWidget {
  final List<Location> locations;
  final Position? currentPosition;
  final Function(Location)? onLocationTap;

  const LocationsList({
    super.key,
    required this.locations,
    required this.currentPosition,
    this.onLocationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.business, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  '${L10n.trans?.workLocations ?? 'Work Locations'} (${locations.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (locations.isEmpty)
              Center(
                child: Text(
                  L10n.trans?.noLocationsFound ??
                      'No locations found. Loading from backend...',
                  style: const TextStyle(color: Colors.grey),
                ),
              )
            else
              ...locations.map(
                (location) => LocationCard(
                  location: location,
                  currentPosition: currentPosition,
                  onTap: onLocationTap,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
