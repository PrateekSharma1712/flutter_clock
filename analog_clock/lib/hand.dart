import 'package:flutter/material.dart';

import 'custom_hand_shape_border.dart';

class Hand extends StatelessWidget {
  final Color color;
  final int timeComponent;
  final double radius, radiansPerChange;

  const Hand({Key key, @required this.color, @required this.timeComponent, @required this.radiansPerChange, @required this.radius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: color,
        shape: CustomHandShapeBorder(
          angleRadians: timeComponent * radiansPerChange,
        ),
        elevation: 12,
        child: Container(
          width: radius,
          height: radius,
        ),
      ),
    );
  }
}
