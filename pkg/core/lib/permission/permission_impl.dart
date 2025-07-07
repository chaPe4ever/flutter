import 'package:core/permission/permission_base.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

/// Permission implementation class
final class PermissionImpl implements PermissionBase {
  @override
  Future<CorePermissionStatus> getOrRequestPermissionStatus(
    CorePermissionType type, {
    VoidCallback? onDeniedCb,
    VoidCallback? onGrantedCb,
    VoidCallback? onPermanentlyDeniedCb,
    VoidCallback? onRestrictedCb,
    VoidCallback? onLimitedCb,
    VoidCallback? onProvisionalCb,
  }) async {
    return switch (type) {
      CorePermissionType.camera =>
        Permission.camera
            .onDeniedCallback(onDeniedCb)
            .onGrantedCallback(onGrantedCb)
            .onLimitedCallback(onLimitedCb)
            .onPermanentlyDeniedCallback(onPermanentlyDeniedCb)
            .onProvisionalCallback(onProvisionalCb)
            .onRestrictedCallback(onRestrictedCb)
            .request()
            .then((ps) => ps.toCorePermissionStatus),
      CorePermissionType.contacts =>
        Permission.contacts
            .onDeniedCallback(onDeniedCb)
            .onGrantedCallback(onGrantedCb)
            .onLimitedCallback(onLimitedCb)
            .onPermanentlyDeniedCallback(onPermanentlyDeniedCb)
            .onProvisionalCallback(onProvisionalCb)
            .onRestrictedCallback(onRestrictedCb)
            .request()
            .then((ps) => ps.toCorePermissionStatus),
      CorePermissionType.location =>
        Permission.location
            .onDeniedCallback(onDeniedCb)
            .onGrantedCallback(onGrantedCb)
            .onLimitedCallback(onLimitedCb)
            .onPermanentlyDeniedCallback(onPermanentlyDeniedCb)
            .onProvisionalCallback(onProvisionalCb)
            .onRestrictedCallback(onRestrictedCb)
            .request()
            .then((ps) => ps.toCorePermissionStatus),
      CorePermissionType.locationAlways =>
        Permission.locationAlways
            .onDeniedCallback(onDeniedCb)
            .onGrantedCallback(onGrantedCb)
            .onLimitedCallback(onLimitedCb)
            .onPermanentlyDeniedCallback(onPermanentlyDeniedCb)
            .onProvisionalCallback(onProvisionalCb)
            .onRestrictedCallback(onRestrictedCb)
            .request()
            .then((ps) => ps.toCorePermissionStatus),
      CorePermissionType.locationWhenInUse =>
        Permission.locationWhenInUse
            .onDeniedCallback(onDeniedCb)
            .onGrantedCallback(onGrantedCb)
            .onLimitedCallback(onLimitedCb)
            .onPermanentlyDeniedCallback(onPermanentlyDeniedCb)
            .onProvisionalCallback(onProvisionalCb)
            .onRestrictedCallback(onRestrictedCb)
            .request()
            .then((ps) => ps.toCorePermissionStatus),
      CorePermissionType.mediaLibrary =>
        Permission.mediaLibrary
            .onDeniedCallback(onDeniedCb)
            .onGrantedCallback(onGrantedCb)
            .onLimitedCallback(onLimitedCb)
            .onPermanentlyDeniedCallback(onPermanentlyDeniedCb)
            .onProvisionalCallback(onProvisionalCb)
            .onRestrictedCallback(onRestrictedCb)
            .request()
            .then((ps) => ps.toCorePermissionStatus),
      CorePermissionType.microphone =>
        Permission.microphone
            .onDeniedCallback(onDeniedCb)
            .onGrantedCallback(onGrantedCb)
            .onLimitedCallback(onLimitedCb)
            .onPermanentlyDeniedCallback(onPermanentlyDeniedCb)
            .onProvisionalCallback(onProvisionalCb)
            .onRestrictedCallback(onRestrictedCb)
            .request()
            .then((ps) => ps.toCorePermissionStatus),
      CorePermissionType.phone =>
        Permission.phone
            .onDeniedCallback(onDeniedCb)
            .onGrantedCallback(onGrantedCb)
            .onLimitedCallback(onLimitedCb)
            .onPermanentlyDeniedCallback(onPermanentlyDeniedCb)
            .onProvisionalCallback(onProvisionalCb)
            .onRestrictedCallback(onRestrictedCb)
            .request()
            .then((ps) => ps.toCorePermissionStatus),
      CorePermissionType.photos =>
        Permission.photos
            .onDeniedCallback(onDeniedCb)
            .onGrantedCallback(onGrantedCb)
            .onLimitedCallback(onLimitedCb)
            .onPermanentlyDeniedCallback(onPermanentlyDeniedCb)
            .onProvisionalCallback(onProvisionalCb)
            .onRestrictedCallback(onRestrictedCb)
            .request()
            .then((ps) => ps.toCorePermissionStatus),
      CorePermissionType.photosAddOnly =>
        Permission.photosAddOnly
            .onDeniedCallback(onDeniedCb)
            .onGrantedCallback(onGrantedCb)
            .onLimitedCallback(onLimitedCb)
            .onPermanentlyDeniedCallback(onPermanentlyDeniedCb)
            .onProvisionalCallback(onProvisionalCb)
            .onRestrictedCallback(onRestrictedCb)
            .request()
            .then((ps) => ps.toCorePermissionStatus),
      CorePermissionType.reminders =>
        Permission.reminders
            .onDeniedCallback(onDeniedCb)
            .onGrantedCallback(onGrantedCb)
            .onLimitedCallback(onLimitedCb)
            .onPermanentlyDeniedCallback(onPermanentlyDeniedCb)
            .onProvisionalCallback(onProvisionalCb)
            .onRestrictedCallback(onRestrictedCb)
            .request()
            .then((ps) => ps.toCorePermissionStatus),
      CorePermissionType.sensors =>
        Permission.sensors
            .onDeniedCallback(onDeniedCb)
            .onGrantedCallback(onGrantedCb)
            .onLimitedCallback(onLimitedCb)
            .onPermanentlyDeniedCallback(onPermanentlyDeniedCb)
            .onProvisionalCallback(onProvisionalCb)
            .onRestrictedCallback(onRestrictedCb)
            .request()
            .then((ps) => ps.toCorePermissionStatus),
      CorePermissionType.sms =>
        Permission.sms
            .onDeniedCallback(onDeniedCb)
            .onGrantedCallback(onGrantedCb)
            .onLimitedCallback(onLimitedCb)
            .onPermanentlyDeniedCallback(onPermanentlyDeniedCb)
            .onProvisionalCallback(onProvisionalCb)
            .onRestrictedCallback(onRestrictedCb)
            .request()
            .then((ps) => ps.toCorePermissionStatus),
      CorePermissionType.speech =>
        Permission.speech
            .onDeniedCallback(onDeniedCb)
            .onGrantedCallback(onGrantedCb)
            .onLimitedCallback(onLimitedCb)
            .onPermanentlyDeniedCallback(onPermanentlyDeniedCb)
            .onProvisionalCallback(onProvisionalCb)
            .onRestrictedCallback(onRestrictedCb)
            .request()
            .then((ps) => ps.toCorePermissionStatus),
      CorePermissionType.storage =>
        Permission.storage
            .onDeniedCallback(onDeniedCb)
            .onGrantedCallback(onGrantedCb)
            .onLimitedCallback(onLimitedCb)
            .onPermanentlyDeniedCallback(onPermanentlyDeniedCb)
            .onProvisionalCallback(onProvisionalCb)
            .onRestrictedCallback(onRestrictedCb)
            .request()
            .then((ps) => ps.toCorePermissionStatus),
      CorePermissionType.ignoreBatteryOptimizations =>
        Permission.ignoreBatteryOptimizations
            .onDeniedCallback(onDeniedCb)
            .onGrantedCallback(onGrantedCb)
            .onLimitedCallback(onLimitedCb)
            .onPermanentlyDeniedCallback(onPermanentlyDeniedCb)
            .onProvisionalCallback(onProvisionalCb)
            .onRestrictedCallback(onRestrictedCb)
            .request()
            .then((ps) => ps.toCorePermissionStatus),
      CorePermissionType.notification =>
        Permission.notification
            .onDeniedCallback(onDeniedCb)
            .onGrantedCallback(onGrantedCb)
            .onLimitedCallback(onLimitedCb)
            .onPermanentlyDeniedCallback(onPermanentlyDeniedCb)
            .onProvisionalCallback(onProvisionalCb)
            .onRestrictedCallback(onRestrictedCb)
            .request()
            .then((ps) => ps.toCorePermissionStatus),
      CorePermissionType.accessMediaLocation =>
        Permission.accessMediaLocation
            .onDeniedCallback(onDeniedCb)
            .onGrantedCallback(onGrantedCb)
            .onLimitedCallback(onLimitedCb)
            .onPermanentlyDeniedCallback(onPermanentlyDeniedCb)
            .onProvisionalCallback(onProvisionalCb)
            .onRestrictedCallback(onRestrictedCb)
            .request()
            .then((ps) => ps.toCorePermissionStatus),
      CorePermissionType.activityRecognition =>
        Permission.activityRecognition
            .onDeniedCallback(onDeniedCb)
            .onGrantedCallback(onGrantedCb)
            .onLimitedCallback(onLimitedCb)
            .onPermanentlyDeniedCallback(onPermanentlyDeniedCb)
            .onProvisionalCallback(onProvisionalCb)
            .onRestrictedCallback(onRestrictedCb)
            .request()
            .then((ps) => ps.toCorePermissionStatus),
      CorePermissionType.unknown =>
        Permission.unknown
            .onDeniedCallback(onDeniedCb)
            .onGrantedCallback(onGrantedCb)
            .onLimitedCallback(onLimitedCb)
            .onPermanentlyDeniedCallback(onPermanentlyDeniedCb)
            .onProvisionalCallback(onProvisionalCb)
            .onRestrictedCallback(onRestrictedCb)
            .request()
            .then((ps) => ps.toCorePermissionStatus),
      CorePermissionType.bluetooth =>
        Permission.bluetooth
            .onDeniedCallback(onDeniedCb)
            .onGrantedCallback(onGrantedCb)
            .onLimitedCallback(onLimitedCb)
            .onPermanentlyDeniedCallback(onPermanentlyDeniedCb)
            .onProvisionalCallback(onProvisionalCb)
            .onRestrictedCallback(onRestrictedCb)
            .request()
            .then((ps) => ps.toCorePermissionStatus),
      CorePermissionType.manageExternalStorage =>
        Permission.manageExternalStorage
            .onDeniedCallback(onDeniedCb)
            .onGrantedCallback(onGrantedCb)
            .onLimitedCallback(onLimitedCb)
            .onPermanentlyDeniedCallback(onPermanentlyDeniedCb)
            .onProvisionalCallback(onProvisionalCb)
            .onRestrictedCallback(onRestrictedCb)
            .request()
            .then((ps) => ps.toCorePermissionStatus),
      CorePermissionType.systemAlertWindow =>
        Permission.systemAlertWindow
            .onDeniedCallback(onDeniedCb)
            .onGrantedCallback(onGrantedCb)
            .onLimitedCallback(onLimitedCb)
            .onPermanentlyDeniedCallback(onPermanentlyDeniedCb)
            .onProvisionalCallback(onProvisionalCb)
            .onRestrictedCallback(onRestrictedCb)
            .request()
            .then((ps) => ps.toCorePermissionStatus),
      CorePermissionType.requestInstallPackages =>
        Permission.requestInstallPackages
            .onDeniedCallback(onDeniedCb)
            .onGrantedCallback(onGrantedCb)
            .onLimitedCallback(onLimitedCb)
            .onPermanentlyDeniedCallback(onPermanentlyDeniedCb)
            .onProvisionalCallback(onProvisionalCb)
            .onRestrictedCallback(onRestrictedCb)
            .request()
            .then((ps) => ps.toCorePermissionStatus),
      CorePermissionType.appTrackingTransparency =>
        Permission.appTrackingTransparency
            .onDeniedCallback(onDeniedCb)
            .onGrantedCallback(onGrantedCb)
            .onLimitedCallback(onLimitedCb)
            .onPermanentlyDeniedCallback(onPermanentlyDeniedCb)
            .onProvisionalCallback(onProvisionalCb)
            .onRestrictedCallback(onRestrictedCb)
            .request()
            .then((ps) => ps.toCorePermissionStatus),
      CorePermissionType.criticalAlerts =>
        Permission.criticalAlerts
            .onDeniedCallback(onDeniedCb)
            .onGrantedCallback(onGrantedCb)
            .onLimitedCallback(onLimitedCb)
            .onPermanentlyDeniedCallback(onPermanentlyDeniedCb)
            .onProvisionalCallback(onProvisionalCb)
            .onRestrictedCallback(onRestrictedCb)
            .request()
            .then((ps) => ps.toCorePermissionStatus),
      CorePermissionType.accessNotificationPolicy =>
        Permission.accessNotificationPolicy
            .onDeniedCallback(onDeniedCb)
            .onGrantedCallback(onGrantedCb)
            .onLimitedCallback(onLimitedCb)
            .onPermanentlyDeniedCallback(onPermanentlyDeniedCb)
            .onProvisionalCallback(onProvisionalCb)
            .onRestrictedCallback(onRestrictedCb)
            .request()
            .then((ps) => ps.toCorePermissionStatus),
      CorePermissionType.bluetoothScan =>
        Permission.bluetoothScan
            .onDeniedCallback(onDeniedCb)
            .onGrantedCallback(onGrantedCb)
            .onLimitedCallback(onLimitedCb)
            .onPermanentlyDeniedCallback(onPermanentlyDeniedCb)
            .onProvisionalCallback(onProvisionalCb)
            .onRestrictedCallback(onRestrictedCb)
            .request()
            .then((ps) => ps.toCorePermissionStatus),
      CorePermissionType.bluetoothAdvertise =>
        Permission.bluetoothAdvertise
            .onDeniedCallback(onDeniedCb)
            .onGrantedCallback(onGrantedCb)
            .onLimitedCallback(onLimitedCb)
            .onPermanentlyDeniedCallback(onPermanentlyDeniedCb)
            .onProvisionalCallback(onProvisionalCb)
            .onRestrictedCallback(onRestrictedCb)
            .request()
            .then((ps) => ps.toCorePermissionStatus),
      CorePermissionType.bluetoothConnect =>
        Permission.bluetoothConnect
            .onDeniedCallback(onDeniedCb)
            .onGrantedCallback(onGrantedCb)
            .onLimitedCallback(onLimitedCb)
            .onPermanentlyDeniedCallback(onPermanentlyDeniedCb)
            .onProvisionalCallback(onProvisionalCb)
            .onRestrictedCallback(onRestrictedCb)
            .request()
            .then((ps) => ps.toCorePermissionStatus),
      CorePermissionType.nearbyWifiDevices =>
        Permission.nearbyWifiDevices
            .onDeniedCallback(onDeniedCb)
            .onGrantedCallback(onGrantedCb)
            .onLimitedCallback(onLimitedCb)
            .onPermanentlyDeniedCallback(onPermanentlyDeniedCb)
            .onProvisionalCallback(onProvisionalCb)
            .onRestrictedCallback(onRestrictedCb)
            .request()
            .then((ps) => ps.toCorePermissionStatus),
      CorePermissionType.videos =>
        Permission.videos
            .onDeniedCallback(onDeniedCb)
            .onGrantedCallback(onGrantedCb)
            .onLimitedCallback(onLimitedCb)
            .onPermanentlyDeniedCallback(onPermanentlyDeniedCb)
            .onProvisionalCallback(onProvisionalCb)
            .onRestrictedCallback(onRestrictedCb)
            .request()
            .then((ps) => ps.toCorePermissionStatus),
      CorePermissionType.audio =>
        Permission.audio
            .onDeniedCallback(onDeniedCb)
            .onGrantedCallback(onGrantedCb)
            .onLimitedCallback(onLimitedCb)
            .onPermanentlyDeniedCallback(onPermanentlyDeniedCb)
            .onProvisionalCallback(onProvisionalCb)
            .onRestrictedCallback(onRestrictedCb)
            .request()
            .then((ps) => ps.toCorePermissionStatus),
      CorePermissionType.scheduleExactAlarm =>
        Permission.scheduleExactAlarm
            .onDeniedCallback(onDeniedCb)
            .onGrantedCallback(onGrantedCb)
            .onLimitedCallback(onLimitedCb)
            .onPermanentlyDeniedCallback(onPermanentlyDeniedCb)
            .onProvisionalCallback(onProvisionalCb)
            .onRestrictedCallback(onRestrictedCb)
            .request()
            .then((ps) => ps.toCorePermissionStatus),
      CorePermissionType.sensorsAlways =>
        Permission.sensorsAlways
            .onDeniedCallback(onDeniedCb)
            .onGrantedCallback(onGrantedCb)
            .onLimitedCallback(onLimitedCb)
            .onPermanentlyDeniedCallback(onPermanentlyDeniedCb)
            .onProvisionalCallback(onProvisionalCb)
            .onRestrictedCallback(onRestrictedCb)
            .request()
            .then((ps) => ps.toCorePermissionStatus),
      CorePermissionType.calendarWriteOnly =>
        Permission.calendarWriteOnly
            .onDeniedCallback(onDeniedCb)
            .onGrantedCallback(onGrantedCb)
            .onLimitedCallback(onLimitedCb)
            .onPermanentlyDeniedCallback(onPermanentlyDeniedCb)
            .onProvisionalCallback(onProvisionalCb)
            .onRestrictedCallback(onRestrictedCb)
            .request()
            .then((ps) => ps.toCorePermissionStatus),
      CorePermissionType.calendarFullAccess =>
        Permission.calendarFullAccess
            .onDeniedCallback(onDeniedCb)
            .onGrantedCallback(onGrantedCb)
            .onLimitedCallback(onLimitedCb)
            .onPermanentlyDeniedCallback(onPermanentlyDeniedCb)
            .onProvisionalCallback(onProvisionalCb)
            .onRestrictedCallback(onRestrictedCb)
            .request()
            .then((ps) => ps.toCorePermissionStatus),
      CorePermissionType.assistant =>
        Permission.assistant
            .onDeniedCallback(onDeniedCb)
            .onGrantedCallback(onGrantedCb)
            .onLimitedCallback(onLimitedCb)
            .onPermanentlyDeniedCallback(onPermanentlyDeniedCb)
            .onProvisionalCallback(onProvisionalCb)
            .onRestrictedCallback(onRestrictedCb)
            .request()
            .then((ps) => ps.toCorePermissionStatus),
    };
  }

  @override
  Future<bool> openAppSystemAppSettings() => openAppSettings();
}
