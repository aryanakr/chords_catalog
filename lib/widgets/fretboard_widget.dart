import 'package:chords_catalog/components/fretboard_fret.dart';
import 'package:chords_catalog/providers/log_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';

class FretboardWidget extends StatelessWidget {

  final List<String> enabledNotes;
  final Function(MidiNote, int, int) addNote;

  FretboardWidget({required this.enabledNotes, required this.addNote});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      height: 150,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            var notes = Provider.of<LogProvider>(context).tuning!.openNotes.reversed.map((e) => MidiNote.byMidiNumber(midiNumber: e.midiNumber + index)).toList();
            return Container(
                color: Colors.red,
                child: FretboardFret(
                  notes: notes,
                  triggerNote: (int stringIndex, MidiNote note) {
                    addNote(note, stringIndex, index);
                  },
                  enabledNotes: enabledNotes,
                ));
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider();
          },
          itemCount: 22),
    );
  }
}
