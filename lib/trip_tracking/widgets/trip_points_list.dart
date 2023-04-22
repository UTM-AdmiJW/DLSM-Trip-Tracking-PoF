
import 'package:flutter/material.dart';

import '../model/trip_point.dart';




class TripPointList extends StatelessWidget {
  final List<TripPoint> tripPointList;
  final bool isFetching;
  
  const TripPointList({
    super.key,
    required this.tripPointList,
    required this.isFetching,
  });



  @override
  Widget build(BuildContext context) {
    if (isFetching) return const Center( child: CircularProgressIndicator(), );

    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: tripPointList.length,
      itemBuilder: (context, index) {
        final trackingData = tripPointList[index];

        return ListTile(
          title: Text( trackingData.timestamp.toString().substring(0, 19) ),
          subtitle: Text(
            "(${trackingData.latitude.toStringAsFixed(5)}, ${trackingData.longitude.toStringAsFixed(5)}) | "
            "Speed: ${trackingData.speed.toStringAsFixed(2)} m/s | "
            "Filter: ${trackingData.filter}",
          ),
        );
      },
    );
  }
}