import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './battery_service.dart';

import 'package:dlsm_pof/common/index.dart';




final permissionServiceProvider = Provider<PermissionService>((ref) {
  Logger logger = ref.watch(loggerService);
  BatteryService batteryService = ref.watch(batteryServiceProvider);

  return PermissionService(batteryService, logger);
});



class PermissionService {
  final BatteryService _batteryService;
  final Logger _logger;

  PermissionService(
    this._batteryService,
    this._logger,
  );

  //======================================
  // Permission Checkers
  //======================================
  Future<bool> hasPermissions() async {
    return await isLocationServiceEnabled() &&
        await isLocationPermissionGranted() &&
        await isBackgroundLocationPermissionGranted() &&
        await isActivityRecognitionPermissionGranted() &&
        await isBatterySaveModeDisabled() &&
        await isBatteryOptimizationDisabled();
  }

  Future<bool> isLocationServiceEnabled() async {
    return Permission.location.serviceStatus.isEnabled;
  }

  Future<bool> isLocationPermissionGranted() async {
    return Permission.locationWhenInUse.isGranted;
  }

  Future<bool> isBackgroundLocationPermissionGranted() async {
    return Permission.locationAlways.isGranted;
  }

  Future<bool> isActivityRecognitionPermissionGranted() async {
    return Permission.activityRecognition.isGranted;
  }

  Future<bool> isBatterySaveModeDisabled() async {
    return !(await _batteryService.isInBatterySaveMode());
  }

  Future<bool> isBatteryOptimizationDisabled() async {
    return Permission.ignoreBatteryOptimizations.isGranted;
  }


  //======================================
  // Permission Requests
  //======================================
  Future<void> requestPermissions() async {
    await openLocationServiceSettingIfDisabled();
    await requestLocationPermission();
    await requestBackgroundLocationPermission();

    await requestActivityRecognitionPermission();
    await requestDisableBatteryOptimization();
  }

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


