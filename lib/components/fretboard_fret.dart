import 'package:chords_catalog/components/fretboard_note_button.dart';
import 'package:chords_catalog/models/note.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FretboardFret extends StatelessWidget {
  final List<MidiNote> notes;
  final Function(int, MidiNote)? triggerNote;
  final List<String> enabledNotes;
  final int index;

  FretboardFret(
      {required this.notes,
      required this.triggerNote,
      required this.enabledNotes,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 20,
            width: 30,
            child: index == 0 ||
                    index == 3 ||
                    index == 5 ||
                    index == 7 ||
                    index == 9 ||
                    index == 12 ||
                    index == 15 ||
                    index == 17 ||
                    index == 19 ||
                    index == 21 ||
                    index == 24
                ? Center(
                    child: Text(
                    index.toString(),
                    style: TextStyle(color: Colors.white),
                  ))
                : Container(),
          ),
          for (var i = 0; i < notes.length; i++)
            Row(
              children: [
                FretboardNoteButton(
                    note: notes[i],
                    triggerNote: (enabledNotes.contains(notes[i].getNoteLabel()) &&
                            triggerNote != null)
                        ? () {
                            triggerNote!(notes.length - i - 1, notes[i]);
                          }
                        : null),
                if (index == 0)
                  Container(
                    width: 5,
                  )
              ],
            ),
        ],
      ),
    );
  }
}
