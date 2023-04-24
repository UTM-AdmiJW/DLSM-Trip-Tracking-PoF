
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dlsm_pof/trip/index.dart';




class OngoingTripPointList extends StatelessWidget {

  final AsyncValue<OngoingTripPointState> state;
  
  const OngoingTripPointList({
    super.key,
    required this.state,
  });



  @override
  Widget build(BuildContext context) {

    return SliverList(
      delegate: state.when(
        loading: ()=> const SliverChildListDelegate.fixed([ Center( child: CircularProgressIndicator()) ]),
        error: (error, stack)=> const SliverChildListDelegate.fixed([ Center( child: Text("Error") ) ]),
        data: (data)=> SliverChildBuilderDelegate(
          childCount: data.rowCount,
          (context, index)=> _getListTile(data.ongoingTripPoints[index]),
        ),
      ),
    );
  }


  Widget _getListTile(OngoingTripPoint point) {
    return ListTile(
      title: Text( point.timestamp.toString().substring(0, 19) ),
      minVerticalPadding: 10,
      subtitle: Text(
        "(${point.latitude.toStringAsFixed(5)}, ${point.longitude.toStringAsFixed(5)}), "
        "Speed: ${point.speed.toStringAsFixed(2)} m/s \n"
        "Acc: ${point.acceleration?.toStringAsFixed(2)} m/s², "
        "Dec: ${point.deceleration?.toStringAsFixed(2)} m/s² \n"
        "Cornering: ${point.cornering?.toStringAsFixed(2)},"
        "Distance: ${point.totalDistance?.toStringAsFixed(2)} m, "
        "Distracted: ${point.isDistracted}"
      ),
    );
  }
}