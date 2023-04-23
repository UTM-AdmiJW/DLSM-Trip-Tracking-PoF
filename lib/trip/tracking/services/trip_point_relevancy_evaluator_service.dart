
import 'package:geolocator/geolocator.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart' as activity_recognition;

import '../model/trip_point.dart';

import 'package:dlsm_pof/common/index.dart';
import 'package:dlsm_pof/trip/core/index.dart';



final tripPointRelevancyEvaluatorServiceProvider = Provider<TripPointRelevancyEvaluatorService>((ref) {
  return TripPointRelevancyEvaluatorService(ref);
});



class RelevancyResult {
  final bool isRelevant;
  final String filterName;
  RelevancyResult(this.isRelevant, this.filterName);
}

typedef _NextFn = RelevancyResult Function();
typedef _FilterFn = RelevancyResult Function(TripPoint tripPoint, List<TripPoint> recentTripPoints, _NextFn next);




class TripPointRelevancyEvaluatorService extends RiverpodService {
  
  ActivityRecognitionService get _activityRecognitionService => ref.read(activityRecognitionServiceProvider);
  
  late final List<_FilterFn> _filters = [
    _firstPointFilter,
    _distanceFilter,
    _timeIntervalFilter,
    _accelerationFilter,
  ];


  TripPointRelevancyEvaluatorService(ProviderRef ref): super(ref);



  RelevancyResult isRelevant(TripPoint tripPoint, List<TripPoint> recentTripPoints) {
    RelevancyResult result = RelevancyResult(false, "Unfiltered");
    bool continueFiltering = true;

    RelevancyResult nextFn() {
      continueFiltering = true;
      return result;
    }

    for (Function filter in _filters) {
      if (!continueFiltering) break;
      continueFiltering = false;
      RelevancyResult returnValue = filter(tripPoint, recentTripPoints, nextFn);
      result = returnValue;
    }

    return result;
  }
  

  //======================
  // Filters
  //======================

  // If this is the first TripPoint, then it is relevant no matter what
  RelevancyResult _firstPointFilter(TripPoint tripPoint, List<TripPoint> recentTripPoints, _NextFn next) {
    if (recentTripPoints.isEmpty) return RelevancyResult(true, "First Point");
    return next();
  }

  // If the distance between the last TripPoint and this TripPoint is more than 50 meters, then it is relevant
  RelevancyResult _distanceFilter(TripPoint tripPoint, List<TripPoint> recentTripPoints, _NextFn next) {
    TripPoint lastTripPoint = recentTripPoints.last;
    double distance = Geolocator.distanceBetween(
      lastTripPoint.latitude, lastTripPoint.longitude,
      tripPoint.latitude, tripPoint.longitude,
    );
    if (distance > 50) return RelevancyResult(true, "Distance");
    return next();
  }

  // If it has been more than 1 minutes since the last TripPoint, then it is relevant,
  // Provided the activity is still "IN_VEHICLE"
  RelevancyResult _timeIntervalFilter(TripPoint tripPoint, List<TripPoint> recentTripPoints, _NextFn next) {
    TripPoint lastTripPoint = recentTripPoints.last;
    Duration timeInterval = tripPoint.timestamp.difference(lastTripPoint.timestamp);

    if (
      timeInterval.inSeconds > 30 && 
      _activityRecognitionService.currentActivity.type == activity_recognition.ActivityType.IN_VEHICLE
    ) {
      return RelevancyResult(true, "Time Interval");
    }

    return next();
  }


  // If the acceleration between the last TripPoint and this TripPoint is more than 5 m/s^2, then it is relevant
  RelevancyResult _accelerationFilter(TripPoint tripPoint, List<TripPoint> recentTripPoints, _NextFn next) {
    TripPoint lastTripPoint = recentTripPoints.last;
    double acceleration = (tripPoint.speed - lastTripPoint.speed) / tripPoint.timestamp.difference(lastTripPoint.timestamp).inSeconds;
    if ( acceleration.abs() > 3 ) return RelevancyResult(true, "Acceleration");
    return next();
  }


  // TODO: A Sharp Turning/Cornering Filter?
}