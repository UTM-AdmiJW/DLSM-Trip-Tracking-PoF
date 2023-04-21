
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/activity_recognition_service.dart';
import '../services/foreground_task_service.dart';
import '../services/trip_tracking_service.dart';

import 'package:dlsm_pof/common/index.dart';




final tripDetectionServiceProvider = Provider<TripDetectionService>((ref) {
  Logger loggerService = ref.watch(loggerServiceProvider);
  ForegroundTaskService foregroundTaskService = ref.watch(foregroundTaskServiceProvider);
  ActivityRecognitionService activityRecognitionService = ref.watch(activityRecognitionServiceProvider);
  TripTrackingService tripTrackingService = ref.watch(tripTrackingServiceProvider);

  return TripDetectionService(
    loggerService, 
    foregroundTaskService, 
    activityRecognitionService, 
    tripTrackingService,
  );
});



class TripDetectionService {

  final Logger _logger;
  final ForegroundTaskService _foregroundTaskService;
  final ActivityRecognitionService _activityRecognitionService;
  final TripTrackingService _tripTrackingService;

  TripDetectionService(
    this._logger,
    this._foregroundTaskService, 
    this._activityRecognitionService,
    this._tripTrackingService,
  );

  void begin() {
    _foregroundTaskService.updateForegroundTask("Checking for driving activity...");

    _activityRecognitionService.beginListening((activity) {
      _logger.i("Activity Update: ${activity.type.name}");

      if (
        activity.type == ActivityType.IN_VEHICLE 
        && !_tripTrackingService.isTripTracingLogicRunning
      ) {
        _tripTrackingService.begin();
      }
    });
  }

  void stop() {
    _tripTrackingService.stop();
    _activityRecognitionService.stopListening();
  }
}