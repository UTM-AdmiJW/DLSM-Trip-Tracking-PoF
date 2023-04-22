
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/foreground_task_service.dart';
import '../services/geolocator_service.dart';
import '../model/trip_point.dart';
import '../states/trip_point_state.dart';

import 'package:dlsm_pof/common/index.dart';



final tripTrackingServiceProvider = Provider<TripTrackingService>((ref) {
  ForegroundTaskService foregroundTaskService = ref.watch(foregroundTaskServiceProvider);
  GeolocatorService geolocatorService = ref.watch(geolocatorServiceProvider);
  TripPointStateNotifier tripPointStateNotifier = ref.watch(tripPointStateProvider.notifier);

  return TripTrackingService(
    foregroundTaskService, 
    geolocatorService,
    tripPointStateNotifier,
  );
});



class TripTrackingService {
  static const int _expiryMinutes = 5;
  static const int _distanceFilter = 20;

  final ForegroundTaskService _foregroundTaskService;
  final GeolocatorService _geolocatorService;
  final TripPointStateNotifier _tripPointStateNotifier;

  TripTrackingService(
    this._foregroundTaskService, 
    this._geolocatorService,
    this._tripPointStateNotifier,
  );

  StreamSubscription<Position>? _positionStreamSubscription;
  Timer? _expiryTimer;

  bool get isTripTracingLogicRunning => _positionStreamSubscription != null;


  void begin() {
    _foregroundTaskService.updateForegroundTask("Your trip is being tracked...");
    _setTimer();

    _positionStreamSubscription = _geolocatorService
      .getPositionStream(distanceFilter: _distanceFilter, locationAccuracy: LocationAccuracy.high)
      .listen(_positionStreamListener);
  }


  void stop() {
    _foregroundTaskService.updateForegroundTask("Checking for driving activity...");

    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;

    // TODO: Process TripPoints recorded throughout this trip, and reset TripPoint database.

    _cancelTimer();
  }


  Future<void> _positionStreamListener (Position position) async {
    TripPoint tripPoint = TripPoint(
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: DateTime.now().toLocal(),
      speed: position.speed,
    );

    globalLogger.i('Point: ${tripPoint.toString()}');
  
    bool isAdded = await _tripPointStateNotifier.addTripPoint(tripPoint);
    if (!isAdded) return;
    _setTimer();
  }


  void _setTimer() {
    _cancelTimer();
    _expiryTimer = Timer(const Duration(minutes: _expiryMinutes), stop);
  }

  void _cancelTimer() {
    _expiryTimer?.cancel();
    _expiryTimer = null;
  }
}