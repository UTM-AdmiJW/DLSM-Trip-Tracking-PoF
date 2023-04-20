import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



final batteryServiceProvider = Provider<BatteryService>((ref) {
  return BatteryService();
});



class BatteryService {
  final Battery _battery = Battery();

  Future<int> getBatteryLevel() async {
    return await _battery.batteryLevel;
  }

  Future<BatteryState> getBatteryState() async {
    return await _battery.batteryState;
  }

  Future<bool> isInBatterySaveMode() async {
    return await _battery.isInBatterySaveMode;
  }
}

