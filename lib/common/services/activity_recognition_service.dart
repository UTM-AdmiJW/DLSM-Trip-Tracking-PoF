import 'dart:async';
import 'package:logger/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';

import 'logger_service.dart';
import '../abstract/riverpod_service.dart';



final activityRecognitionServiceProvider = Provider<ActivityRecognitionService>((ref) => ActivityRecognitionService(ref));



class ActivityRecognitionService extends RiverpodService {

  StreamSubscription<Activity>? _activityStreamSubscription;
  Activity _currentActivity = Activity.unknown;

  Logger get _logger => ref.read(loggerServiceProvider);

  FlutterActivityRecognition get activityRecognition => FlutterActivityRecognition.instance;
  Activity get currentActivity => _currentActivity;
  bool get isListening => _activityStreamSubscription != null;
  bool get isInVehicle => _currentActivity.type == ActivityType.IN_VEHICLE;


  ActivityRecognitionService(ProviderRef ref) : super(ref);


  void beginListening(Function(Activity) onData) {
    if (_activityStreamSubscription != null) return;

    _activityStreamSubscription = activityRecognition
      .activityStream
      .listen((activity) {
          _currentActivity = activity;
          onData(activity);
      });

    _logger.i('Activity Recognition is listening...');
  }

  void stopListening() {
    _activityStreamSubscription?.cancel();
    _activityStreamSubscription = null;

    _logger.i('Activity Recognition is stopped');
  }
}