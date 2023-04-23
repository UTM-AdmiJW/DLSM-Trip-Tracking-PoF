import 'dart:isolate';
import 'dart:async';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import 'package:dlsm_pof/common/index.dart';
import 'package:dlsm_pof/config/index.dart';
import 'package:dlsm_pof/trip/tracking/index.dart';



// The callback function for FlutterForegroundTask.setTaskHandler() 
// should always be a top-level function.
@pragma('vm:entry-point')
void startForegroundTaskCallback() {
  ForegroundTaskHandler handler = providerContainer.read(foregroundTaskHandlerProvider);
  FlutterForegroundTask.setTaskHandler(handler);
}



final foregroundTaskHandlerProvider = Provider<ForegroundTaskHandler>((ref)=> ForegroundTaskHandler(ref));



// The task handler class must have access to the Riverpod container to obtain the TripDetectionService.
class ForegroundTaskHandler extends RiverpodTaskHandlerService {

  SendPort? _sendPort;

  TripDetectionService get _tripDetectionService => ref.read(tripDetectionServiceProvider);

  ForegroundTaskHandler(ProviderRef ref) : super(ref);


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
  void onButtonPressed(String id) {
    _sendPort?.send(id);
  }


  // Called when the notification itself on the Android platform is pressed.
  //
  // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
  // this function to be called.
  @override
  void onNotificationPressed() {
    FlutterForegroundTask.launchApp("/");
  }
}



