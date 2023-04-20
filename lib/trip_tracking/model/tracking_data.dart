

class TrackingData {
  final int? id;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final double speed;
  final String activity;


  const TrackingData({
    this.id,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.activity,
  });


  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'timestamp': timestamp.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'speed': speed,
      'activity': activity,
    };

    if (id != null) map['id'] = id;
    return map;
  }


  @override
  String toString() {
    return 'TrackingData(id: $id, timestamp: $timestamp, latitude: $latitude, longitude: $longitude, speed: $speed, activity: $activity)';
  }
}