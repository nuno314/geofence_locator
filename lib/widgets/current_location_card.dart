import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../extensions/localization_extension.dart';
import '../services/notification_service.dart';

class CurrentLocationCard extends StatefulWidget {
  final Position? currentPosition;
  final bool isTracking;
  final VoidCallback? onEnableLocation;

  const CurrentLocationCard({
    super.key,
    required this.currentPosition,
    this.isTracking = false,
    this.onEnableLocation,
  });

  @override
  State<CurrentLocationCard> createState() => _CurrentLocationCardState();
}

class _CurrentLocationCardState extends State<CurrentLocationCard> {
  bool _notificationPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _checkNotificationPermission();
  }

  Future<void> _checkNotificationPermission() async {
    final status = await Permission.notification.status;
    setState(() {
      _notificationPermissionGranted = status.isGranted;
    });
  }

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
                const Icon(Icons.my_location, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  L10n.trans?.currentLocation ?? 'Current Location',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: widget.isTracking ? Colors.green : Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.isTracking
                        ? (L10n.trans?.live ?? 'LIVE')
                        : (L10n.trans?.offline ?? 'OFFLINE'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (widget.currentPosition != null) ...[
              Text(
                'Latitude: ${widget.currentPosition!.latitude.toStringAsFixed(6)}',
              ),
              Text(
                'Longitude: ${widget.currentPosition!.longitude.toStringAsFixed(6)}',
              ),
              const SizedBox(height: 8),
              Text(
                widget.isTracking
                    ? (L10n.trans?.autoUpdating ??
                          'Auto-updating every 5 meters')
                    : 'Location tracking stopped',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ] else ...[
              Text(
                L10n.trans?.locationNotAvailable ?? 'Location not available',
              ),
              const SizedBox(height: 8),
              Text(
                L10n.trans?.enableLocationTracking ??
                    'Enable location tracking to start',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed:
                      widget.onEnableLocation ??
                      () => _showLocationPermissionDialog(context),
                  icon: const Icon(Icons.location_on, size: 18),
                  label: Text(L10n.trans?.enableLocation ?? 'Enable Location'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
            // Notification permission section
            if (widget.currentPosition != null &&
                !_notificationPermissionGranted) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.notifications_off,
                          color: Colors.orange,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          L10n.trans?.notificationPermissionRequired ??
                              'Notification Permission Required',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      L10n.trans?.notificationPermissionRequiredMessage ??
                          'Enable notifications to receive alerts when entering or exiting geofenced areas.',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            _showNotificationPermissionDialog(context),
                        icon: const Icon(Icons.notifications, size: 18),
                        label: Text(
                          L10n.trans?.enableNotifications ??
                              'Enable Notifications',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showLocationPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.blue),
            const SizedBox(width: 8),
            Text(L10n.trans?.locationPermission ?? 'Location Permission'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              L10n.trans?.locationPermissionMessage ??
                  'This app needs location access to track your position and detect when you enter geofenced areas.',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    L10n.trans?.permissionFeatures ??
                        'Features that require location:',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildFeatureItem(
                    Icons.my_location,
                    L10n.trans?.realTimeTracking ??
                        'Real-time location tracking',
                  ),
                  _buildFeatureItem(
                    Icons.notifications,
                    L10n.trans?.geofenceNotifications ??
                        'Geofence entry/exit notifications',
                  ),
                  _buildFeatureItem(
                    Icons.history,
                    L10n.trans?.locationHistory ??
                        'Location history and events',
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(L10n.trans?.cancel ?? 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _requestLocationPermission(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: Text(L10n.trans?.enable ?? 'Enable'),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }

  Future<void> _requestLocationPermission(BuildContext context) async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showServiceDisabledDialog(context);
        return;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showPermissionDeniedDialog(context);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showPermissionDeniedForeverDialog(context);
        return;
      }

      // Location permission granted, now request notification permission
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        await _requestNotificationPermission(context);
      }

      // Permission granted, show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              L10n.trans?.locationEnabled ?? 'Location access enabled!',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              L10n.trans?.locationError ?? 'Error enabling location: $e',
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _requestNotificationPermission(BuildContext context) async {
    try {
      // Check current notification permission
      PermissionStatus status = await Permission.notification.status;

      if (status.isDenied) {
        // Show notification permission dialog
        _showNotificationPermissionDialog(context);
      } else if (status.isPermanentlyDenied) {
        // Show dialog to open app settings
        _showNotificationPermissionDialog(context);
      } else if (status.isGranted) {
        print('Notification permission already granted');
        await _checkNotificationPermission();
      }
    } catch (e) {
      print('Error checking notification permission: $e');
    }
  }

  void _showNotificationPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.notifications, color: Colors.orange),
            const SizedBox(width: 8),
            Text(
              L10n.trans?.notificationPermission ?? 'Notification Permission',
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              L10n.trans?.notificationPermissionMessage ??
                  'This app needs notification permission to alert you when you enter or exit geofenced areas.',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    L10n.trans?.notificationFeatures ??
                        'Notification features:',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildFeatureItem(
                    Icons.notification_important,
                    L10n.trans?.geofenceEntryAlert ??
                        'Alert when entering geofence',
                  ),
                  _buildFeatureItem(
                    Icons.notification_important,
                    L10n.trans?.geofenceExitAlert ??
                        'Alert when exiting geofence',
                  ),
                  _buildFeatureItem(
                    Icons.settings,
                    L10n.trans?.customizableAlerts ??
                        'Customizable alert settings',
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(L10n.trans?.skip ?? 'Skip'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _requestNotificationPermissionDirectly(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: Text(L10n.trans?.enable ?? 'Enable'),
          ),
        ],
      ),
    );
  }

  Future<void> _requestNotificationPermissionDirectly(
    BuildContext context,
  ) async {
    try {
      PermissionStatus status = await Permission.notification.request();

      if (status.isGranted) {
        await _checkNotificationPermission();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                L10n.trans?.notificationEnabled ?? 'Notifications enabled!',
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else if (status.isPermanentlyDenied) {
        if (context.mounted) {
          _showNotificationPermissionDeniedForeverDialog(context);
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                L10n.trans?.notificationDenied ??
                    'Notification permission denied',
              ),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      print('Error requesting notification permission: $e');
    }
  }

  void _showNotificationPermissionDeniedForeverDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.block, color: Colors.red),
            const SizedBox(width: 8),
            Text(
              L10n.trans?.notificationPermissionDeniedForever ??
                  'Notification Permission Denied Forever',
            ),
          ],
        ),
        content: Text(
          L10n.trans?.notificationPermissionDeniedForeverMessage ??
              'Notification permission was permanently denied. Please enable it in app settings to receive geofence alerts.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(L10n.trans?.cancel ?? 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text(L10n.trans?.openSettings ?? 'Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showServiceDisabledDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.location_off, color: Colors.orange),
            const SizedBox(width: 8),
            Text(
              L10n.trans?.locationServicesDisabled ??
                  'Location Services Disabled',
            ),
          ],
        ),
        content: Text(
          L10n.trans?.locationServicesDisabledMessage ??
              'Please enable location services in your device settings to use this feature.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(L10n.trans?.cancel ?? 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Geolocator.openLocationSettings();
            },
            child: Text(L10n.trans?.openSettings ?? 'Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.block, color: Colors.red),
            const SizedBox(width: 8),
            Text(L10n.trans?.permissionDenied ?? 'Permission Denied'),
          ],
        ),
        content: Text(
          L10n.trans?.permissionDeniedMessage ??
              'Location permission was denied. You can enable it later in app settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(L10n.trans?.ok ?? 'OK'),
          ),
        ],
      ),
    );
  }

  void _showPermissionDeniedForeverDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.block, color: Colors.red),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                L10n.trans?.permissionDeniedForever ??
                    'Permission Denied Forever',
              ),
            ),
          ],
        ),
        content: Text(
          L10n.trans?.permissionDeniedForeverMessage ??
              'Location permission was permanently denied. Please enable it in app settings to use this feature.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(L10n.trans?.cancel ?? 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Geolocator.openAppSettings();
            },
            child: Text(L10n.trans?.openSettings ?? 'Open Settings'),
          ),
        ],
      ),
    );
  }
}
