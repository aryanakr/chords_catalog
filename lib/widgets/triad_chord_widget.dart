import 'package:chords_catalog/models/chord.dart';
import 'package:chords_catalog/models/log_scale.dart';
import 'package:chords_catalog/providers/log_provider.dart';
import 'package:chords_catalog/screens/create_chord_screen.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class TriadChordWidget extends StatelessWidget {
  final Triad triad;

  const TriadChordWidget({Key? key, required this.triad}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {

    void _createNewChord() {
      // get log provider
      final log = Provider.of<LogProvider>(context, listen: false);


      GuitarChord chord = GuitarChord(
          name: triad.root+triad.type,
          cardDotsPos: [for(int i =0 ; i<log.tuning!.numStrings; i++) null],
          chord: Chord(noteLabels: triad.noteLabels, type: triad.type, root: triad.root, structure: triad.structure),
          midiNotes: [],
          startFret: 0
          );

      Navigator.of(context).pushNamed(CreateChordScreen.routeName, arguments: CreateChordArgs(chord: chord));
    }

    return Container(child: TextButton(
      onPressed: _createNewChord,
      child: Column(children: [
        Text(triad.romanNumber),
        Text(triad.root+triad.type),
        Text(triad.noteLabels.map((e) => e).join(' '))
      ],),
    ),);
  }
}