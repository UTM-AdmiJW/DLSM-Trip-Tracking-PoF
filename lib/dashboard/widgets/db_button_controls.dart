import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dlsm_pof/trip_tracking/index.dart';



class DbButtonControls extends ConsumerWidget {
  final Function onStart;
  final Function onComplete;

  const DbButtonControls({
    Key? key,
    required this.onStart,
    required this.onComplete,
  }) : super(key: key);


  void deleteAllRows(TripPointDA trackingDataDA) async {
    onStart();
    await trackingDataDA.deleteAll();
    onComplete();
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackingDataDA = ref.watch(tripPointDAProvider);

    return Column(
      children: [
        const Text("Data", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300)),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
          onPressed: ()=> deleteAllRows(trackingDataDA),
          child: const Text("Delete All Rows"),
        ),
      ],
    );
  }
}