import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './permission_service.dart';



final permissionsStateProvider = StateNotifierProvider<PermissionsNotifier, AsyncValue<Permissions>>((ref) {
  PermissionService permissionState = ref.watch(permissionServiceProvider);
  return PermissionsNotifier(permissionState);
});




@immutable
class Permissions {
  final bool hasPermissions;
  final bool isLocationServiceEnabled;
  final bool isLocationPermissionGranted;
  final bool isBackgroundLocationPermissionGranted;
  final bool isActivityRecognitionPermissionGranted;
  final bool isBatterySaveModeDisabled;
  final bool isBatteryOptimizationDisabled;

  const Permissions({
    this.hasPermissions = false,
    this.isLocationServiceEnabled = false,
    this.isLocationPermissionGranted = false,
    this.isBackgroundLocationPermissionGranted = false,
    this.isActivityRecognitionPermissionGranted = false,
    this.isBatterySaveModeDisabled = false,
    this.isBatteryOptimizationDisabled = false,
  });

  Permissions copyWith({
    bool? hasPermissions,
    bool? isLocationServiceEnabled,
    bool? isLocationPermissionGranted,
    bool? isBackgroundLocationPermissionGranted,
    bool? isActivityRecognitionPermissionGranted,
    bool? isBatterySaveModeDisabled,
    bool? isBatteryOptimizationDisabled,
  }) {
    return Permissions(
      hasPermissions: hasPermissions ?? this.hasPermissions,
      isLocationServiceEnabled: isLocationServiceEnabled ?? this.isLocationServiceEnabled,
      isLocationPermissionGranted: isLocationPermissionGranted ?? this.isLocationPermissionGranted,
      isBackgroundLocationPermissionGranted: isBackgroundLocationPermissionGranted ?? this.isBackgroundLocationPermissionGranted,
      isActivityRecognitionPermissionGranted: isActivityRecognitionPermissionGranted ?? this.isActivityRecognitionPermissionGranted,
      isBatterySaveModeDisabled: isBatterySaveModeDisabled ?? this.isBatterySaveModeDisabled,
      isBatteryOptimizationDisabled: isBatteryOptimizationDisabled ?? this.isBatteryOptimizationDisabled,
    );
  }
}



class PermissionsNotifier extends StateNotifier<AsyncValue<Permissions>> {
  final PermissionService _permissionService;


  PermissionsNotifier(
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

      return Permissions(
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

