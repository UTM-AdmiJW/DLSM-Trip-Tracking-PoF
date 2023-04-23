import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import 'package:dlsm_pof/common/index.dart';
import 'package:dlsm_pof/config/index.dart';
import 'package:dlsm_pof/trip/foreground_task/index.dart';
import 'package:dlsm_pof/permissions/index.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DlsmCore());
}



class DlsmCore extends StatelessWidget {
  const DlsmCore({super.key});

  @override
  Widget build(BuildContext context) {
    return UncontrolledProviderScope(
      container: providerContainer,
      child: const WithForegroundTask(
        child: DlsmPOF(),
      ),
    );
  }
}




class DlsmPOF extends ConsumerStatefulWidget {
  const DlsmPOF({Key? key}) : super(key: key);
  @override ConsumerState<DlsmPOF> createState() => DlsmPOFState();
}

class DlsmPOFState extends ConsumerState<DlsmPOF> {

  PermissionsStateNotifier get _permissionsStateNotifier => ref.read(permissionsStateProvider.notifier);
  ForegroundTaskStateNotifier get _foregroundTaskStateNotifier => ref.read(foregroundTaskStateProvider.notifier);
  ForegroundTaskService get _foregroundTaskService => ref.read(foregroundTaskServiceProvider);
  AsyncValue<PermissionsState> get _permissionsState => ref.read(permissionsStateProvider);


  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _startForegroundTaskIfPermissionsAllow();
      await _foregroundTaskService.refreshReceivePort();
    });
  }


  @override
  void dispose() {
    _foregroundTaskService.closeReceivePort();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DLSM Proof of Concept',
      theme: appTheme,
      routes: routes,
      initialRoute: '/',
      navigatorObservers: [routeObserver],
    );
  }



  Future<void> _startForegroundTaskIfPermissionsAllow() async {
    await _permissionsStateNotifier.updatePermissions();

    final permissionsState = _permissionsState.asData?.value;
    if (permissionsState == null || !permissionsState.hasPermissions) return;
    
    await _foregroundTaskService.startForegroundTask();

    _foregroundTaskStateNotifier.updateForegroundTaskState();
  }
}

