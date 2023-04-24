
import 'package:douglas_peucker/douglas_peucker.dart';

import 'package:dlsm_pof/common/index.dart';



class OngoingTripPoint extends SqfliteModel implements IDpPoint {

  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final double speed;
  final bool? isDistracted;
  final double? acceleration;
  final double? deceleration;
  final double? cornering;
  final double? totalDistance;

  @override double get x => latitude;
  @override double get y => longitude;


  OngoingTripPoint({
    int? id,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.speed,
    this.isDistracted,
    this.acceleration,
    this.deceleration,
    this.cornering,
    this.totalDistance,
  }) : super(id: id);


  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'timestamp': timestamp.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'speed': speed,
      'isDistracted': isDistracted == true ? 1 : 0,
      'acceleration': acceleration,
      'deceleration': deceleration,
      'cornering': cornering,
      'totalDistance': totalDistance,
    };

    if (id != null) map['id'] = id;
    return map;
  }


  OngoingTripPoint copyWith({
    int? id,
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
    return OngoingTripPoint(
      id: id ?? this.id,
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
      TripPoint (
        id: $id,
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