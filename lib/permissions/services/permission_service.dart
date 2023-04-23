import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

import './battery_service.dart';

import 'package:dlsm_pof/common/index.dart';




final permissionsServiceProvider = Provider<PermissionService>((ref)=> PermissionService(ref));



class PermissionService extends RiverpodService {
  BatteryService get _batteryService => ref.read(batteryServiceProvider);
  Logger get _logger => ref.read(loggerServiceProvider);

  PermissionService(ProviderRef ref): super(ref);


  Future<bool> isLocationServiceEnabled() async => Permission.location.serviceStatus.isEnabled;
  Future<bool> isLocationPermissionGranted() async => Permission.locationWhenInUse.isGranted;
  Future<bool> isBackgroundLocationPermissionGranted() => Permission.locationAlways.isGranted;
  Future<bool> isActivityRecognitionPermissionGranted() async => Permission.activityRecognition.isGranted;
  Future<bool> isBatterySaveModeDisabled() async => !(await _batteryService.isInBatterySaveMode());
  Future<bool> isBatteryOptimizationDisabled() async => Permission.ignoreBatteryOptimizations.isGranted;


  Future<void> openLocationServiceSettingIfDisabled() async {
    bool isEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isEnabled) await Geolocator.openLocationSettings();
  }


  Future<void> requestActivityRecognitionPermission() async {
    PermissionStatus status = await Permission.activityRecognition.request();
    _logPermissionStatusIfDenied('Activity Recognition', status);
  }


  Future<void> requestLocationPermission() async {
    PermissionStatus status = await Permission.locationWhenInUse.request();
    _logPermissionStatusIfDenied('Location When In Use', status);
  }


  Future<void> requestBackgroundLocationPermission() async {
    PermissionStatus status = await Permission.locationAlways.request();
    _logPermissionStatusIfDenied('Background Location', status);
  }


  Future<void> requestDisableBatteryOptimization() async {
    PermissionStatus status = await Permission.ignoreBatteryOptimizations.request();
    _logPermissionStatusIfDenied('Battery Optimization', status);
  }


  Future<void> requestSystemAlertWindowPermission() async {
    PermissionStatus status = await Permission.systemAlertWindow.request();
    _logPermissionStatusIfDenied('System Alert Window', status);
  }



  //======================================
  // Private Helper Methods
  //======================================
  void _logPermissionStatusIfDenied(String permissionName, PermissionStatus status) {
    if (status == PermissionStatus.denied) {
      _logger.e('$permissionName Permission is denied.');
    } else if (status == PermissionStatus.permanentlyDenied) {
      _logger.e("$permissionName Permission is Permanently denied");
    } else if (status == PermissionStatus.restricted) {
      _logger.e("$permissionName Permission is Restricted");
    } else if (status == PermissionStatus.limited) {
      _logger.e("$permissionName Permission is Limited");
    }
  }
}


