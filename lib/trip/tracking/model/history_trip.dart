
import 'package:dlsm_pof/common/index.dart';


class HistoryTrip extends SqfliteModel {

  final double startLat;
  final double startLong;
  final double endLat;
  final double endLong;
  final DateTime startTime;
  final DateTime endTime;
  final int durationSeconds;
  final double totalDistance;
  final double averageSpeed;
  final double maxSpeed;
  final double averageAcceleration;
  final double maxAcceleration;
  final double averageDeceleration;
  final double maxDeceleration;


  HistoryTrip({
    int? id,
    required this.startLat,
    required this.startLong,
    required this.endLat,
    required this.endLong,
    required this.startTime,
    required this.endTime,
    required this.durationSeconds,
    required this.totalDistance,
    required this.averageSpeed,
    required this.maxSpeed,
    required this.averageAcceleration,
    required this.maxAcceleration,
    required this.averageDeceleration,
    required this.maxDeceleration,
  }): super(id: id);


  @override
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'startLat': startLat,
      'startLong': startLong,
      'endLat': endLat,
      'endLong': endLong,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'durationSeconds': durationSeconds,
      'totalDistance': totalDistance,
      'averageSpeed': averageSpeed,
      'maxSpeed': maxSpeed,
      'averageAcceleration': averageAcceleration,
      'maxAcceleration': maxAcceleration,
      'averageDeceleration': averageDeceleration,
      'maxDeceleration': maxDeceleration,
    };

    if (id != null) map['id'] = id;
    return map;
  }


  HistoryTrip copyWith({
    int? id,
    double? startLat,
    double? startLong,
    double? endLat,
    double? endLong,
    DateTime? startTime,
    DateTime? endTime,
    int? durationSeconds,
    double? totalDistance,
    double? averageSpeed,
    double? maxSpeed,
    double? averageAcceleration,
    double? maxAcceleration,
    double? averageDeceleration,
    double? maxDeceleration,
  }) {
    return HistoryTrip(
      id: id ?? this.id,
      startLat: startLat ?? this.startLat,
      startLong: startLong ?? this.startLong,
      endLat: endLat ?? this.endLat,
      endLong: endLong ?? this.endLong,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      totalDistance: totalDistance ?? this.totalDistance,
      averageSpeed: averageSpeed ?? this.averageSpeed,
      maxSpeed: maxSpeed ?? this.maxSpeed,
      averageAcceleration: averageAcceleration ?? this.averageAcceleration,
      maxAcceleration: maxAcceleration ?? this.maxAcceleration,
      averageDeceleration: averageDeceleration ?? this.averageDeceleration,
      maxDeceleration: maxDeceleration ?? this.maxDeceleration,
    );
  }


  @override
  String toString() {
    return '''
      HistoryTrip(
        id: $id,
        startLat: $startLat,
        startLong: $startLong,
        endLat: $endLat,
        endLong: $endLong,
        startTime: $startTime,
        endTime: $endTime,
        durationSeconds: $durationSeconds,
        totalDistance: $totalDistance,
        averageSpeed: $averageSpeed,
        maxSpeed: $maxSpeed,
        averageAcceleration: $averageAcceleration,
        maxAcceleration: $maxAcceleration,
        averageDeceleration: $averageDeceleration,
        maxDeceleration: $maxDeceleration,
      )
    ''';
  }
}