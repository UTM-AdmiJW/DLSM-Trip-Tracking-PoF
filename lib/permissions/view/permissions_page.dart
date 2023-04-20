import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/permissions_state.dart';
import '../widgets/permissions_list.dart';



class PermissionsPage extends ConsumerStatefulWidget {
  const PermissionsPage({super.key});
  @override ConsumerState<PermissionsPage> createState() => _PermissionsPageState();
}



class _PermissionsPageState extends ConsumerState<PermissionsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(permissionsStateProvider.notifier).updatePermissions();
    });
  }


  @override
  Widget build(BuildContext context) {
    AsyncValue<Permissions> permissions = ref.watch(permissionsStateProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Permissions'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: ref.read(permissionsStateProvider.notifier).updatePermissions,
        child: permissions.when(
          data: (permissions)=> PermissionsList(
            isLocationServiceEnabled: permissions.isLocationServiceEnabled,
            isLocationPermissionGranted: permissions.isLocationPermissionGranted,
            isBackgroundLocationPermissionGranted: permissions.isBackgroundLocationPermissionGranted,
            isBatteryOptimizationDisabled: permissions.isBatteryOptimizationDisabled,
            isActivityRecognitionPermissionGranted: permissions.isActivityRecognitionPermissionGranted,
            isBatterySaveModeDisabled: permissions.isBatterySaveModeDisabled,
          ),
          error: (err, stack)=> const Center(child: Text('Error')),
          loading: ()=> const Center(child: CircularProgressIndicator())
        )
      )
    );
  }
}