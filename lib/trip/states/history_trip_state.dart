
import 'package:flutter/material.dart';

import '../data_access/history_trip_da.dart';
import '../model/history_trip.dart';

import 'package:dlsm_pof/common/index.dart';



final historyTripStateProvider = StateNotifierProvider<HistoryTripStateNotifier, AsyncValue<HistoryTripState>>((ref) {
  return HistoryTripStateNotifier(ref);
});



@immutable
class HistoryTripState {
  final int rowCount;
  final List<HistoryTrip> historyTrips;

  const HistoryTripState({
    required this.rowCount,
    required this.historyTrips,
  });
}



class HistoryTripStateNotifier extends RiverpodStateNotifier<AsyncValue<HistoryTripState>> {

  HistoryTripDA get _historyTripDA => ref.read(historyTripDAProvider);

  HistoryTripStateNotifier(StateNotifierProviderRef ref): super(const AsyncValue.loading(), ref) {
    update();
  }


  Future<void> update() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      int rowCount = await _historyTripDA.count();
      List<HistoryTrip> historyTrips = await _historyTripDA.selectAll();
      return HistoryTripState(
        rowCount: rowCount,
        historyTrips: historyTrips
      );
    });
  }

  Future<void> deleteAll() async {
    state = const AsyncValue.loading();
    await _historyTripDA.deleteAll();
    update();
  }
}

