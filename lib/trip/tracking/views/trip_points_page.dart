
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/trip_point.dart';
import '../services/trip_point_service.dart';
import '../data_access/trip_point_da.dart';
import '../widgets/sliver_trip_points_list.dart';



class TripPointsPage extends ConsumerStatefulWidget {
  const TripPointsPage({super.key});
  @override ConsumerState<TripPointsPage> createState() => _TripPointsPageState();
}



class _TripPointsPageState extends ConsumerState<TripPointsPage> {

  int rowCount = 0;
  bool _isFetching = true;
  List<TripPoint> tripPointList = [];

  TripPointService get _tripPointService => ref.read(tripPointServiceProvider);
  TripPointDA get _tripPointDA => ref.read(tripPointDAProvider);

  
  set isFetching(bool isFetching) => setState(() { _isFetching = isFetching; });


  Future<void> updateData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      isFetching = true;

      TripPointDA tripPointDA = _tripPointDA;
      final rowCount = await tripPointDA.count();
      final tripPointList = await tripPointDA.selectAll();

      setState(() {
        this.rowCount = rowCount;
        this.tripPointList = tripPointList;
      });

      isFetching = false;
    });
  }


  void deleteAllTripPoints() async {
    await _tripPointService.reset();
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
      body: RefreshIndicator(
        onRefresh: updateData,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _getSliverAppBar(),
            _getSliverHeaderContent(),
            SliverTripPointList(tripPointList: tripPointList, isFetching: _isFetching),
          ]
        ),
      ),
    );
  }



  


  Widget _getSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 200,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: Image.network(
          'https://img.freepik.com/free-photo/man-driving-car-from-rear-view_1359-494.jpg', 
          fit: BoxFit.cover,
        ),
        title: LayoutBuilder(
          builder: (context, constraints)=> Text(
            "Trip Points",
            style: TextStyle(
              color: constraints.maxHeight > 90 ? Colors.white : Colors.black,
            )
          ),
        ),
      ),
    );
  }


  Widget _getSliverHeaderContent() {
    return SliverList(
      delegate: SliverChildListDelegate([
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
        Center(child: Text('Row Count: $rowCount') ),
        const SizedBox(height: 10),
      ]),
    );
  }
}