import 'package:dlsm_pof/permissions/services/permissions_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dlsm_pof/trip_tracking/index.dart';



class ForegroundTaskButtonControls extends ConsumerStatefulWidget {
  const ForegroundTaskButtonControls({super.key});
  @override ConsumerState<ForegroundTaskButtonControls> createState() => _ForegroundTaskButtonControlsState();
}



class _ForegroundTaskButtonControlsState extends ConsumerState<ForegroundTaskButtonControls> {

  String state = "Loading...";

  void loadForegroundState() async {
    if ( ref.read(permissionsStateProvider).isLoading ) {
      setState(() { state = "Loading..."; });
    } else if ( ref.read(permissionsStateProvider).hasError ) {
      setState(() { state = "Error"; });
    } else if ( !ref.read(permissionsStateProvider).asData!.value.hasPermissions ) {
      setState(() { state = "No Permission!"; });
    } else if (await ref.read(foregroundTaskServiceProvider).isRunningService ) {
      setState(() { state = "Running"; });
    } else {
      setState(() { state = "Stopped"; });
    }
  }


  void navigateToPermissionsRoute() async {
    await Navigator
      .pushNamed(context, "/permissions")
      .then((_) => loadForegroundState());
  }

  void startForegroundTask() async {
    final ForegroundTaskService foregroundTaskService = ref.read(foregroundTaskServiceProvider);
    await foregroundTaskService.startForegroundTask();
    loadForegroundState();
  }

  void stopForegroundTask() async {
    final ForegroundTaskService foregroundTaskService = ref.read(foregroundTaskServiceProvider);
    await foregroundTaskService.stopForegroundTask();
    loadForegroundState();
  }


  @override
  void initState() {
    super.initState();
    loadForegroundState();
  }


  @override
  Widget build(BuildContext context) {
    final AsyncValue<Permissions> permissions = ref.watch(permissionsStateProvider);

    String state = 
      permissions.isLoading ? "Loading..." :
      permissions.hasError ? "Error" :
      !permissions.asData!.value.hasPermissions ? "No Permission!" :
      false ? "Running" : // TODO: This should be checked from state
      "Stopped";


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

            if (state == "Stopped") ...[
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                onPressed: startForegroundTask, 
                child: const Text("Start Process")
              ),
            ],
            // TODO: Remove this true
            if (state == "Running" || true) ...[
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                onPressed: stopForegroundTask, 
                child: const Text("Stop Process")
              ),
            ],
          ],
        ),
      ],
    );
  }
}