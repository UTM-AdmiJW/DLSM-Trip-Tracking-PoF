import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dlsm_pof/trip_tracking/index.dart';



class ForegroundTaskButtonControls extends ConsumerStatefulWidget {
  const ForegroundTaskButtonControls({super.key});
  @override ConsumerState<ForegroundTaskButtonControls> createState() => _ForegroundTaskButtonControlsState();
}

class _ForegroundTaskButtonControlsState extends ConsumerState<ForegroundTaskButtonControls> {

  ForegroundTaskService get _foregroundTaskService => ref.read(foregroundTaskServiceProvider);
  ForegroundTaskStateNotifier get _foregroundTaskStateNotifier => ref.read(foregroundTaskStateProvider.notifier);


  Future<void> updateForegroundTaskState() async {
    _foregroundTaskStateNotifier.updateForegroundTaskState();
  }

  void navigateToPermissionsRoute() async {
    await Navigator.pushNamed(context, "/permissions");
  }

  void startForegroundTask() async {
    await _foregroundTaskService.startForegroundTask();
    updateForegroundTaskState();
  }

  void stopForegroundTask() async {
    await _foregroundTaskService.stopForegroundTask();
    updateForegroundTaskState();
  }


  @override
  void initState() {
    super.initState();
    updateForegroundTaskState();
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
        Text(
          "Foreground service: $state",
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w300)
        ),
        Row(
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
        ),
      ],
    );
  }
}