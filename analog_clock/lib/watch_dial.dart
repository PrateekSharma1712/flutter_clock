import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class WatchDial extends StatelessWidget {
  final double radius;
  final Color color, textColor;

  const WatchDial({Key key, @required this.radius, @required this.color, @required this.textColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(color: textColor),
      child: Center(
        child: CustomPaint(
          foregroundPainter: DialPainter(textColor: textColor),
          child: Container(
            width: radius,
            height: radius,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

class DialPainter extends CustomPainter {
  final Color textColor;

  DialPainter({this.textColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paragraphStyle = ui.ParagraphStyle(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      fontSize: 16.0,
      fontWeight: FontWeight.w800,
    );
    final constraints = ui.ParagraphConstraints(width: 40);
    final ui.TextStyle textStyle = ui.TextStyle(color: textColor);

    var paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText("12");

    var paragraph = paragraphBuilder.build();
    paragraph.layout(constraints);
    canvas.drawParagraph(paragraph, Offset(size.width / 2 - constraints.width / 2, 2));

    paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText("03");
    paragraph = paragraphBuilder.build();
    paragraph.layout(constraints);
    canvas.drawParagraph(paragraph, Offset(size.width - paragraph.width + 5, size.height / 2 - paragraph.height / 2));

    paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText("06");
    paragraph = paragraphBuilder.build();
    paragraph.layout(constraints);
    canvas.drawParagraph(paragraph, Offset(size.width / 2 - constraints.width / 2, size.height - paragraph.height - 2));

    paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText("09");
    paragraph = paragraphBuilder.build();
    paragraph.layout(constraints);
    canvas.drawParagraph(paragraph, Offset(-4, size.height / 2 - paragraph.height / 2));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
