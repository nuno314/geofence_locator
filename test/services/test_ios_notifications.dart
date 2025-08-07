import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

/// Test script for iOS notifications
class IOSNotificationTester {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  /// Test iOS notification setup
  static Future<void> testIOSNotifications() async {
    print('🧪 Testing iOS Notifications...');

    // 1. Initialize notifications
    await _initializeIOSNotifications();

    // 2. Request permissions
    await _requestIOSPermissions();

    // 3. Test geofence notification
    await _testGeofenceNotification();

    // 4. Test background notification
    await _testBackgroundNotification();

    print('✅ iOS Notification testing completed!');
  }

  /// Initialize iOS notifications
  static Future<void> _initializeIOSNotifications() async {
    print('📱 Initializing iOS notifications...');

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings iOSSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
          onDidReceiveLocalNotification: (id, title, body, payload) {
            print('iOS: Local notification received - $title: $body');
          },
        );

    final InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        print('iOS: Notification tapped - ${response.payload}');
      },
    );

    print('✅ iOS notifications initialized');
  }

  /// Request iOS permissions
  static Future<void> _requestIOSPermissions() async {
    print('🔐 Requesting iOS permissions...');

    // Request notification permission
    final notificationStatus = await Permission.notification.request();
    print('iOS: Notification permission - ${notificationStatus.name}');

    // Request location permission
    final locationStatus = await Permission.location.request();
    print('iOS: Location permission - ${locationStatus.name}');

    // Request background location permission
    final backgroundLocationStatus = await Permission.locationAlways.request();
    print(
      'iOS: Background location permission - ${backgroundLocationStatus.name}',
    );

    print('✅ iOS permissions requested');
  }

  /// Test geofence notification
  static Future<void> _testGeofenceNotification() async {
    print('🎯 Testing geofence notification...');

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'geofence_test',
          'Geofence Test',
          channelDescription: 'Test notifications for geofence events',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
          enableVibration: true,
          playSound: true,
        );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
      badgeNumber: 1,
      categoryIdentifier: 'geofence_category',
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _notifications.show(
      1001,
      '🔔 Geofence Test',
      'Test notification for iOS geofence detection',
      details,
      payload: 'geofence_test_ios',
    );

    print('✅ Geofence notification sent');
  }

  /// Test background notification
  static Future<void> _testBackgroundNotification() async {
    print('🔄 Testing background notification...');

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'background_test',
          'Background Test',
          channelDescription: 'Test notifications for background events',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          showWhen: true,
        );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: false,
      presentSound: false,
      categoryIdentifier: 'background_category',
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _notifications.show(
      1002,
      '🔄 Background Test',
      'Test notification for iOS background operation',
      details,
      payload: 'background_test_ios',
    );

    print('✅ Background notification sent');
  }

  /// Check iOS notification status
  static Future<void> checkIOSNotificationStatus() async {
    print('📊 Checking iOS notification status...');

    // Check notification permission
    final notificationGranted = await Permission.notification.isGranted;
    print('iOS: Notification permission granted: $notificationGranted');

    // Check location permission
    final locationGranted = await Permission.location.isGranted;
    print('iOS: Location permission granted: $locationGranted');

    // Check background location permission
    final backgroundLocationGranted = await Permission.locationAlways.isGranted;
    print(
      'iOS: Background location permission granted: $backgroundLocationGranted',
    );

    // Check if notifications are enabled
    final iOSPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
  }
}

/// Main function to run iOS notification tests
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🚀 Starting iOS Notification Tests...');

  await IOSNotificationTester.testIOSNotifications();
  await IOSNotificationTester.checkIOSNotificationStatus();

  print('🎉 iOS Notification Tests Completed!');
}
