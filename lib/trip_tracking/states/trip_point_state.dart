
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data_access/trip_point_da.dart';
import '../model/trip_point.dart';


// The number of latest TripPoints to be stored in the stack
const int stackSize = 5;

final tripPointStateProvider = StateNotifierProvider<TripPointStateNotifier, TripPointState>((ref) {
  TripPointDA tripPointDA = ref.watch(tripPointDAProvider);
  return TripPointStateNotifier(tripPointDA);
});



@immutable
class TripPointState {
  final List<TripPoint> mostRecentPoints;

  const TripPointState({
    this.mostRecentPoints = const [],
  });
}



class TripPointStateNotifier extends StateNotifier<TripPointState> {
  final TripPointDA _tripPointDA;

  TripPointStateNotifier(
    this._tripPointDA,
  ): super(const TripPointState());


  Future<bool> addTripPoint(TripPoint tripPoint) async {
    bool isRelevant = TripPointRelevancyEvaluator.isRelevant(tripPoint, state.mostRecentPoints);
    if (!isRelevant) return false;

    // Add to database
    await _tripPointDA.insert(tripPoint);

    // Append to most recent trip points 
    List<TripPoint> buffer = [...state.mostRecentPoints, tripPoint];
    if (buffer.length > stackSize) buffer.removeAt(0);
    state = TripPointState(mostRecentPoints: buffer);

    return true;
  }




  Future<void> clearTripPoints() async {
    clearMostRecentTripPoints();
    await _tripPointDA.deleteAll();
  }


  void clearMostRecentTripPoints() async {
    state = const TripPointState();
  }
}











class TripPointRelevancyEvaluator {
  
  static List filters = [
    firstPointFilter,
    timeIntervalFilter,
    distanceFilter,
    accelerationFilter,
  ];

  static bool isRelevant(TripPoint tripPoint, List<TripPoint> recentTripPoints) {
    bool relevant = false;
    bool continueFiltering = true;

    bool next() {
      continueFiltering = true;
      return false;
    }

    for (Function filter in filters) {
      if (!continueFiltering) break;
      continueFiltering = false;
      relevant = filter(tripPoint, recentTripPoints, next);
    }

    return relevant;
  }
  

  //======================
  // Filters
  //======================

  // If this is the first TripPoint, then it is relevant
  static bool firstPointFilter(TripPoint tripPoint, List<TripPoint> recentTripPoints, Function next) {
    if (recentTripPoints.isEmpty) return true;
    return next();
  }

  // If it has been more than 30 seconds since the last TripPoint, then it is relevant
  static bool timeIntervalFilter(TripPoint tripPoint, List<TripPoint> recentTripPoints, Function next) {
    TripPoint lastTripPoint = recentTripPoints.last;
    Duration timeInterval = tripPoint.timestamp.difference(lastTripPoint.timestamp);
    if (timeInterval.inSeconds > 30) return true;
    return next();
  }

  // If the distance between the last TripPoint and this TripPoint is more than 50 meters, then it is relevant
  static bool distanceFilter(TripPoint tripPoint, List<TripPoint> recentTripPoints, Function next) {
    TripPoint lastTripPoint = recentTripPoints.last;
    double distance = Geolocator.distanceBetween(
      lastTripPoint.latitude, lastTripPoint.longitude,
      tripPoint.latitude, tripPoint.longitude,
    );
    if (distance > 50) return true;
    return next();
  }


  // If the acceleration between the last TripPoint and this TripPoint is more than 5 m/s^2, then it is relevant
  static bool accelerationFilter(TripPoint tripPoint, List<TripPoint> recentTripPoints, Function next) {
    TripPoint lastTripPoint = recentTripPoints.last;
    double acceleration = (tripPoint.speed - lastTripPoint.speed) / tripPoint.timestamp.difference(lastTripPoint.timestamp).inSeconds;
    if ( acceleration.abs() > 5) return true;
    return next();
  }
}