
import 'dart:math';
import 'package:geolocator/geolocator.dart';

import '../model/trip_point.dart';
import '../data_access/trip_point_da.dart';

import 'package:dlsm_pof/common/index.dart';
import 'package:dlsm_pof/trip/core/index.dart';


const int _tripPointStackSize = 25;
const int _recordedTripPointStackSize = 25;
const double _distanceThreshold = 25;
const int _timeThresholdSeconds = 30;



final tripPointServiceProvider = Provider<TripPointService>((ref)=> TripPointService(ref));


class TripPointService extends RiverpodService {
  
  List<TripPoint> _lastTripPoints = [];
  List<TripPoint> _lastRecordedTripPoints = [];

  double totalDistanceTravelled = 0;
  double currentMaximumSpeed = 0;
  double currentMaximumAcceleration = 0;
  double currentMaximumDeceleration = 0;
  
  TripPointDA get _tripPointDA => ref.read(tripPointDAProvider);
  ActivityRecognitionService get _activityRecognitionService => ref.read(activityRecognitionServiceProvider);


  TripPointService(ProviderRef ref): super(ref);


  /// Returns `true` if the provided tripPoint is added to the database.
  Future<bool> processPoint(Position position) async {

    TripPoint tripPoint = TripPoint(
      latitude: position.latitude,
      longitude: position.longitude,
      speed: position.speed,
      timestamp: DateTime.now()
    );

    // Update speed
    currentMaximumSpeed = max(currentMaximumSpeed, tripPoint.speed);

    // Update acceleration and deceleration
    if (_lastTripPoints.isNotEmpty) {
      TripPoint last = _lastTripPoints.last;
      double acceleration = (position.speed - last.speed) / (tripPoint.timestamp.difference(last.timestamp).inSeconds);
      currentMaximumAcceleration = max(currentMaximumAcceleration, acceleration);
      currentMaximumDeceleration = min(currentMaximumDeceleration, acceleration);
    }

    // Add to latest trip points stack
    _addToTripPointStack(tripPoint);

    // Don't record to DB if not IN_VEHICLE
    if (!_activityRecognitionService.isInVehicle) return false;
    // Don't record to DB if not exceeded distance threshold or time threshold (First trip point will be recorded)
    if (!_isExceededDistanceThreshold(tripPoint) && !_isExceededTimeThreshold(tripPoint)) return false;

    // Update total distance travelled
    totalDistanceTravelled += _getDistanceBetweenLastRecordedTripPoint(tripPoint);

    // Populate trip point with the rest of the data
    tripPoint = tripPoint.copyWith(
      totalDistance: totalDistanceTravelled,
      acceleration: currentMaximumAcceleration,
      deceleration: currentMaximumDeceleration,
      cornering: 0,
      isDistracted: false,
    );

    // Add to latest recorded trip points stack and DB
    _addToRecordedTripPointStack(tripPoint);
    await _tripPointDA.insert(tripPoint);

    // Reset cumulated acceleration, deceleration and speed
    currentMaximumAcceleration = 0;
    currentMaximumDeceleration = 0;
    currentMaximumSpeed = 0;

    return true;
  }


  Future<void> reset() async {
    _lastTripPoints = [];
    _lastRecordedTripPoints = [];
    totalDistanceTravelled = 0;
    currentMaximumSpeed = 0;
    currentMaximumAcceleration = 0;
    currentMaximumDeceleration = 0;

    await _tripPointDA.deleteAll();
  }



  void _addToTripPointStack(TripPoint tripPoint) {
    _lastTripPoints.add(tripPoint);
    if (_lastTripPoints.length > _tripPointStackSize) _lastTripPoints.removeAt(0);
  }

  void _addToRecordedTripPointStack(TripPoint tripPoint) {
    _lastRecordedTripPoints.add(tripPoint);
    if (_lastRecordedTripPoints.length > _recordedTripPointStackSize) _lastRecordedTripPoints.removeAt(0);
  }

  bool _isExceededDistanceThreshold(TripPoint tripPoint) {
    if (_lastRecordedTripPoints.isEmpty) return true;
    return _getDistanceBetweenLastRecordedTripPoint(tripPoint) > _distanceThreshold;
  }

  bool _isExceededTimeThreshold(TripPoint tripPoint) {
    if (_lastRecordedTripPoints.isEmpty) return true;
    return tripPoint.timestamp.difference(_lastRecordedTripPoints.last.timestamp).inSeconds > _timeThresholdSeconds;
  }

  double _getDistanceBetweenLastRecordedTripPoint(TripPoint tripPoint) {
    if (_lastRecordedTripPoints.isEmpty) return 0;

    return Geolocator.distanceBetween(
      _lastRecordedTripPoints.last.latitude, _lastRecordedTripPoints.last.longitude,
      tripPoint.latitude, tripPoint.longitude
    );
  }
}