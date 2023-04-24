
import 'dart:math';
import 'package:geolocator/geolocator.dart';

import '../model/ongoing_trip_point.dart';
import '../data_access/ongoing_trip_point_da.dart';

import 'package:dlsm_pof/common/index.dart';


const int _ongoingTripPointStackSize = 25;
const int _recordedOngoingTripPointStackSize = 25;
const double _distanceThreshold = 25;
const int _timeThresholdSeconds = 30;



final ongoingTripPointServiceProvider = Provider<OngoingTripPointService>((ref)=> OngoingTripPointService(ref));


class OngoingTripPointService extends RiverpodService {
  
  List<OngoingTripPoint> _lastOngoingTripPoints = [];
  List<OngoingTripPoint> _lastRecordedOngoingTripPoints = [];

  double totalDistanceTravelled = 0;
  double currentMaximumSpeed = 0;
  double currentMaximumAcceleration = 0;
  double currentMaximumDeceleration = 0;
  
  OngoingTripPointDA get _ongoingTripPointDA => ref.read(ongoingTripPointDAProvider);
  ActivityRecognitionService get _activityRecognitionService => ref.read(activityRecognitionServiceProvider);


  OngoingTripPointService(ProviderRef ref): super(ref);


  /// Returns `true` if the provided tripPoint is added to the database.
  Future<bool> processPoint(Position position) async {

    OngoingTripPoint tripPoint = OngoingTripPoint(
      latitude: position.latitude,
      longitude: position.longitude,
      speed: position.speed,
      timestamp: DateTime.now()
    );

    // Update speed
    currentMaximumSpeed = max(currentMaximumSpeed, tripPoint.speed);

    // Update acceleration and deceleration
    if (_lastOngoingTripPoints.isNotEmpty) {
      OngoingTripPoint last = _lastOngoingTripPoints.last;
      double acceleration = (position.speed - last.speed) / (tripPoint.timestamp.difference(last.timestamp).inSeconds);
      currentMaximumAcceleration = max(currentMaximumAcceleration, acceleration);
      currentMaximumDeceleration = min(currentMaximumDeceleration, acceleration);
    }

    // Add to latest trip points stack
    _addToOngoingTripPointStack(tripPoint);

    // Don't record to DB if not IN_VEHICLE
    if (!_activityRecognitionService.isInVehicle) return false;
    // Don't record to DB if not exceeded distance threshold or time threshold (First trip point will be recorded)
    if (!_isExceededDistanceThreshold(tripPoint) && !_isExceededTimeThreshold(tripPoint)) return false;

    // Update total distance travelled
    totalDistanceTravelled += _getDistanceBetweenLastRecordedOngoingTripPoint(tripPoint);

    // Populate trip point with the rest of the data
    tripPoint = tripPoint.copyWith(
      totalDistance: totalDistanceTravelled,
      acceleration: currentMaximumAcceleration,
      deceleration: currentMaximumDeceleration,
      cornering: 0,
      isDistracted: false,
    );

    // Add to latest recorded trip points stack and DB
    _addToRecordedOngoingTripPointStack(tripPoint);
    await _ongoingTripPointDA.insert(tripPoint);

    // Reset cumulated acceleration, deceleration and speed
    currentMaximumAcceleration = 0;
    currentMaximumDeceleration = 0;
    currentMaximumSpeed = 0;

    return true;
  }


  Future<void> reset() async {
    _lastOngoingTripPoints = [];
    _lastRecordedOngoingTripPoints = [];
    totalDistanceTravelled = 0;
    currentMaximumSpeed = 0;
    currentMaximumAcceleration = 0;
    currentMaximumDeceleration = 0;

    await _ongoingTripPointDA.deleteAll();
  }



  void _addToOngoingTripPointStack(OngoingTripPoint tripPoint) {
    _lastOngoingTripPoints.add(tripPoint);
    if (_lastOngoingTripPoints.length > _ongoingTripPointStackSize) _lastOngoingTripPoints.removeAt(0);
  }

  void _addToRecordedOngoingTripPointStack(OngoingTripPoint tripPoint) {
    _lastRecordedOngoingTripPoints.add(tripPoint);
    if (_lastRecordedOngoingTripPoints.length > _recordedOngoingTripPointStackSize) _lastRecordedOngoingTripPoints.removeAt(0);
  }

  bool _isExceededDistanceThreshold(OngoingTripPoint tripPoint) {
    if (_lastRecordedOngoingTripPoints.isEmpty) return true;
    return _getDistanceBetweenLastRecordedOngoingTripPoint(tripPoint) > _distanceThreshold;
  }

  bool _isExceededTimeThreshold(OngoingTripPoint tripPoint) {
    if (_lastRecordedOngoingTripPoints.isEmpty) return true;
    return tripPoint.timestamp.difference(_lastRecordedOngoingTripPoints.last.timestamp).inSeconds > _timeThresholdSeconds;
  }

  double _getDistanceBetweenLastRecordedOngoingTripPoint(OngoingTripPoint tripPoint) {
    if (_lastRecordedOngoingTripPoints.isEmpty) return 0;

    return Geolocator.distanceBetween(
      _lastRecordedOngoingTripPoints.last.latitude, _lastRecordedOngoingTripPoints.last.longitude,
      tripPoint.latitude, tripPoint.longitude
    );
  }
}