import 'package:flutter/material.dart';

import '../../models/note.dart';

class ScaleIntervalStripPainter extends CustomPainter {
  final String root;
  final List<String> notes;

  ScaleIntervalStripPainter({required this.root, required this.notes});

  @override
  void paint(Canvas canvas, Size size) {
    final labels = MidiNote.sharpNoteLabelsFromKey(root);

    const int intervalPadding = 15;
    const int intervalLabelPadding = 4;

    final paintB1 = Paint()
      ..color = Colors.black
      ..strokeWidth = 3;

    final paintB2 = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;
    canvas.drawLine(Offset(0, size.height / 3 * 2),
        Offset(size.width, size.height / 3 * 2), paintB2);

    // start and end lines
    canvas.drawLine(Offset(0, size.height - intervalPadding + 2),
        Offset(0, size.height / 3 + intervalPadding - 2), paintB1);
    canvas.drawLine(Offset(size.width, size.height - intervalPadding + 2),
        Offset(size.width, size.height / 3 + intervalPadding - 2), paintB1);

    // draw root note label
    drawLabel(canvas, root, Offset(0, size.height / 3 + intervalLabelPadding));
    drawLabel(canvas, root,
        Offset(size.width, size.height / 3 + intervalLabelPadding));

    // draw other notes label
    for (int i = 1; i < 12; i++) {
      if (!notes.contains(labels[i])) {
        continue;
      }

      final intervalPaint = Paint()
        ..color = Colors.black
        ..strokeWidth = 1;

      final dx = i * (size.width / 12);
      final p1 = Offset(dx, size.height / 3 + intervalPadding);
      final p2 = Offset(dx, size.height - intervalPadding);

      final labelP = Offset(dx, size.height / 3 + intervalLabelPadding);

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

    final offset = Offset(
        centre.dx - textPainter.width / 2, centre.dy - textPainter.height / 2);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
