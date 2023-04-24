
import 'package:flutter/material.dart';

import 'package:dlsm_pof/common/index.dart';
import 'package:dlsm_pof/trip/index.dart';




class HistoryTripList extends ConsumerWidget {
  const HistoryTripList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(historyTripStateProvider);

    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => const Center(child: Text("Error")),
      data: (data) => ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: data.historyTrips.map(_buildHistoryTripCard).toList(),
      ),
    );
  }


  Widget _buildHistoryTripCard(HistoryTrip trip) {
    return ListTile(
      minVerticalPadding: 10,
      title: Text(trip.startTime.toString().substring(0, 19)),
      subtitle: Text(
        "Start: (${trip.startLat.toStringAsFixed(5)}, ${trip.startLong.toStringAsFixed(5)}), "
        "End: (${trip.endLat.toStringAsFixed(5)}, ${trip.endLong.toStringAsFixed(5)}), "
        "Start time: ${trip.startTime.toString().substring(0, 19)}, "
        "End time: ${trip.endTime.toString().substring(0, 19)}, "
        "Duration: ${Duration(seconds: trip.durationSeconds).toString()}, "
        "Distance: ${trip.totalDistance.toStringAsFixed(2)} m, "
        "Max speed: ${trip.maxSpeed.toStringAsFixed(2)} m/s, "
        "Avg speed: ${trip.averageSpeed.toStringAsFixed(2)} m/s, "
        "Max acceleration: ${trip.maxAcceleration.toStringAsFixed(2)} m/s², "
        "Avg acceleration: ${trip.averageAcceleration.toStringAsFixed(2)} m/s², "
        "Max deceleration: ${trip.maxDeceleration.toStringAsFixed(2)} m/s², "
        "Avg deceleration: ${trip.averageDeceleration.toStringAsFixed(2)} m/s², "
      ),
    );
  }
}