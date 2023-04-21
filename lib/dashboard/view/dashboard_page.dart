
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/foreground_task_button_controls.dart';
import '../widgets/db_button_controls.dart';
import '../widgets/tracking_data_list_view.dart';

import 'package:dlsm_pof/config/index.dart';
import 'package:dlsm_pof/permissions/index.dart';
import 'package:dlsm_pof/trip_tracking/index.dart';



class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);
  @override ConsumerState createState() => _DashboardPageState();
}


class _DashboardPageState extends ConsumerState<DashboardPage> with WidgetsBindingObserver, RouteAware {
  
  int rowCount = 0;
  bool _isFetching = true;
  List<TripPoint> tripPointList = [];


  void setIsFetching(bool isFetching) => setState(() { _isFetching = isFetching; });

  
  // TODO: Currently, it only shows the TripPoints in the database.
  // TODO: The end product should show aggregated Trips instead. Long way to go.
  Future<void> updateData() async {
    setIsFetching(true);

    await updatePermissions();

    TripPointDA tripPointDA = ref.read(tripPointDAProvider);
    final rowCount = await tripPointDA.count();
    final tripPointList = await tripPointDA.selectAll();

    setState(() {
      this.rowCount = rowCount;
      this.tripPointList = tripPointList;
    });
    setIsFetching(false);
  }

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
    updateData();

    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ForegroundTaskService foregroundTaskService = ref.read(foregroundTaskServiceProvider);
      foregroundTaskService.refreshReceivePort();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    ForegroundTaskService foregroundTaskService = ref.read(foregroundTaskServiceProvider);
    foregroundTaskService.closeReceivePort();

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
        onRefresh: updateData,
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            const ForegroundTaskButtonControls(),
            DbButtonControls(onStart: ()=> setIsFetching(true), onComplete: updateData),
            const SizedBox(height: 12),
            Center(child: Text('Row count: $rowCount')),
            const SizedBox(height: 12),
            TripPointListView(tripPointList: tripPointList, isFetching: _isFetching),
          ],
        ),
      ) 
    );
  }
}
