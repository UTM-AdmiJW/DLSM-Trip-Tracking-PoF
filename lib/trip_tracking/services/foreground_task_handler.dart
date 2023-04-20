import 'dart:isolate';
import 'dart:async';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/trip_detection_service.dart';

import 'package:dlsm_pof/config/index.dart';



// The callback function for FlutterForegroundTask.setTaskHandler() 
// should always be a top-level function.
@pragma('vm:entry-point')
void startForegroundTaskCallback() {
  ForegroundTaskHandler handler = providerContainer.read(foregroundTaskHandlerProvider);
  FlutterForegroundTask.setTaskHandler(handler);
}



final foregroundTaskHandlerProvider = Provider<ForegroundTaskHandler>((ref) {
  TripDetectionService tripDetectionService = ref.watch(tripDetectionServiceProvider);
  return ForegroundTaskHandler(tripDetectionService);
});


class ForegroundTaskHandler extends TaskHandler {
  final TripDetectionService _tripDetectionService;

  SendPort? _sendPort;

  ForegroundTaskHandler(
    this._tripDetectionService
  );


  // The onStart function is called when the task is started.
  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    _sendPort = sendPort;
    _tripDetectionService.begin();
  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    _tripDetectionService.stop();
    await FlutterForegroundTask.clearAllData();
  }

  // The onEvent function is called periodically, based on the interval set in the
  // foregroundTaskOptions in FlutterForegroundTask.init.
  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {}



  // Called when the notification button on the Android platform is pressed.
  @override
  void onButtonPressed(String id) {}


  // Called when the notification itself on the Android platform is pressed.
  //
  // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
  // this function to be called.
  @override
  void onNotificationPressed() {
    FlutterForegroundTask.launchApp("/");
    _sendPort?.send('onNotificationPressed');
  }
}



