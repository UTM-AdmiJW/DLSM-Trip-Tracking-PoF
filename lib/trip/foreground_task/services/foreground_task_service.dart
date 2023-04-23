import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import './foreground_task_handler.dart';

import 'package:dlsm_pof/common/index.dart';



final foregroundTaskServiceProvider = Provider<ForegroundTaskService>((ref)=> ForegroundTaskService(ref));




class ForegroundTaskService extends RiverpodService {
  Logger get _logger => ref.read(loggerServiceProvider);
  ReceivePort? _receivePort;


  ForegroundTaskService(ProviderRef ref): super(ref) {
    FlutterForegroundTask.init(
      androidNotificationOptions: _androidNotificationOptions,
      iosNotificationOptions: _iosNotificationOptions,
      foregroundTaskOptions: _foregroundTaskOptions,
    );
  }


  Future<bool> startForegroundTask() async {
    // Register the receivePort before starting the service.
    final bool isRegisteredSuccessfully = _registerReceivePort(FlutterForegroundTask.receivePort);

    if (!isRegisteredSuccessfully) {
      _logger.e('Failed to register receivePort! Foreground task cannot be started.');
      return false;
    }

    // If the service is already running, do nothing. Otherwise, start the service for the first time.
    if (await FlutterForegroundTask.isRunningService) {
      _logger.i('Existing foreground task is already running.');
      return true;
    }

    return FlutterForegroundTask.startService(
      notificationTitle: _notificationTitle,
      notificationText: 'DLSM PoC foreground service has been started',
      callback: startForegroundTaskCallback,
    );
  }
  
  Future<bool> stopForegroundTask() {
    return FlutterForegroundTask.stopService();
  }

  // update Service
  Future<bool> updateForegroundTask(String text) {
    return FlutterForegroundTask.updateService(
      notificationTitle: _notificationTitle,
      notificationText: text,
    );
  }

  Future<bool> isRunning() async {
    return await FlutterForegroundTask.isRunningService;
  }


  Future<bool> refreshReceivePort() async {
    if ( !(await FlutterForegroundTask.isRunningService) ) return false;
    return _registerReceivePort( FlutterForegroundTask.receivePort );
  }

  Future<T?> getData<T>(String key) async {
    return await FlutterForegroundTask.getData<T>(key: key);
  }

  Future<bool> saveData(String key, dynamic value) async {
    return await FlutterForegroundTask.saveData(key: key, value: value);
  }

  void closeReceivePort() {
    _receivePort?.close();
    _receivePort = null;
  }



  bool _registerReceivePort(ReceivePort? newReceivePort) {
    if (newReceivePort == null) return false;

    closeReceivePort();
    _receivePort = newReceivePort;
    _registerReceiverPortListener();

    return _receivePort != null;
  }

  void _registerReceiverPortListener() {
    // From the receivePort, you can receive the data sent from the TaskHandler via sendPort.
    _receivePort?.listen((message) {
      if (message is String) {
        if (message == 'onNotificationPressed') {
          _logger.i('onNotificationPressed');
        }
      } else if (message is DateTime) {
        _logger.i('timestamp: ${message.toString()}');
      }
    });
  }
}





// Configurations for the foreground task.
const String _notificationTitle = "DLSM PoC Foreground Task";

final AndroidNotificationOptions _androidNotificationOptions = AndroidNotificationOptions(
  channelId: 'dlsm_poc_foreground_notification',
  channelName: 'DLSM PoC Foreground Task',
  channelDescription: 'This notification appears when the DLSM PoC foreground service is running.',
  channelImportance: NotificationChannelImportance.LOW,
  priority: NotificationPriority.LOW,
  iconData: const NotificationIconData(
    resType: ResourceType.mipmap,
    resPrefix: ResourcePrefix.ic,
    name: 'launcher',
    backgroundColor: Colors.orange,
  ),
  buttons: [
    const NotificationButton(id: 'sendButton', text: 'Send'),
    const NotificationButton(id: 'testButton', text: 'Test'),
  ],
);

const IOSNotificationOptions _iosNotificationOptions = IOSNotificationOptions(
  showNotification: true,
  playSound: false,
);

const ForegroundTaskOptions _foregroundTaskOptions = ForegroundTaskOptions(
  isOnceEvent: true,
  autoRunOnBoot: true,
  allowWakeLock: true,
  allowWifiLock: true,
);