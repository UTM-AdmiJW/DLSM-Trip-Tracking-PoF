import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/permission_service.dart';



final permissionsStateProvider = StateNotifierProvider<PermissionsStateNotifier, AsyncValue<PermissionsState>>((ref) {
  PermissionService permissionService = ref.watch(permissionsServiceProvider);
  return PermissionsStateNotifier(permissionService);
});




@immutable
class PermissionsState {
  final bool hasPermissions;
  final bool isLocationServiceEnabled;
  final bool isLocationPermissionGranted;
  final bool isBackgroundLocationPermissionGranted;
  final bool isActivityRecognitionPermissionGranted;
  final bool isBatterySaveModeDisabled;
  final bool isBatteryOptimizationDisabled;

  const PermissionsState({
    this.hasPermissions = false,
    this.isLocationServiceEnabled = false,
    this.isLocationPermissionGranted = false,
    this.isBackgroundLocationPermissionGranted = false,
    this.isActivityRecognitionPermissionGranted = false,
    this.isBatterySaveModeDisabled = false,
    this.isBatteryOptimizationDisabled = false,
  });
}



class PermissionsStateNotifier extends StateNotifier<AsyncValue<PermissionsState>> {
  final PermissionService _permissionService;


  PermissionsStateNotifier(
    this._permissionService,
  ): super(const AsyncValue.loading()) {
    updatePermissions();
  }

  Future<void> updatePermissions() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      bool isLocationServiceEnabled = await _permissionService.isLocationServiceEnabled();
      bool isLocationPermissionGranted = await _permissionService.isLocationPermissionGranted();
      bool isBackgroundLocationPermissionGranted = await _permissionService.isBackgroundLocationPermissionGranted();
      bool isActivityRecognitionPermissionGranted = await _permissionService.isActivityRecognitionPermissionGranted();
      bool isBatterySaveModeDisabled = await _permissionService.isBatterySaveModeDisabled();
      bool isBatteryOptimizationDisabled = await _permissionService.isBatteryOptimizationDisabled();
      
      bool hasPermissions = isLocationServiceEnabled && isLocationPermissionGranted && 
        isBackgroundLocationPermissionGranted && isActivityRecognitionPermissionGranted && 
        isBatterySaveModeDisabled && isBatteryOptimizationDisabled;

      return PermissionsState(
        hasPermissions: hasPermissions,
        isLocationServiceEnabled: isLocationServiceEnabled,
        isLocationPermissionGranted: isLocationPermissionGranted,
        isBackgroundLocationPermissionGranted: isBackgroundLocationPermissionGranted,
        isActivityRecognitionPermissionGranted: isActivityRecognitionPermissionGranted,
        isBatterySaveModeDisabled: isBatterySaveModeDisabled,
        isBatteryOptimizationDisabled: isBatteryOptimizationDisabled,
      );
    });
  }
}

