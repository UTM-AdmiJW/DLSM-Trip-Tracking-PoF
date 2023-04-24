
import 'dart:math';

import 'trip_point_service.dart';
import '../data_access/trip_point_da.dart';
import '../data_access/history_trip_da.dart';
import '../data_access/history_trip_point_da.dart';
import '../model/trip_point.dart';
import '../model/history_trip.dart';
import '../model/history_trip_point.dart';

import 'package:dlsm_pof/common/index.dart';




const double _minimumTripDistance = 1000;
const double _minimumNumberOfTripPoints = 20;



final tripPostProcessorServiceProvider = Provider<TripPostProcessorService>((ref)=> TripPostProcessorService(ref));


class TripPostProcessorService extends RiverpodService {
  
  TripPointService get _tripPointService => ref.read(tripPointServiceProvider);
  TripPointDA get _tripPointDA => ref.read(tripPointDAProvider);
  HistoryTripDA get _historyTripDA => ref.read(historyTripDAProvider);
  HistoryTripPointDA get _historyTripPointDA => ref.read(historyTripPointDAProvider);


  TripPostProcessorService(ProviderRef ref): super(ref);


  Future<bool> concludeTrip() async {
    TripPointService tripPointService = _tripPointService;
    TripPointDA tripPointDA = _tripPointDA;

    // Not a valid trip if 
    // 1. Trip is below _minimumTripDistance
    // 2. Trip has less than _minimumNumberOfTripPoints
    if (
      tripPointService.totalDistanceTravelled < _minimumTripDistance ||
      await tripPointDA.count() < _minimumNumberOfTripPoints
    ) {
      await tripPointService.reset();
      return false;
    }
    
    // Aggregate trip data and create a HistoryTrip object.
    List<TripPoint> tripPoints = await tripPointDA.selectAll();

    double startLat = tripPoints.first.latitude;
    double startLong = tripPoints.first.longitude;
    double endLat = tripPoints.last.latitude;
    double endLong = tripPoints.last.longitude;
    DateTime startTime = tripPoints.first.timestamp;
    DateTime endTime = tripPoints.last.timestamp;
    int durationSeconds = endTime.difference(startTime).inSeconds;
    double totalDistance = tripPointService.totalDistanceTravelled;
    double averageSpeed = 0, maxSpeed = 0;
    double averageAcceleration = 0, maxAcceleration = 0;
    double averageDeceleration = 0, maxDeceleration = 0;

    for (TripPoint tripPoint in tripPoints) {
      averageSpeed += tripPoint.speed;
      averageAcceleration += tripPoint.acceleration!;
      averageDeceleration += tripPoint.deceleration!;
      maxSpeed = max(maxSpeed, tripPoint.speed);
      maxAcceleration = max(maxAcceleration, tripPoint.acceleration!);
      maxDeceleration = min(maxDeceleration, tripPoint.deceleration!);
    }

    averageSpeed /= tripPoints.length;
    averageAcceleration /= tripPoints.length;
    averageDeceleration /= tripPoints.length;

    HistoryTrip historyTrip = HistoryTrip(
      startLat: startLat, 
      startLong: startLong, 
      endLat: endLat, 
      endLong: endLong, 
      startTime: startTime, 
      endTime: endTime, 
      durationSeconds: durationSeconds, 
      totalDistance: totalDistance, 
      averageSpeed: averageSpeed, 
      maxSpeed: maxSpeed, 
      averageAcceleration: averageAcceleration, 
      maxAcceleration: maxAcceleration, 
      averageDeceleration: averageDeceleration, 
      maxDeceleration: maxDeceleration
    );

    // Save HistoryTrip object to database.
    int tripId = await _historyTripDA.insert(historyTrip);

    // Map each TripPoint to HistoryTripPoint
    List<HistoryTripPoint> historyTripPoints = tripPoints.map((tripPoint) => HistoryTripPoint(
      tripId: tripId,
      latitude: tripPoint.latitude,
      longitude: tripPoint.longitude,
      timestamp: tripPoint.timestamp,
      speed: tripPoint.speed,
      acceleration: tripPoint.acceleration!,
      deceleration: tripPoint.deceleration!,
      isDistracted: tripPoint.isDistracted!,
      cornering: tripPoint.cornering!,
      totalDistance: tripPoint.totalDistance!,
    )).toList();

    // Save HistoryTripPoint objects to database.
    await _historyTripPointDA.insertAll(historyTripPoints);

    // Reset TripPointService
    await _tripPointService.reset();

    return true;
  }
}