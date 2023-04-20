import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/foreground_task_button_controls.dart';
import '../widgets/db_button_controls.dart';
import '../widgets/tracking_data_list_view.dart';

import 'package:dlsm_pof/trip_tracking/index.dart';



class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);
  @override ConsumerState createState() => _DashboardPageState();
}



class _DashboardPageState extends ConsumerState<DashboardPage> {
  bool _isFetching = true;
  int rowCount = 0;
  List<TrackingData> trackingDataList = [];


  void setIsFetching(bool isFetching) {
    setState(() { _isFetching = isFetching; });
  }


  Future<void> updateData() async {
    TrackingDataDA trackingDataDA = ref.read(trackingDataDAProvider);

    setIsFetching(true);

    final rowCount = await trackingDataDA.getNumberOfRows() ?? 0;
    final trackingDataList = await trackingDataDA.getAllTrackingData();

    setState(() {
      this.rowCount = rowCount;
      this.trackingDataList = trackingDataList;
    });
    setIsFetching(false);
  }



  @override
  void initState() {
    super.initState();
    updateData();

    // WidgetsBinding.instance.addPostFrameCallback is called after the build method is completed.
    // This is necessary because the receive port must be initialized after the app is resumed from the background.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ForegroundTaskService foregroundTaskService = ref.read(foregroundTaskServiceProvider);
      foregroundTaskService.refreshReceivePort();
    });

  }


  @override
  void dispose() {
    ForegroundTaskService foregroundTaskService = ref.read(foregroundTaskServiceProvider);
    foregroundTaskService.closeReceivePort();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    

    // WithForegroundTask prevents the app from closing when the foreground service is running.
    // This widget must be declared above the [Scaffold] widget.
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
            TrackingDataListView(trackingDataList: trackingDataList, isFetching: _isFetching),
          ],
        ),
      ) 
    );
  }
}
