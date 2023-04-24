
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/ongoing_trip_point_appbar.dart';
import '../widgets/ongoing_trip_point_list.dart';

import 'package:dlsm_pof/trip/index.dart';





class OngoingTripPointPage extends ConsumerStatefulWidget {
  const OngoingTripPointPage({super.key});
  @override ConsumerState<OngoingTripPointPage> createState() => _OngoingTripPointsPageState();
}


class _OngoingTripPointsPageState extends ConsumerState<OngoingTripPointPage> {

  OngoingTripPointStateNotifier get _ongoingTripPointStateNotifier => ref.read(ongoingTripPointStateProvider.notifier);


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _ongoingTripPointStateNotifier.update();
    });
  }


  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ongoingTripPointStateProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _ongoingTripPointStateNotifier.update,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            const OngoingTripPointAppbar(),
            _getSliverHeaderContent(state.asData?.value.rowCount ?? 0),
            OngoingTripPointList(state: state),
          ]
        ),
      ),
    );
  }





  Widget _getSliverHeaderContent(int rowCount) {
    return SliverList(
      delegate: SliverChildListDelegate([
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
              onPressed: _ongoingTripPointStateNotifier.deleteAll,
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