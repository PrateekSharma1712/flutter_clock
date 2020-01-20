import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

class CustomHandShapeBorder extends ShapeBorder {
  final double angleRadians;

  CustomHandShapeBorder({@required this.angleRadians});

  @override
  EdgeInsetsGeometry get dimensions => null;

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    return null;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    return getClip(rect);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {}

  @override
  ShapeBorder scale(double t) {
    return null;
  }

  Path getClip(Rect rect) {
    Path clippedPath = new Path();
    Offset center = Offset(rect.size.width / 2, rect.size.height / 2);

    clippedPath.moveTo(center.dx, center.dy);
    clippedPath.lineTo(rect.width / 2, 0);
    clippedPath.arcTo(
      Rect.fromCircle(center: center, radius: rect.size.width / 2),
      -math.pi / 2,
      angleRadians,
      false,
    );

    clippedPath.close();

    return clippedPath;
  }
}
