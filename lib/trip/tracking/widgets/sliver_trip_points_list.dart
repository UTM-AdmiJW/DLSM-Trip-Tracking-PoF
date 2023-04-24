
import 'package:flutter/material.dart';

import '../model/trip_point.dart';




class SliverTripPointList extends StatelessWidget {
  final List<TripPoint> tripPointList;
  final bool isFetching;
  
  const SliverTripPointList({
    super.key,
    required this.tripPointList,
    required this.isFetching,
  });



  @override
  Widget build(BuildContext context) {

    return SliverList(
      delegate: isFetching ?
        const SliverChildListDelegate.fixed([ Center( child: CircularProgressIndicator()) ]) :
        SliverChildBuilderDelegate(
          childCount: tripPointList.length,
          (context, index)=> _getListTile(tripPointList[index]),
        ),
    );
  }


  Widget _getListTile(TripPoint point) {
    return ListTile(
      title: Text( point.timestamp.toString().substring(0, 19) ),
      minVerticalPadding: 10,
      subtitle: Text(
        "(${point.latitude.toStringAsFixed(5)}, ${point.longitude.toStringAsFixed(5)}), "
        "Speed: ${point.speed.toStringAsFixed(2)} m/s \n"
        "Acc: ${point.acceleration?.toStringAsFixed(2)} m/s², "
        "Dec: ${point.deceleration?.toStringAsFixed(2)} m/s² \n"
        "Cornering: ${point.cornering?.toStringAsFixed(2)} ,"
        "Total Distance: ${point.totalDistance?.toStringAsFixed(2)} m"
      ),
    );
  }
}