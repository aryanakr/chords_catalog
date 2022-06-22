import 'package:flutter/material.dart';

import '../../models/note.dart';

class ScaleIntervalStripPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    
    final labels = MidiNote.sharpNoteLabels;

    const int endPadding = 10;
    const int intervalPadding = 15;
    const int intervalLabelPadding = 5;

    final paint = Paint()
        ..color = Colors.black
        ..strokeWidth = 2;
    canvas.drawLine(Offset(0, size.height/3*2), Offset(size.width, size.height/3*2), paint);


    // start and end lines
    canvas.drawLine(Offset(0,size.height-endPadding), Offset(0,size.height/3+endPadding), paint);
    canvas.drawLine(Offset(size.width,size.height-endPadding), Offset(size.width,size.height/3+endPadding), paint);

    for (int i =1; i<12 ; i++) {
      final intervalPaint = Paint()
        ..color = Colors.black
        ..strokeWidth = 1;

      final dx = i*(size.width/12);
      final p1 = Offset(dx, size.height/3+intervalPadding);
      final p2 = Offset(dx, size.height-intervalPadding);

      final labelP = Offset(dx, size.height/3+intervalLabelPadding);

      canvas.drawLine(p1, p2, intervalPaint);

      drawLabel(canvas, labels[i], labelP);

    }
  }

  void drawLabel(Canvas canvas, String label, Offset centre) {
    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: 16,
    );
    final textSpan = TextSpan(
      text: label,
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
    
    final offset = Offset(centre.dx - textPainter.width / 2,
        centre.dy - textPainter.height / 2);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}