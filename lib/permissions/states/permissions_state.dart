import 'package:flutter/material.dart';

import '../services/permission_service.dart';

import 'package:dlsm_pof/common/index.dart';



final permissionsStateProvider = StateNotifierProvider<PermissionsStateNotifier, AsyncValue<PermissionsState>>((ref) {
  return PermissionsStateNotifier(ref);
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



class PermissionsStateNotifier extends RiverpodStateNotifier<AsyncValue<PermissionsState>> {

  PermissionService get _permissionService => ref.read(permissionsServiceProvider);


  PermissionsStateNotifier(StateNotifierProviderRef ref): super(const AsyncValue.loading(), ref) {
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

