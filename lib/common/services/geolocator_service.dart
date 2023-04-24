
import 'package:geolocator/geolocator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../abstract/riverpod_service.dart';


final geolocatorServiceProvider = Provider<GeolocatorService>((ref) => GeolocatorService(ref));



class GeolocatorService extends RiverpodService {

  GeolocatorService(ProviderRef ref): super(ref);


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

