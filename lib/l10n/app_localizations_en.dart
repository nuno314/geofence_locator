// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Employee Geofence';

  @override
  String get currentLocation => 'Current Location';

  @override
  String get locationNotAvailable => 'Location not available';

  @override
  String get enableLocationTracking => 'Enable location tracking to start';

  @override
  String get autoUpdating => 'Auto-updating every 5 meters';

  @override
  String get status => 'Status';

  @override
  String get activeLocations => 'Active Locations';

  @override
  String get locationTracking => 'Location Tracking';

  @override
  String get recentEvents => 'Recent Events';

  @override
  String get continuouslyMonitoring => 'Continuously monitoring location';

  @override
  String get workLocations => 'Work Locations';

  @override
  String get noLocationsFound => 'No locations found. Loading from backend...';

  @override
  String get insideGeofence => 'INSIDE GEOFENCE';

  @override
  String get outsideGeofence => 'OUTSIDE GEOFENCE';

  @override
  String get distance => 'Distance';

  @override
  String get radius => 'Radius';

  @override
  String get address => 'Address';

  @override
  String get description => 'Description';

  @override
  String get recentEventsCount => 'Recent Events';

  @override
  String get geofenceHistory => 'Geofence History';

  @override
  String get allEvents => 'All Events';

  @override
  String get today => 'Today';

  @override
  String get thisWeek => 'This Week';

  @override
  String get thisMonth => 'This Month';

  @override
  String get noEventsFound => 'No events found';

  @override
  String get geofenceEventsWillAppear => 'Geofence events will appear here';

  @override
  String get entered => 'Entered';

  @override
  String get exited => 'Exited';

  @override
  String get event => 'Event';

  @override
  String get date => 'Date';

  @override
  String get location => 'Location';

  @override
  String get notes => 'Notes';

  @override
  String get close => 'Close';

  @override
  String get addCustomLocation => 'Add custom location';

  @override
  String get addNewJob => 'Add New Job';

  @override
  String get jobTitle => 'Job Title';

  @override
  String get jobLocation => 'Job Location';

  @override
  String get useCurrentLocation => 'Use Current Location';

  @override
  String get geofenceRadius => 'Geofence Radius (meters)';

  @override
  String get createJob => 'Create Job';

  @override
  String get pleaseEnterJobTitle => 'Please enter a job title';

  @override
  String get pleaseEnterDescription => 'Please enter a description';

  @override
  String get pleaseEnterWorkerId => 'Please enter a worker ID';

  @override
  String get pleaseEnterRadius => 'Please enter a radius';

  @override
  String get pleaseEnterValidRadius => 'Please enter a valid radius';

  @override
  String get errorGettingLocation => 'Error getting location';

  @override
  String get live => 'LIVE';

  @override
  String get off => 'OFF';

  @override
  String get on => 'ON';

  @override
  String get loading => 'Loading...';

  @override
  String get initializing => 'Initializing...';

  @override
  String get errorInitializing => 'Error initializing';

  @override
  String get errorLoadingJobs => 'Error loading jobs';

  @override
  String get errorLoadingLocations => 'Error loading locations';

  @override
  String get errorLoadingEvents => 'Error loading events';

  @override
  String get errorFetchingLocations => 'Error fetching locations';

  @override
  String get positionUpdated => 'Position updated';

  @override
  String get enteredGeofence => 'Entered geofence for location';

  @override
  String get exitedGeofence => 'Exited geofence for location';

  @override
  String get locationStreamError => 'Location stream error';

  @override
  String get errorGettingInitialPosition => 'Error getting initial position';

  @override
  String get errorGettingCurrentLocation => 'Error getting current location';

  @override
  String get offline => 'OFFLINE';

  @override
  String get enableLocation => 'Enable Location';

  @override
  String get locationPermission => 'Location Permission';

  @override
  String get locationPermissionMessage => 'This app needs location access to track your position and detect when you enter geofenced areas.';

  @override
  String get permissionFeatures => 'Features that require location:';

  @override
  String get realTimeTracking => 'Real-time location tracking';

  @override
  String get geofenceNotifications => 'Geofence entry/exit notifications';

  @override
  String get locationHistory => 'Location history and events';

  @override
  String get cancel => 'Cancel';

  @override
  String get enable => 'Enable';

  @override
  String get locationEnabled => 'Location access enabled!';

  @override
  String get locationError => 'Error enabling location';

  @override
  String get locationServicesDisabled => 'Location Services Disabled';

  @override
  String get locationServicesDisabledMessage => 'Please enable location services in your device settings to use this feature.';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get permissionDenied => 'Permission Denied';

  @override
  String get permissionDeniedMessage => 'Location permission was denied. You can enable it later in app settings.';

  @override
  String get permissionDeniedForever => 'Permission Denied Forever';

  @override
  String get permissionDeniedForeverMessage => 'Location permission was permanently denied. Please enable it in app settings to use this feature.';

  @override
  String get ok => 'OK';

  @override
  String get notificationPermission => 'Notification Permission';

  @override
  String get notificationPermissionMessage => 'This app needs notification permission to alert you when you enter or exit geofenced areas.';

  @override
  String get notificationFeatures => 'Notification features:';

  @override
  String get geofenceEntryAlert => 'Alert when entering geofence';

  @override
  String get geofenceExitAlert => 'Alert when exiting geofence';

  @override
  String get customizableAlerts => 'Customizable alert settings';

  @override
  String get skip => 'Skip';

  @override
  String get notificationEnabled => 'Notifications enabled!';

  @override
  String get notificationDenied => 'Notification permission denied';

  @override
  String get notificationPermissionDeniedForever => 'Notification Permission Denied Forever';

  @override
  String get notificationPermissionDeniedForeverMessage => 'Notification permission was permanently denied. Please enable it in app settings to receive geofence alerts.';

  @override
  String get notificationPermissionRequired => 'Notification Permission Required';

  @override
  String get notificationPermissionRequiredMessage => 'Enable notifications to receive alerts when entering or exiting geofenced areas.';

  @override
  String get enableNotifications => 'Enable Notifications';
}
