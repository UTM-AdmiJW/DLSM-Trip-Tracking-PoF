
import 'package:flutter/material.dart';



class OngoingTripPointAppbar extends StatelessWidget {
  const OngoingTripPointAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 200,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: Image.network(
          'https://img.freepik.com/free-photo/man-driving-car-from-rear-view_1359-494.jpg', 
          fit: BoxFit.cover,
        ),
        title: LayoutBuilder(
          builder: (context, constraints)=> Text(
            "Ongoing Trip Points",
            style: TextStyle(
              color: constraints.maxHeight > 90 ? Colors.white : Colors.black,
            )
          ),
        ),
      ),
    );
  }
}