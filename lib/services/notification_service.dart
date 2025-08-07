import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Request notification permission first
    await _requestNotificationPermission();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
          onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
        );

    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel for Android
    await _createNotificationChannel();

    // Set up iOS notification categories
    await _setupIOSNotificationCategories();
  }

  Future<void> _requestNotificationPermission() async {
    try {
      // Request notification permission
      PermissionStatus status = await Permission.notification.request();

      if (status.isDenied) {
        print('Notification permission denied');
        // Show dialog to guide user to settings
        await _showNotificationPermissionDialog();
      } else if (status.isPermanentlyDenied) {
        print('Notification permission permanently denied');
        // Show dialog to open app settings
        await _showNotificationPermissionDialog();
      } else if (status.isGranted) {
        print('Notification permission granted');
      }
    } catch (e) {
      print('Error requesting notification permission: $e');
    }
  }

  Future<void> _showNotificationPermissionDialog() async {
    // This will be handled by the UI layer
    print('Notification permission dialog should be shown');
  }

  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'geofence_notifications',
      'Geofence Notifications',
      description: 'Notifications for geofence entry and exit events',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<void> showGeofenceNotification({
    required String title,
    required String body,
    required String locationName,
    required bool isEntering,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'geofence_notifications',
          'Geofence Notifications',
          channelDescription:
              'Notifications for geofence entry and exit events',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
          enableVibration: true,
          playSound: true,
          icon: '@mipmap/ic_launcher',
          color: Color(0xFF2196F3),
        );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          sound: 'default',
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      platformChannelSpecifics,
      payload: 'geofence_${isEntering ? 'enter' : 'exit'}_$locationName',
    );
  }

  Future<void> showLocationPermissionNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'permission_notifications',
          'Permission Notifications',
          channelDescription: 'Notifications for permission requests',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          showWhen: true,
        );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: false,
          presentSound: false,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _notifications.show(
      999,
      'Location Permission Required',
      'Please enable location permission to use geofence features',
      platformChannelSpecifics,
    );
  }

  Future<void> showNotificationPermissionNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'permission_notifications',
          'Permission Notifications',
          channelDescription: 'Notifications for permission requests',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
          showWhen: true,
        );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: false,
          presentSound: false,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _notifications.show(
      998,
      'Notification Permission Required',
      'Please enable notifications to receive geofence alerts',
      platformChannelSpecifics,
    );
  }

  void _onNotificationTapped(NotificationResponse response) {
    print('Notification tapped: ${response.payload}');
    // Handle notification tap
    if (response.payload?.startsWith('geofence_') == true) {
      // Navigate to history or show details
      print('Geofence notification tapped');
    }
  }

  Future<bool> isNotificationPermissionGranted() async {
    return await Permission.notification.isGranted;
  }

  Future<void> requestNotificationPermission() async {
    await _requestNotificationPermission();
  }

  // iOS specific methods
  void _onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) {
    print(
      'iOS: Local notification received - ID: $id, Title: $title, Body: $body',
    );
    // Handle local notification when app is in foreground
  }

  Future<void> _setupIOSNotificationCategories() async {
    try {
      final iOSPlugin = _notifications
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();

      if (iOSPlugin != null) {
        // Create notification categories for iOS
        await iOSPlugin.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

        print('iOS: Notification categories set up successfully');
      }
    } catch (e) {
      print('iOS: Error setting up notification categories: $e');
    }
  }
}
