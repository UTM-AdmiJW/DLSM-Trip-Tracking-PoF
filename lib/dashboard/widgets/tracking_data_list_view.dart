
import 'package:flutter/material.dart';

import 'package:dlsm_pof/trip_tracking/index.dart';




class TrackingDataListView extends StatelessWidget {
  final List<TrackingData> trackingDataList;
  final bool isFetching;
  
  const TrackingDataListView({
    super.key,
    required this.trackingDataList,
    required this.isFetching,
  });

  @override
  Widget build(BuildContext context) {
    if (isFetching) return const Center( child: CircularProgressIndicator(), );

    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: trackingDataList.length,
      itemBuilder: (context, index) {
        final trackingData = trackingDataList[index];

        return ListTile(
          title: Text( trackingData.timestamp.toString().substring(0, 19) ),
          subtitle: Text(
            "(${trackingData.latitude.toStringAsFixed(5)}, ${trackingData.longitude.toStringAsFixed(5)}) | "
            "Speed: ${trackingData.speed.toStringAsFixed(2)} m/s | "
            "Activity: ${trackingData.activity}"
          ),
        );
      },
    );
  }
}