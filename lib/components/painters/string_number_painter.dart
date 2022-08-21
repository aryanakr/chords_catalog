import 'package:chords_catalog/theme/chord_log_colors.dart';
import 'package:flutter/material.dart';

class StringNumberPainter extends CustomPainter {
  final int number;

  StringNumberPainter({required this.number});


  @override
  void paint(Canvas canvas, Size size) {
    final innerPaint = Paint()
      ..color = ChordLogColors.secondary
      ..style = PaintingStyle.fill;

    final outerPaint = Paint()
    ..color = ChordLogColors.primary
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;

    // draw circles
    canvas.drawCircle(Offset(size.width/2, size.height/2), size.width/2, innerPaint);
    canvas.drawCircle(Offset(size.width/2, size.height/2), size.width/2, outerPaint);

    // draw number
    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 16,
    );
    final textSpan = TextSpan(
      text: number.toString(),
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: 100.0,
    );

    final offset = Offset(
        size.width/2 - textPainter.width / 2, size.height/2 - textPainter.height / 2);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }}