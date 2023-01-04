import 'package:chords_catalog/components/fretboard_fret.dart';
import 'package:chords_catalog/providers/log_provider.dart';
import 'package:chords_catalog/providers/sound_player_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';

class FretboardWidget extends StatelessWidget {

  final List<String> enabledNotes;
  final int startFret;
  final Function(MidiNote, int, int) addNote;

  FretboardWidget({required this.enabledNotes, required this.startFret, required this.addNote});

  @override
  Widget build(BuildContext context) {
    final openNotes = Provider.of<LogProvider>(context, listen: false).tuning!.openNotes;
    return Container(
      height: (openNotes.length) * 30.0 + 20,
      color: Colors.amber,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            var notes = openNotes.reversed.map((e) => MidiNote.byMidiNumber(midiNumber: e!.midiNumber + index)).toList();
            return Container(
                color: Colors.black87,
                child: FretboardFret(
                  notes: notes,
                  index: index,
                  triggerNote: (index != 0 && (index < startFret || index - startFret >= 6)) ? null : (int stringIndex, MidiNote note) {
                    addNote(note, stringIndex, index);
                  },
                  enabledNotes: enabledNotes,
                ));
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider();
          },
          itemCount: 25),
    );
  }
}
