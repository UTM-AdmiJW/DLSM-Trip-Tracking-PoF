import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dlsm_pof/permissions/index.dart';



class PermissionsList extends ConsumerWidget {

  final PermissionsState permissions;


  const PermissionsList({
    super.key,
    required this.permissions,
  });


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PermissionService permissionService = ref.read(permissionsServiceProvider);
    
    bool isLocationServiceEnabled = permissions.isLocationServiceEnabled;
    bool isLocationPermissionGranted = permissions.isLocationPermissionGranted;
    bool isBackgroundLocationPermissionGranted = permissions.isBackgroundLocationPermissionGranted;
    bool isActivityRecognitionPermissionGranted = permissions.isActivityRecognitionPermissionGranted;
    bool isBatterySaveModeDisabled = permissions.isBatterySaveModeDisabled;
    bool isBatteryOptimizationDisabled = permissions.isBatteryOptimizationDisabled;


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
