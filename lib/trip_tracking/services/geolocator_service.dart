import 'package:geolocator/geolocator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



final geolocatorServiceProvider = Provider<GeolocatorService>((ref) {
  return GeolocatorService();
});



class GeolocatorService {

  Future<Position> getCurrentPosition({
    LocationAccuracy desiredAccuracy = LocationAccuracy.best
  }) async {
    return await Geolocator.getCurrentPosition(desiredAccuracy: desiredAccuracy);
  }

  Future<Position?> getLastKnownPosition() async {
    return await Geolocator.getLastKnownPosition();
  }

  Stream<Position> getPositionStream({ 
    int distanceFilter = 0, 
    LocationAccuracy locationAccuracy = LocationAccuracy.best
  }) {
    LocationSettings locationSettings = LocationSettings(
      accuracy: locationAccuracy,
      distanceFilter: distanceFilter,
    );

    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }
}

