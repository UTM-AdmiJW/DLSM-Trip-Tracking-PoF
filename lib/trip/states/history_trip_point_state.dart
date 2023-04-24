
import 'package:flutter/material.dart';

import '../data_access/history_trip_point_da.dart';
import '../model/history_trip_point.dart';

import 'package:dlsm_pof/common/index.dart';



final historyTripPointStateProvider = StateNotifierProvider<HistoryTripPointStateNotifier, AsyncValue<HistoryTripPointState>>((ref) {
  return HistoryTripPointStateNotifier(ref);
});



@immutable
class HistoryTripPointState {
  final int tripId;
  final int rowCount;
  final List<HistoryTripPoint> historyTripPoints;

  const HistoryTripPointState({
    required this.tripId,
    required this.rowCount,
    required this.historyTripPoints,
  });
}



class HistoryTripPointStateNotifier extends RiverpodStateNotifier<AsyncValue<HistoryTripPointState>> {

  HistoryTripPointDA get _historyTripPointDA => ref.read(historyTripPointDAProvider);

  HistoryTripPointStateNotifier(StateNotifierProviderRef ref): super(const AsyncValue.loading(), ref);


  Future<void> update(int tripId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      int rowCount = await _historyTripPointDA.count();
      List<HistoryTripPoint> historyTripPoints = await _historyTripPointDA.selectByTripId(tripId);
      return HistoryTripPointState(
        tripId: tripId,
        rowCount: rowCount,
        historyTripPoints: historyTripPoints
      );
    });
  }
}

