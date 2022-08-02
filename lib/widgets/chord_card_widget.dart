import 'package:chords_catalog/components/painters/chord_card_painter.dart';
import 'package:flutter/material.dart';

class ChordCardWidget extends StatelessWidget {
  final String name;
  final int numStrings;
  final int startFret;
  final List<int?> notes;

  const ChordCardWidget(
      {Key? key, required this.name, required this.numStrings, required this.startFret, required this.notes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
            child: Text(
          name,
          style: TextStyle(fontSize: 24),
        )),
        const SizedBox(
          height: 12,
        ),
        Center(
            child: CustomPaint(
          size: const Size(200, 200),
          painter: ChordCardPainter(
              numStrings: numStrings, startFret: startFret, notes: notes),
        ))
      ],
    );
  }
}
