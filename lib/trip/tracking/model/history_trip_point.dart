
import 'trip_point.dart';


class HistoryTripPoint extends TripPoint {
  final int? tripId;

  HistoryTripPoint({
    int? id,
    this.tripId,
    required DateTime timestamp,
    required double latitude,
    required double longitude,
    required double speed,
    bool? isDistracted,
    double? acceleration,
    double? deceleration,
    double? cornering,
    double? totalDistance,
  }) : super(
    id: id,
    timestamp: timestamp,
    latitude: latitude,
    longitude: longitude,
    speed: speed,
    isDistracted: isDistracted,
    acceleration: acceleration,
    deceleration: deceleration,
    cornering: cornering,
    totalDistance: totalDistance,
  );


  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = super.toMap();
    if (tripId != null) map['tripId'] = tripId;
    return map;
  }


  @override
  HistoryTripPoint copyWith({
    int? id,
    int? tripId,
    DateTime? timestamp,
    double? latitude,
    double? longitude,
    double? speed,
    bool? isDistracted,
    double? acceleration,
    double? deceleration,
    double? cornering,
    double? totalDistance,
  }) {
    return HistoryTripPoint(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      timestamp: timestamp ?? this.timestamp,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      speed: speed ?? this.speed,
      isDistracted: isDistracted ?? this.isDistracted,
      acceleration: acceleration ?? this.acceleration,
      deceleration: deceleration ?? this.deceleration,
      cornering: cornering ?? this.cornering,
      totalDistance: totalDistance ?? this.totalDistance,
    );
  }



  @override
  String toString() {
    return '''
      HistoryTripPoint (
        id: $id,
        tripId: $tripId,
        timestamp: $timestamp,
        latitude: $latitude,
        longitude: $longitude,
        speed: $speed,
        isDistracted: $isDistracted,
        acceleration: $acceleration,
        deceleration: $deceleration,
        cornering: $cornering,
        totalDistance: $totalDistance,
      )
    ''';
  }
}