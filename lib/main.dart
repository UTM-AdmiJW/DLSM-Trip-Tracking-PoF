import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './app_theme.dart';

import 'package:dlsm_pof/trip_tracking/index.dart';
import 'package:dlsm_pof/dashboard/index.dart';
import 'package:dlsm_pof/permissions/index.dart';



// Top level provider container, which is used to provide dependencies to the entire app.
// Intiialized here since the foreground task service needs it to access the foreground handler.
ProviderContainer providerContainer = ProviderContainer();



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DlsmPOF());
}




class DlsmPOF extends ConsumerStatefulWidget {
  const DlsmPOF({Key? key}) : super(key: key);
  @override ConsumerState<DlsmPOF> createState() => DlsmPOFState();
}



class DlsmPOFState extends ConsumerState<DlsmPOF> {

  @override
  void initState() {
    super.initState();

    // After the first frame is rendered, ensure the application is initialized.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      PermissionService permissionService = providerContainer.read(permissionServiceProvider);
      if (!await permissionService.hasPermissions()) return;

      ForegroundTaskService foregroundTaskService = providerContainer.read(foregroundTaskServiceProvider);
      foregroundTaskService.startForegroundTask();
    });
  }


  @override
  void dispose() {
    ActivityRecognitionService activityRecognitionService = ref.read(activityRecognitionServiceProvider);
    activityRecognitionService.stopListening();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return UncontrolledProviderScope(
      container: providerContainer,
      child: WithForegroundTask(
        child: MaterialApp(
          title: 'DLSM Proof of Concept',
          theme: appTheme,
          initialRoute: '/',
          routes: {
            '/': (context) => const DashboardPage(),
            '/permissions': (context) => const PermissionsPage(),
          }
        ),
      ),
    );
  }
}

