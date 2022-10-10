import 'package:flutter/material.dart';

class ChordCardPainter extends CustomPainter {
  final int numStrings;
  final int startFret;
  final List<int?> notes;

  ChordCardPainter({required this.numStrings, required this.notes, required this.startFret});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
        ..color = Colors.black
        ..strokeWidth = 1;

    final thickPaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6;

    final strockPaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

    // Frame
    final framePaddingVertical = 16.0;
    final framePaddingHorizental = 22.0;


    final frameTopLeftOffset = Offset(framePaddingHorizental, framePaddingVertical);
    final frameTopRightOffset = Offset(size.width - framePaddingHorizental, framePaddingVertical);
    final frameBottomLeftOffset = Offset(framePaddingHorizental, size.height - framePaddingVertical);
    final frameBottomRightOffset = Offset(size.width - framePaddingHorizental, size.height - framePaddingVertical);

    // draw border
    canvas.drawLine(frameTopLeftOffset, frameTopRightOffset, startFret <= 1 ? thickPaint : paint); // top
    canvas.drawLine(frameTopRightOffset, frameBottomRightOffset, paint); // left
    canvas.drawLine(frameBottomLeftOffset, frameBottomRightOffset, paint); // bottom
    canvas.drawLine(frameBottomLeftOffset,frameTopLeftOffset, paint); // right

    // draw fret text
    if (startFret > 1) {
      final fretTextStyle = TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: size.width/12);
      final textSpan = TextSpan(text: '$startFret', style: fretTextStyle);
      final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr, );
      textPainter.layout(minWidth: 0, maxWidth: size.width);
      final fretTextOffset = Offset(frameTopRightOffset.dx + 8, frameTopRightOffset.dy +2);
      textPainter.paint(canvas, fretTextOffset);
    }

    // draw strings
    double stringsPadding = (size.width - 2 * framePaddingHorizental) / (numStrings - 1);

    for (int i = 1 ; i<numStrings-1; i++) {
      double dx = framePaddingHorizental + i * stringsPadding;
      canvas.drawLine(Offset(dx, framePaddingVertical), Offset(dx, size.height - framePaddingVertical), paint);
    }

    // draw fret lines
    int numFrets = 7;
    double fretsPadding = (size.width - 2 * framePaddingVertical) / (numFrets - 1);

    for (int i = 1 ; i < numFrets - 1; i++) {
      double dy = framePaddingVertical + fretsPadding * i;
      canvas.drawLine(Offset(framePaddingHorizental, dy), Offset(size.width - framePaddingHorizental , dy), paint);
    }

    // draw notes
    double noteCirclesRadius = size.width/25;

    

    for (int i = 0; i<notes.length; i++) {
      double dx = framePaddingHorizental + stringsPadding * i;
      final note = notes [i];
      if (note == null){
        drawCross(canvas, Offset(dx, noteCirclesRadius - size.height / 30), noteCirclesRadius, strockPaint);
      }
      else if (note == 0) {
        canvas.drawCircle(Offset(dx, noteCirclesRadius - size.height / 30), noteCirclesRadius, strockPaint);
      } else {
        double dy = framePaddingVertical + (note * fretsPadding) - fretsPadding/2;
        canvas.drawCircle(Offset(dx, dy), noteCirclesRadius, paint);
      }
    }
  }

  void drawCross(Canvas canvas, Offset centre, double size, Paint paint) {
    canvas.drawLine(Offset(centre.dx - size, centre.dy - size), Offset(centre.dx + size, centre.dy + size), paint);
    canvas.drawLine(Offset(centre.dx + size, centre.dy - size), Offset(centre.dx - size, centre.dy + size), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
