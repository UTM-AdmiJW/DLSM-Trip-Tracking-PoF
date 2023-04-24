import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import 'package:dlsm_pof/foreground_task/index.dart';



class DashboardControls extends ConsumerStatefulWidget {
  const DashboardControls({super.key});
  @override ConsumerState<DashboardControls> createState() => _DashboardControlsState();
}


class _DashboardControlsState extends ConsumerState<DashboardControls> {

  ForegroundTaskService get _foregroundTaskService => ref.read(foregroundTaskServiceProvider);
  ForegroundTaskStateNotifier get _foregroundTaskStateNotifier => ref.read(foregroundTaskStateProvider.notifier);



  void navigateToPermissionsRoute() async {
    await Navigator.pushNamed(context, "/permissions");
  }

  void navigateToOngoingTripPointRoute() async {
    await Navigator.pushNamed(context, "/trip_points");
  }

  void startForegroundTask() async {
    await _foregroundTaskService.startForegroundTask();
    _foregroundTaskStateNotifier.updateForegroundTaskState();
  }

  void stopForegroundTask() async {
    await _foregroundTaskService.stopForegroundTask();
    _foregroundTaskStateNotifier.updateForegroundTaskState();
  }



  @override
  Widget build(BuildContext context) {
    final foregroundTaskState = ref.watch(foregroundTaskStateProvider);

    String state = foregroundTaskState.when(
      data: (data) => data.status == ForegroundTaskStatus.running ? "Running" : 
        data.status == ForegroundTaskStatus.stopped ? "Stopped" : 
        data.status == ForegroundTaskStatus.noPermission ? "No Permission" : 
        "Unknown",
      loading: () => "Loading",
      error: (error, stack) => "Error",
    );

    return Column(
      children: [
        Text("Foreground service: $state", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w300)),
        _buildForegroundControls(state),
        const Text("Trip Points", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300)),
        _buildTripControls(),
      ],
    );
  }



  Widget _buildForegroundControls(String state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
          onPressed: navigateToPermissionsRoute, 
          child: const Text("Permissions"),
        ),
        const SizedBox(width: 8),

        if (state == "Stopped") 
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
            onPressed: startForegroundTask, 
            child: const Text("Start Process")
          ),
        if (state == "Running") 
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: stopForegroundTask, 
            child: const Text("Stop Process")
          ),
      ],
    );
  }


  Widget _buildTripControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
          onPressed: ()=> Navigator.of(context).pushNamed("/trip_points"),
          child: const Text("View Ongoing Trip Points"),
        ),
      ],
    );
  }
}