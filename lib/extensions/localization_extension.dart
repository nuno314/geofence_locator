import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

// Global navigator key để truy cập context từ mọi nơi
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Extension để lấy AppLocalizations dễ dàng
extension LocalizationExtension on AppLocalizations {
  static AppLocalizations? get trans {
    final context = navigatorKey.currentState?.context;
    if (context != null) {
      return AppLocalizations.of(context);
    }
    return null;
  }
}

// Hoặc tạo một class helper riêng
class L10n {
  static AppLocalizations? get trans {
    final context = navigatorKey.currentState?.context;
    if (context != null) {
      return AppLocalizations.of(context);
    }
    return null;
  }

  // Fallback method for test environment
  static String getString(String key, {String fallback = ''}) {
    final translations = trans;
    if (translations != null) {
      // Map common keys to their translations
      switch (key) {
        case 'active':
          return 'Active';
        case 'inactive':
          return 'Inactive';
        case 'location':
          return translations.location;
        case 'radius':
          return translations.radius;
        case 'status':
          return translations.status;
        case 'inside_geofence':
          return translations.insideGeofence;
        case 'outside_geofence':
          return translations.outsideGeofence;
        case 'current_location':
          return translations.currentLocation;
        case 'location_permission_required':
          return 'Location Permission Required';
        case 'notification_permission_required':
          return translations.notificationPermissionRequired;
        default:
          return fallback;
      }
    }
    return fallback;
  }
}
