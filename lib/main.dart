import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dlsm_pof/config/index.dart';
import 'package:dlsm_pof/trip_tracking/index.dart';
import 'package:dlsm_pof/dashboard/index.dart';
import 'package:dlsm_pof/permissions/index.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DlsmPOF());
}


final routes = <String, WidgetBuilder>{
  '/': (BuildContext context) => const DashboardPage(),
  '/permissions': (BuildContext context) => const PermissionsPage(),
};




class DlsmPOF extends ConsumerStatefulWidget {
  const DlsmPOF({Key? key}) : super(key: key);
  @override ConsumerState<DlsmPOF> createState() => DlsmPOFState();
}

class DlsmPOFState extends ConsumerState<DlsmPOF> {

  ActivityRecognitionService get _activityRecognitionService => ref.read(activityRecognitionServiceProvider);
  PermissionsStateNotifier get _permissionsStateNotifier => ref.read(permissionsStateProvider.notifier);
  ForegroundTaskService get _foregroundTaskService => ref.read(foregroundTaskServiceProvider);
  AsyncValue<PermissionsState> get _permissionsState => ref.read(permissionsStateProvider);


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_startForegroundTaskIfPermissionsAllow);
  }


  @override
  void dispose() {
    _activityRecognitionService.stopListening();
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
          routes: routes,
          navigatorObservers: [routeObserver],
        ),
      ),
    );
  }



  void _startForegroundTaskIfPermissionsAllow(Duration _) async {
    await _permissionsStateNotifier.updatePermissions();

    final permissionsState = _permissionsState.asData?.value;
    if (permissionsState == null || !permissionsState.hasPermissions) return;
    
    _foregroundTaskService.startForegroundTask();
  }
}

