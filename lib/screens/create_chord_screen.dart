import 'package:chords_catalog/components/painters/chord_card_painter.dart';
import 'package:flutter/material.dart';

class CreateChordScreen extends StatelessWidget {
  static const routeName = '/create-chord';
  const CreateChordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Chord')),
      body: Center(
          child: CustomPaint(
        size: Size(200, 200),
        painter: ChordCardPainter(numStrings: 6, startFret: 0, notes: [0, 2 , 3, null, 1, 0]),
      )),
    );
  }
}
