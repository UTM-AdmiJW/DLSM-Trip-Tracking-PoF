import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/permission_service.dart';


// TODO: Change to listen to the permission state, 
// TODO: instead of having to pass in all the values through the constructor

class PermissionsList extends ConsumerWidget {
  final bool isLocationServiceEnabled;
  final bool isLocationPermissionGranted;
  final bool isBackgroundLocationPermissionGranted;
  final bool isActivityRecognitionPermissionGranted;
  final bool isBatterySaveModeDisabled;
  final bool isBatteryOptimizationDisabled;

  const PermissionsList({
    super.key,
    required this.isLocationServiceEnabled,
    required this.isLocationPermissionGranted,
    required this.isBackgroundLocationPermissionGranted,
    required this.isActivityRecognitionPermissionGranted,
    required this.isBatterySaveModeDisabled,
    required this.isBatteryOptimizationDisabled,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PermissionService permissionService = ref.watch(permissionServiceProvider);

    return ListView(
      children: [
        ListTile(
          title: const Text('Location Service'),
          trailing: Text(
            isLocationServiceEnabled ? 'Enabled' : 'Disabled',
            style: TextStyle(color: isLocationServiceEnabled ? Colors.green : Colors.red,),
          ),
          onTap: permissionService.openLocationServiceSettingIfDisabled,
        ),
        ListTile(
          title: const Text('Location Permission'),
          trailing: Text(
            isLocationPermissionGranted ? 'Granted' : 'Denied',
            style: TextStyle(color: isLocationPermissionGranted ? Colors.green : Colors.red,),
          ),
          onTap: permissionService.requestLocationPermission,
        ),
        ListTile(
          title: const Text('Background Location Permission'),
          trailing: Text(
            isBackgroundLocationPermissionGranted ? 'Granted' : 'Denied',
            style: TextStyle(color: isBackgroundLocationPermissionGranted ? Colors.green : Colors.red,),
          ),
          onTap: permissionService.requestBackgroundLocationPermission,
        ),
        ListTile(
          title: const Text('Activity Recognition Permission'),
          trailing: Text(
            isActivityRecognitionPermissionGranted ? 'Granted' : 'Denied',
            style: TextStyle(color: isActivityRecognitionPermissionGranted ? Colors.green : Colors.red,),
          ),
          onTap: permissionService.requestActivityRecognitionPermission,
        ),
        ListTile(
          title: const Text('Battery Save Mode'),
          trailing: Text(
            isBatterySaveModeDisabled ? 'Disabled' : 'Enabled',
            style: TextStyle(color: isBatterySaveModeDisabled ? Colors.green : Colors.red,),
          ),
        ),
        ListTile(
          title: const Text('Battery Optimization'),
          trailing: Text(
            isBatteryOptimizationDisabled ? 'Disabled' : 'Enabled',
            style: TextStyle(color: isBatteryOptimizationDisabled ? Colors.green : Colors.red,),
          ),
          onTap: permissionService.requestDisableBatteryOptimization,
        ),
      ],
    );
  }
}