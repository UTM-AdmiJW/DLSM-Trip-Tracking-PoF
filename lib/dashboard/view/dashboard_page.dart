
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/foreground_task_button_controls.dart';
import '../widgets/trip_point_button_controls.dart';

import 'package:dlsm_pof/config/index.dart';
import 'package:dlsm_pof/permissions/index.dart';



class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);
  @override ConsumerState createState() => _DashboardPageState();
}




// TODO: The dashboard should show Trips. Not Ongoing TripPoints.

class _DashboardPageState extends ConsumerState<DashboardPage> with WidgetsBindingObserver, RouteAware {
  
  Future<void> updatePermissions() async {
    final permissionStateNotifier = ref.read(permissionsStateProvider.notifier);
    await permissionStateNotifier.updatePermissions();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    updatePermissions();
  }

  @override void didPush() => updatePermissions();
  @override void didPopNext() => updatePermissions();


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DLSM Proof of Concept'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: updatePermissions,
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: const [
            ForegroundTaskButtonControls(),
            TripPointButtonControls(),
          ],
        ),
      ) 
    );
  }
}
