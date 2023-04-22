import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class TripPointButtonControls extends ConsumerWidget {

  const TripPointButtonControls({
    Key? key
  }) : super(key: key);


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const Text("Trip Points", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
              onPressed: ()=> Navigator.of(context).pushNamed("/trip_points"),
              child: const Text("View Ongoing Trip Points"),
            ),
          ],
        ),
      ],
    );
  }
}