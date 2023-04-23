
import 'dart:async';
import 'package:geolocator/geolocator.dart';

import '../model/trip_point.dart';
import '../states/trip_point_state.dart';

import 'package:dlsm_pof/common/index.dart';
import 'package:dlsm_pof/trip/core/index.dart';
import 'package:dlsm_pof/trip/foreground_task/index.dart';



final tripTrackingServiceProvider = Provider<TripTrackingService>((ref) => TripTrackingService(ref));



class TripTrackingService extends RiverpodService {
  static const int _expiryMinutes = 5;
  static const int _distanceFilter = 20;

  StreamSubscription<Position>? _positionStreamSubscription;
  Timer? _expiryTimer;

  Logger get _logger => ref.read(loggerServiceProvider);
  ForegroundTaskService get _foregroundTaskService => ref.read(foregroundTaskServiceProvider);
  GeolocatorService get _geolocatorService => ref.read(geolocatorServiceProvider);
  TripPointStateNotifier get _tripPointStateNotifier => ref.read(tripPointStateProvider.notifier);
  
  bool get isTripTracingLogicRunning => _positionStreamSubscription != null;

  TripTrackingService(ProviderRef ref): super(ref);



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

    _logger.i('Point: ${tripPoint.toString()}');
  
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