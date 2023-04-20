
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/foreground_task_service.dart';
import '../services/activity_recognition_service.dart';
import '../services/geolocator_service.dart';
import '../data_access/tracking_data_da.dart';
import '../model/tracking_data.dart';

import 'package:dlsm_pof/common/index.dart';




final tripTrackingServiceProvider = Provider<TripTrackingService>((ref) {
  ForegroundTaskService foregroundTaskService = ref.watch(foregroundTaskServiceProvider);
  ActivityRecognitionService activityRecognitionService = ref.watch(activityRecognitionServiceProvider);
  GeolocatorService geolocatorService = ref.watch(geolocatorServiceProvider);
  TrackingDataDA trackingDataDA = ref.watch(trackingDataDAProvider);
  Logger logger = ref.watch(loggerService);

  return TripTrackingService(foregroundTaskService, activityRecognitionService, geolocatorService, logger, trackingDataDA);
});



class TripTrackingService {
  static const int _expiryMinutes = 5;
  static const int _distanceFilter = 15;

  final Logger _logger;
  final ForegroundTaskService _foregroundTaskService;
  final ActivityRecognitionService _activityRecognitionService;
  final GeolocatorService _geolocatorService;
  final TrackingDataDA _trackingDataDA;

  TripTrackingService(
    this._foregroundTaskService, 
    this._activityRecognitionService,
    this._geolocatorService,
    this._logger,
    this._trackingDataDA,
  );

  StreamSubscription<Position>? _positionStreamSubscription;
  Timer? _expiryTimer;

  bool get isTripTracingLogicRunning => _positionStreamSubscription != null;


  void begin() {
    _foregroundTaskService.updateForegroundTask("Your trip is being tracked...");

    _positionStreamSubscription = _geolocatorService
      .getPositionStream(distanceFilter: _distanceFilter, locationAccuracy: LocationAccuracy.high)
      .listen(_positionStreamListener);

    _expiryTimer = Timer(const Duration(minutes: _expiryMinutes), () {
      stop();
    });
  }

  void stop() {
    _foregroundTaskService.updateForegroundTask("Checking for driving activity...");

    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;

    _expiryTimer?.cancel();
    _expiryTimer = null;
  }


  Future<void> _positionStreamListener (Position position) async {
    Activity activity = _activityRecognitionService.currentActivity;

    String time = DateTime.now().toLocal().toString().substring(11, 19);
    String status = "Time: $time | "
      "(${position.latitude} ${position.longitude}) | "
      "Speed: ${position.speed} m/s | "
      "Activity: ${activity.type.name}";


    await _trackingDataDA.insertTrackingData(
      TrackingData(
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: DateTime.now().toLocal(),
        speed: position.speed,
        activity: activity.type.name,
      )
    );

    _logger.i(status);
  }
}