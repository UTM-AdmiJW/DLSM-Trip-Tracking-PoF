

class TripPoint {
  final int? id;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final double speed;


  const TripPoint({
    this.id,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.speed,
  });


  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'timestamp': timestamp.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'speed': speed,
    };

    if (id != null) map['id'] = id;
    return map;
  }


  @override
  String toString() {
    return '''
      TripPoint(
        id: $id,
        timestamp: $timestamp, 
        latitude: $latitude, 
        longitude: $longitude, 
        speed: $speed
      )
    ''';
  }
}