import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

/// Permission interface class
abstract interface class PermissionBase {
  /// Request the user for access to this [CorePermissionType],
  /// if access hasn't already been grant access before.
  ///
  /// Additionally there are available optional callbacks to handle during the
  /// call [onDeniedCb], [onGrantedCb], [onPermanentlyDeniedCb],
  /// [onRestrictedCb], [onLimitedCb], [onProvisionalCb]
  ///
  /// Returns the new [CorePermissionStatus].
  Future<CorePermissionStatus> getOrRequestPermissionStatus(
    CorePermissionType type, {
    VoidCallback? onDeniedCb,
    VoidCallback? onGrantedCb,
    VoidCallback? onPermanentlyDeniedCb,
    VoidCallback? onRestrictedCb,
    VoidCallback? onLimitedCb,
    VoidCallback? onProvisionalCb,
  });

  /// Opens the app settings page.
  ///
  /// Returns true if the app settings page could be opened, otherwise false.
  Future<bool> openAppSystemAppSettings();
}

/// A special kind of permission used to access a service.
enum CorePermissionStatus {
  /// The user denied access to the requested feature, permission needs to be
  /// asked first.
  denied,

  /// Permission to the requested feature is permanently denied, the permission
  /// dialog will not be shown when requesting this permission. The user may
  /// still change the permission status in the settings.
  ///
  /// *On Android:*
  /// Android 11+ (API 30+): whether the user denied the permission for a second
  /// time.
  /// Below Android 11 (API 30): whether the user denied access to the requested
  /// feature and selected to never again show a request.
  ///
  /// *On iOS:*
  /// If the user has denied access to the requested feature.
  permanentlyDenied,

  /// The user has authorized this application for limited access. So far this
  /// is only relevant for the Photo Library picker.
  ///
  /// *Only supported on iOS (iOS14+).*
  limited,

  /// The user granted access to the requested feature.
  granted,

  /// The OS denied access to the requested feature. The user cannot change
  /// this app's status, possibly due to active restrictions such as parental
  /// controls being in place.
  ///
  /// *Only supported on iOS.*
  restricted,

  /// The application is provisionally authorized to post non-interruptive user
  /// notifications.
  ///
  /// *Only supported on iOS (iOS12+).*
  provisional
}

enum CorePermissionType {
  camera,
  contacts,
  location,
  locationAlways,
  locationWhenInUse,
  mediaLibrary,
  microphone,
  phone,
  photos,
  photosAddOnly,
  reminders,
  sensors,
  sms,
  speech,
  storage,
  ignoreBatteryOptimizations,
  notification,
  accessMediaLocation,
  activityRecognition,
  unknown,
  bluetooth,
  manageExternalStorage,
  systemAlertWindow,
  requestInstallPackages,
  appTrackingTransparency,
  criticalAlerts,
  accessNotificationPolicy,
  bluetoothScan,
  bluetoothAdvertise,
  bluetoothConnect,
  nearbyWifiDevices,
  videos,
  audio,
  scheduleExactAlarm,
  sensorsAlways,
  calendarWriteOnly,
  calendarFullAccess,
  assistant,
}

extension PermissionStatusX on PermissionStatus {
  CorePermissionStatus get toCorePermissionStatus => switch (this) {
        PermissionStatus.denied => CorePermissionStatus.denied,
        PermissionStatus.granted => CorePermissionStatus.granted,
        PermissionStatus.restricted => CorePermissionStatus.restricted,
        PermissionStatus.limited => CorePermissionStatus.limited,
        PermissionStatus.permanentlyDenied =>
          CorePermissionStatus.permanentlyDenied,
        PermissionStatus.provisional => CorePermissionStatus.provisional,
      };
}
