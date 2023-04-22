
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data_access/trip_point_da.dart';
import '../model/trip_point.dart';
import '../services/trip_point_relevancy_evaluator_service.dart';


// The number of latest TripPoints to be stored in the stack for relevancy evaluation
const int stackSize = 5;

final tripPointStateProvider = StateNotifierProvider<TripPointStateNotifier, TripPointState>((ref) {
  TripPointDA tripPointDA = ref.watch(tripPointDAProvider);
  TripPointRelevancyEvaluator tripPointRelevancyEvaluatorService = ref.watch(tripPointRelevancyEvaluatorServiceProvider);
  return TripPointStateNotifier(tripPointDA, tripPointRelevancyEvaluatorService);
});



@immutable
class TripPointState {
  final List<TripPoint> mostRecentPoints;

  const TripPointState({
    this.mostRecentPoints = const [],
  });
}



class TripPointStateNotifier extends StateNotifier<TripPointState> {
  final TripPointDA _tripPointDA;
  final TripPointRelevancyEvaluator _tripPointRelevancyEvaluatorService;

  TripPointStateNotifier(
    this._tripPointDA,
    this._tripPointRelevancyEvaluatorService,
  ): super(const TripPointState());


  Future<bool> addTripPoint(TripPoint tripPoint) async {
    RelevancyResult relevancyResult = _tripPointRelevancyEvaluatorService.isRelevant(tripPoint, state.mostRecentPoints);
    if (!relevancyResult.isRelevant) return false;

    // Add to database
    await _tripPointDA.insert(tripPoint.copyWith(filter: relevancyResult.filterName));

    // Append to most recent trip points 
    List<TripPoint> buffer = [...state.mostRecentPoints, tripPoint];
    if (buffer.length > stackSize) buffer.removeAt(0);
    state = TripPointState(mostRecentPoints: buffer);

    return true;
  }




  Future<void> clearTripPoints() async {
    clearMostRecentTripPoints();
    await _tripPointDA.deleteAll();
  }


  void clearMostRecentTripPoints() async {
    state = const TripPointState();
  }
}