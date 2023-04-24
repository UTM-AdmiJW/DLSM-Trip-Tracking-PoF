
import 'dart:async';
import 'package:geolocator/geolocator.dart';

import '../services/trip_point_service.dart';
import '../services/trip_post_processor_service.dart';

import 'package:dlsm_pof/common/index.dart';
import 'package:dlsm_pof/trip/core/index.dart';
import 'package:dlsm_pof/trip/foreground_task/index.dart';


const int _expiryMinutes = 5;
const int _distanceFilter = 5;



final tripTrackingServiceProvider = Provider<TripTrackingService>((ref) => TripTrackingService(ref));



class TripTrackingService extends RiverpodService {
  
  StreamSubscription<Position>? _positionStreamSubscription;
  Timer? _expiryTimer;

  ForegroundTaskService get _foregroundTaskService => ref.read(foregroundTaskServiceProvider);
  GeolocatorService get _geolocatorService => ref.read(geolocatorServiceProvider);
  TripPointService get _tripPointService => ref.read(tripPointServiceProvider);
  TripPostProcessorService get _tripPostProcessorService => ref.read(tripPostProcessorServiceProvider);
  
  bool get isTripTracingLogicRunning => _positionStreamSubscription != null;

  TripTrackingService(ProviderRef ref): super(ref);



  Future<void> begin() async {
    await _tripPointService.reset();

    _foregroundTaskService.updateForegroundTask("Your trip is being tracked...");
    _setTimer();

    _positionStreamSubscription = _geolocatorService
      .getPositionStream(distanceFilter: _distanceFilter, locationAccuracy: LocationAccuracy.high)
      .listen(_positionStreamListener);
  }


  Future<void> stop() async {
    _foregroundTaskService.updateForegroundTask("Checking for driving activity...");

    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;

    _cancelTimer();
    await _tripPostProcessorService.concludeTrip();
  }


  Future<void> _positionStreamListener (Position position) async {
    bool isRecordedIntoDB = await _tripPointService.processPoint(position);
    if (!isRecordedIntoDB) return;
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