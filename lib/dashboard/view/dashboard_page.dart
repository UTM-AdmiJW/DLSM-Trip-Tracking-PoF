
import 'package:flutter/material.dart';

import '../widgets/foreground_task_button_controls.dart';
import '../widgets/trip_point_button_controls.dart';

import 'package:dlsm_pof/common/index.dart';
import 'package:dlsm_pof/config/index.dart';
import 'package:dlsm_pof/permissions/index.dart';
import 'package:dlsm_pof/trip/tracking/index.dart';



class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);
  @override ConsumerState createState() => _DashboardPageState();
}


class _DashboardPageState extends ConsumerState<DashboardPage> with WidgetsBindingObserver, RouteAware {
  
  bool _isLoading = false;
  List<HistoryTrip> _historyTripList = [];

  HistoryTripDA get historyTripDA => ref.read(historyTripDAProvider);

  set isLoading(bool value) => setState(() => _isLoading = value);


  Future<void> update() async {
    isLoading = true;
    await _updatePermissions();
    await _updateHistoryTripList();
    isLoading = false;
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    _updatePermissions();
  }

  @override void didPush() => _updatePermissions();
  @override void didPopNext() => _updatePermissions();


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
      body: _isLoading ?
        const Center(child: CircularProgressIndicator()) :
        RefreshIndicator(
          onRefresh: update,
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: [
              const ForegroundTaskButtonControls(),
              const TripPointButtonControls(),

              for (final trip in _historyTripList)
                ListTile(
                  minVerticalPadding: 10,
                  title: Text(trip.startTime.toString().substring(0, 19)),
                  subtitle: Text(
                    "Start: (${trip.startLat.toStringAsFixed(5)}, ${trip.startLong.toStringAsFixed(5)}), "
                    "End: (${trip.endLat.toStringAsFixed(5)}, ${trip.endLong.toStringAsFixed(5)}), "
                    "Start time: ${trip.startTime.toString().substring(0, 19)}, "
                    "End time: ${trip.endTime.toString().substring(0, 19)}, "
                    "Duration: ${Duration(seconds: trip.durationSeconds).toString()}, "
                    "Distance: ${trip.totalDistance.toStringAsFixed(2)} m, "
                    "Max speed: ${trip.maxSpeed.toStringAsFixed(2)} m/s, "
                    "Avg speed: ${trip.averageSpeed.toStringAsFixed(2)} m/s, "
                    "Max acceleration: ${trip.maxAcceleration.toStringAsFixed(2)} m/s², "
                    "Avg acceleration: ${trip.averageAcceleration.toStringAsFixed(2)} m/s², "
                    "Max deceleration: ${trip.maxDeceleration.toStringAsFixed(2)} m/s², "
                    "Avg deceleration: ${trip.averageDeceleration.toStringAsFixed(2)} m/s², "
                  ),
                ),
            ],
          ),
        ) 
    );
  }



  
  Future<void> _updatePermissions() async {
    final permissionStateNotifier = ref.read(permissionsStateProvider.notifier);
    await permissionStateNotifier.updatePermissions();
  }

  Future<void> _updateHistoryTripList() async {
    final historyTripList = await historyTripDA.selectAll();
    setState(() => _historyTripList = historyTripList);
  }
}
