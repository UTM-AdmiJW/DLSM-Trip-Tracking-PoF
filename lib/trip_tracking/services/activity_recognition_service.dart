import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';

import 'package:dlsm_pof/common/index.dart';



final activityRecognitionServiceProvider = Provider<ActivityRecognitionService>((ref) {
  Logger logger = ref.watch(loggerServiceProvider);
  return ActivityRecognitionService(logger);
});



class ActivityRecognitionService {
  final Logger _logger;

  StreamSubscription<Activity>? _activityStreamSubscription;
  Activity _currentActivity = Activity.unknown;

  FlutterActivityRecognition get activityRecognition => FlutterActivityRecognition.instance;
  Activity get currentActivity => _currentActivity;
  bool get isListening => _activityStreamSubscription != null;


  ActivityRecognitionService(this._logger);


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

