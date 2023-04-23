
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/trip_point.dart';
import '../data_access/trip_point_da.dart';
import '../widgets/trip_points_list.dart';



class TripPointsPage extends ConsumerStatefulWidget {
  const TripPointsPage({super.key});
  @override ConsumerState<TripPointsPage> createState() => _TripPointsPageState();
}



class _TripPointsPageState extends ConsumerState<TripPointsPage> {

  int rowCount = 0;
  bool _isFetching = true;
  List<TripPoint> tripPointList = [];

  TripPointDA get _tripPointDA => ref.read(tripPointDAProvider);
  
  set isFetching(bool isFetching) => setState(() { _isFetching = isFetching; });


  Future<void> updateData() async {
    isFetching = true;

    TripPointDA tripPointDA = _tripPointDA;
    final rowCount = await tripPointDA.count();
    final tripPointList = await tripPointDA.selectAll();

    setState(() {
      this.rowCount = rowCount;
      this.tripPointList = tripPointList;
    });

    isFetching = false;
  }

  // Delete
  void deleteAllTripPoints() async {
    await _tripPointDA.deleteAll();
    updateData();
  }



  @override
  void initState() {
    super.initState();
    updateData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Points'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: updateData,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                  onPressed: deleteAllTripPoints,
                  child: const Text("Delete All Trip Points"),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text('Row Count: $rowCount'),
            const SizedBox(height: 5),
            Expanded(
              child: TripPointList(tripPointList: tripPointList, isFetching: _isFetching),
            ),
          ],
        ),
      )
    );
  }
}