
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';

import './trip_tracking_service.dart';

import 'package:dlsm_pof/common/index.dart';
import 'package:dlsm_pof/foreground_task/index.dart';




final tripDetectionServiceProvider = Provider<TripDetectionService>((ref)=> TripDetectionService(ref));



class TripDetectionService extends RiverpodService {

  Logger get _logger => ref.read(loggerServiceProvider);
  ForegroundTaskService get _foregroundTaskService => ref.read(foregroundTaskServiceProvider);
  ActivityRecognitionService get _activityRecognitionService => ref.read(activityRecognitionServiceProvider);
  TripTrackingService get _tripTrackingService => ref.read(tripTrackingServiceProvider);

  TripDetectionService(ProviderRef ref): super(ref);


  void begin() {
    _foregroundTaskService.updateForegroundTask("Checking for driving activity...");

    _activityRecognitionService.beginListening((activity) {
      _logger.i("Activity Update: ${activity.type.name}");

      if (
        activity.type == ActivityType.IN_VEHICLE &&
        activity.confidence != ActivityConfidence.LOW &&
        !_tripTrackingService.isTripTracingLogicRunning
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