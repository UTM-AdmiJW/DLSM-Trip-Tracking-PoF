
import 'package:flutter/material.dart';

import '../widgets/dashboard_controls.dart';
import '../widgets/history_trip_list.dart';

import 'package:dlsm_pof/common/index.dart';
import 'package:dlsm_pof/permissions/index.dart';
import 'package:dlsm_pof/trip/index.dart';



class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);
  @override ConsumerState createState() => _DashboardPageState();
}


class _DashboardPageState extends ConsumerState<DashboardPage> {

  PermissionsStateNotifier get _permissionsStateNotifier => ref.read(permissionsStateProvider.notifier);
  HistoryTripStateNotifier get _historyTripStateNotifier => ref.read(historyTripStateProvider.notifier);
  

  Future<void> _update() async {
    await _permissionsStateNotifier.updatePermissions();
    await _historyTripStateNotifier.update();
  }
  


  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _update();
    });
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DLSM Proof of Concept'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _update,
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: const [
            DashboardControls(),
            HistoryTripList(),
          ],
        ),
      ),
    );
  }
}
