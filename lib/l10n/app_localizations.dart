import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_th.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ms'),
    Locale('th'),
    Locale('vi')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Employee Geofence'**
  String get appTitle;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocation;

  /// No description provided for @locationNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Location not available'**
  String get locationNotAvailable;

  /// No description provided for @enableLocationTracking.
  ///
  /// In en, this message translates to:
  /// **'Enable location tracking to start'**
  String get enableLocationTracking;

  /// No description provided for @autoUpdating.
  ///
  /// In en, this message translates to:
  /// **'Auto-updating every 5 meters'**
  String get autoUpdating;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @activeLocations.
  ///
  /// In en, this message translates to:
  /// **'Active Locations'**
  String get activeLocations;

  /// No description provided for @locationTracking.
  ///
  /// In en, this message translates to:
  /// **'Location Tracking'**
  String get locationTracking;

  /// No description provided for @recentEvents.
  ///
  /// In en, this message translates to:
  /// **'Recent Events'**
  String get recentEvents;

  /// No description provided for @continuouslyMonitoring.
  ///
  /// In en, this message translates to:
  /// **'Continuously monitoring location'**
  String get continuouslyMonitoring;

  /// No description provided for @workLocations.
  ///
  /// In en, this message translates to:
  /// **'Work Locations'**
  String get workLocations;

  /// No description provided for @noLocationsFound.
  ///
  /// In en, this message translates to:
  /// **'No locations found. Loading from backend...'**
  String get noLocationsFound;

  /// No description provided for @insideGeofence.
  ///
  /// In en, this message translates to:
  /// **'INSIDE GEOFENCE'**
  String get insideGeofence;

  /// No description provided for @outsideGeofence.
  ///
  /// In en, this message translates to:
  /// **'OUTSIDE GEOFENCE'**
  String get outsideGeofence;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @radius.
  ///
  /// In en, this message translates to:
  /// **'Radius'**
  String get radius;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @recentEventsCount.
  ///
  /// In en, this message translates to:
  /// **'Recent Events'**
  String get recentEventsCount;

  /// No description provided for @geofenceHistory.
  ///
  /// In en, this message translates to:
  /// **'Geofence History'**
  String get geofenceHistory;

  /// No description provided for @allEvents.
  ///
  /// In en, this message translates to:
  /// **'All Events'**
  String get allEvents;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @noEventsFound.
  ///
  /// In en, this message translates to:
  /// **'No events found'**
  String get noEventsFound;

  /// No description provided for @geofenceEventsWillAppear.
  ///
  /// In en, this message translates to:
  /// **'Geofence events will appear here'**
  String get geofenceEventsWillAppear;

  /// No description provided for @entered.
  ///
  /// In en, this message translates to:
  /// **'Entered'**
  String get entered;

  /// No description provided for @exited.
  ///
  /// In en, this message translates to:
  /// **'Exited'**
  String get exited;

  /// No description provided for @event.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get event;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @addCustomLocation.
  ///
  /// In en, this message translates to:
  /// **'Add custom location'**
  String get addCustomLocation;

  /// No description provided for @addNewJob.
  ///
  /// In en, this message translates to:
  /// **'Add New Job'**
  String get addNewJob;

  /// No description provided for @jobTitle.
  ///
  /// In en, this message translates to:
  /// **'Job Title'**
  String get jobTitle;

  /// No description provided for @jobLocation.
  ///
  /// In en, this message translates to:
  /// **'Job Location'**
  String get jobLocation;

  /// No description provided for @useCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Use Current Location'**
  String get useCurrentLocation;

  /// No description provided for @geofenceRadius.
  ///
  /// In en, this message translates to:
  /// **'Geofence Radius (meters)'**
  String get geofenceRadius;

  /// No description provided for @createJob.
  ///
  /// In en, this message translates to:
  /// **'Create Job'**
  String get createJob;

  /// No description provided for @pleaseEnterJobTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter a job title'**
  String get pleaseEnterJobTitle;

  /// No description provided for @pleaseEnterDescription.
  ///
  /// In en, this message translates to:
  /// **'Please enter a description'**
  String get pleaseEnterDescription;

  /// No description provided for @pleaseEnterWorkerId.
  ///
  /// In en, this message translates to:
  /// **'Please enter a worker ID'**
  String get pleaseEnterWorkerId;

  /// No description provided for @pleaseEnterRadius.
  ///
  /// In en, this message translates to:
  /// **'Please enter a radius'**
  String get pleaseEnterRadius;

  /// No description provided for @pleaseEnterValidRadius.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid radius'**
  String get pleaseEnterValidRadius;

  /// No description provided for @errorGettingLocation.
  ///
  /// In en, this message translates to:
  /// **'Error getting location'**
  String get errorGettingLocation;

  /// No description provided for @live.
  ///
  /// In en, this message translates to:
  /// **'LIVE'**
  String get live;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'OFF'**
  String get off;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'ON'**
  String get on;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @initializing.
  ///
  /// In en, this message translates to:
  /// **'Initializing...'**
  String get initializing;

  /// No description provided for @errorInitializing.
  ///
  /// In en, this message translates to:
  /// **'Error initializing'**
  String get errorInitializing;

  /// No description provided for @errorLoadingJobs.
  ///
  /// In en, this message translates to:
  /// **'Error loading jobs'**
  String get errorLoadingJobs;

  /// No description provided for @errorLoadingLocations.
  ///
  /// In en, this message translates to:
  /// **'Error loading locations'**
  String get errorLoadingLocations;

  /// No description provided for @errorLoadingEvents.
  ///
  /// In en, this message translates to:
  /// **'Error loading events'**
  String get errorLoadingEvents;

  /// No description provided for @errorFetchingLocations.
  ///
  /// In en, this message translates to:
  /// **'Error fetching locations'**
  String get errorFetchingLocations;

  /// No description provided for @positionUpdated.
  ///
  /// In en, this message translates to:
  /// **'Position updated'**
  String get positionUpdated;

  /// No description provided for @enteredGeofence.
  ///
  /// In en, this message translates to:
  /// **'Entered geofence for location'**
  String get enteredGeofence;

  /// No description provided for @exitedGeofence.
  ///
  /// In en, this message translates to:
  /// **'Exited geofence for location'**
  String get exitedGeofence;

  /// No description provided for @locationStreamError.
  ///
  /// In en, this message translates to:
  /// **'Location stream error'**
  String get locationStreamError;

  /// No description provided for @errorGettingInitialPosition.
  ///
  /// In en, this message translates to:
  /// **'Error getting initial position'**
  String get errorGettingInitialPosition;

  /// No description provided for @errorGettingCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Error getting current location'**
  String get errorGettingCurrentLocation;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'OFFLINE'**
  String get offline;

  /// No description provided for @enableLocation.
  ///
  /// In en, this message translates to:
  /// **'Enable Location'**
  String get enableLocation;

  /// No description provided for @locationPermission.
  ///
  /// In en, this message translates to:
  /// **'Location Permission'**
  String get locationPermission;

  /// No description provided for @locationPermissionMessage.
  ///
  /// In en, this message translates to:
  /// **'This app needs location access to track your position and detect when you enter geofenced areas.'**
  String get locationPermissionMessage;

  /// No description provided for @permissionFeatures.
  ///
  /// In en, this message translates to:
  /// **'Features that require location:'**
  String get permissionFeatures;

  /// No description provided for @realTimeTracking.
  ///
  /// In en, this message translates to:
  /// **'Real-time location tracking'**
  String get realTimeTracking;

  /// No description provided for @geofenceNotifications.
  ///
  /// In en, this message translates to:
  /// **'Geofence entry/exit notifications'**
  String get geofenceNotifications;

  /// No description provided for @locationHistory.
  ///
  /// In en, this message translates to:
  /// **'Location history and events'**
  String get locationHistory;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @enable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enable;

  /// No description provided for @locationEnabled.
  ///
  /// In en, this message translates to:
  /// **'Location access enabled!'**
  String get locationEnabled;

  /// No description provided for @locationError.
  ///
  /// In en, this message translates to:
  /// **'Error enabling location'**
  String get locationError;

  /// No description provided for @locationServicesDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location Services Disabled'**
  String get locationServicesDisabled;

  /// No description provided for @locationServicesDisabledMessage.
  ///
  /// In en, this message translates to:
  /// **'Please enable location services in your device settings to use this feature.'**
  String get locationServicesDisabledMessage;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @permissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission Denied'**
  String get permissionDenied;

  /// No description provided for @permissionDeniedMessage.
  ///
  /// In en, this message translates to:
  /// **'Location permission was denied. You can enable it later in app settings.'**
  String get permissionDeniedMessage;

  /// No description provided for @permissionDeniedForever.
  ///
  /// In en, this message translates to:
  /// **'Permission Denied Forever'**
  String get permissionDeniedForever;

  /// No description provided for @permissionDeniedForeverMessage.
  ///
  /// In en, this message translates to:
  /// **'Location permission was permanently denied. Please enable it in app settings to use this feature.'**
  String get permissionDeniedForeverMessage;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @notificationPermission.
  ///
  /// In en, this message translates to:
  /// **'Notification Permission'**
  String get notificationPermission;

  /// No description provided for @notificationPermissionMessage.
  ///
  /// In en, this message translates to:
  /// **'This app needs notification permission to alert you when you enter or exit geofenced areas.'**
  String get notificationPermissionMessage;

  /// No description provided for @notificationFeatures.
  ///
  /// In en, this message translates to:
  /// **'Notification features:'**
  String get notificationFeatures;

  /// No description provided for @geofenceEntryAlert.
  ///
  /// In en, this message translates to:
  /// **'Alert when entering geofence'**
  String get geofenceEntryAlert;

  /// No description provided for @geofenceExitAlert.
  ///
  /// In en, this message translates to:
  /// **'Alert when exiting geofence'**
  String get geofenceExitAlert;

  /// No description provided for @customizableAlerts.
  ///
  /// In en, this message translates to:
  /// **'Customizable alert settings'**
  String get customizableAlerts;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @notificationEnabled.
  ///
  /// In en, this message translates to:
  /// **'Notifications enabled!'**
  String get notificationEnabled;

  /// No description provided for @notificationDenied.
  ///
  /// In en, this message translates to:
  /// **'Notification permission denied'**
  String get notificationDenied;

  /// No description provided for @notificationPermissionDeniedForever.
  ///
  /// In en, this message translates to:
  /// **'Notification Permission Denied Forever'**
  String get notificationPermissionDeniedForever;

  /// No description provided for @notificationPermissionDeniedForeverMessage.
  ///
  /// In en, this message translates to:
  /// **'Notification permission was permanently denied. Please enable it in app settings to receive geofence alerts.'**
  String get notificationPermissionDeniedForeverMessage;

  /// No description provided for @notificationPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Notification Permission Required'**
  String get notificationPermissionRequired;

  /// No description provided for @notificationPermissionRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications to receive alerts when entering or exiting geofenced areas.'**
  String get notificationPermissionRequiredMessage;

  /// No description provided for @enableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ms', 'th', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ms': return AppLocalizationsMs();
    case 'th': return AppLocalizationsTh();
    case 'vi': return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
