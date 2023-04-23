import 'package:battery_plus/battery_plus.dart';

import 'package:dlsm_pof/common/index.dart';



final batteryServiceProvider = Provider<BatteryService>((ref) => BatteryService(ref));



class BatteryService extends RiverpodService {
  final Battery _battery = Battery();

  BatteryService(ProviderRef ref) : super(ref);


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

