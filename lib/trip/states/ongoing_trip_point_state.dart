
import 'package:flutter/material.dart';

import '../data_access/ongoing_trip_point_da.dart';
import '../model/ongoing_trip_point.dart';

import 'package:dlsm_pof/common/index.dart';



final ongoingTripPointStateProvider = StateNotifierProvider<OngoingTripPointStateNotifier, AsyncValue<OngoingTripPointState>>((ref) {
  return OngoingTripPointStateNotifier(ref);
});



@immutable
class OngoingTripPointState {
  final int rowCount;
  final List<OngoingTripPoint> ongoingTripPoints;

  const OngoingTripPointState({
    required this.rowCount,
    required this.ongoingTripPoints,
  });
}



class OngoingTripPointStateNotifier extends RiverpodStateNotifier<AsyncValue<OngoingTripPointState>> {

  OngoingTripPointDA get _ongoingTripPointDA => ref.read(ongoingTripPointDAProvider);

  OngoingTripPointStateNotifier(StateNotifierProviderRef ref): super(const AsyncValue.loading(), ref) {
    update();
  }


  Future<void> update() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      int rowCount = await _ongoingTripPointDA.count();
      List<OngoingTripPoint> ongoingTripPoints = await _ongoingTripPointDA.selectAll();
      return OngoingTripPointState(
        rowCount: rowCount,
        ongoingTripPoints: ongoingTripPoints
      );
    });
  }

  Future<void> deleteAll() async {
    state = const AsyncValue.loading();
    await _ongoingTripPointDA.deleteAll();
    update();
  }
}

