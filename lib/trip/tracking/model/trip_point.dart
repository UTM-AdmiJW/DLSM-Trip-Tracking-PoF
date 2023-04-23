

class TripPoint {
  final int? id;
  final String? filter;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final double speed;


  const TripPoint({
    this.id,
    this.filter,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.speed,
  });


  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'filter': filter,
      'timestamp': timestamp.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'speed': speed,
    };

    if (id != null) map['id'] = id;
    return map;
  }


  TripPoint copyWith({
    int? id,
    String? filter,
    DateTime? timestamp,
    double? latitude,
    double? longitude,
    double? speed,
  }) {
    return TripPoint(
      id: id ?? this.id,
      filter: filter ?? this.filter,
      timestamp: timestamp ?? this.timestamp,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      speed: speed ?? this.speed,
    );
  }


  @override
  String toString() {
    return '''
      TripPoint(
        id: $id,
        filter: $filter,
        timestamp: $timestamp,
        latitude: $latitude,
        longitude: $longitude,
        speed: $speed
      )
    ''';
  }
}