import 'package:chords_catalog/components/fretboard_note_button.dart';
import 'package:chords_catalog/models/note.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class FretboardFret extends StatelessWidget {
  
  final List<MidiNote> notes;
  final Function(int, MidiNote) triggerNote;
  final List<String> enabledNotes;

  FretboardFret({required this.notes, required this.triggerNote, required this.enabledNotes});


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          for ( var i = 0; i<notes.length ;i++) 
            FretboardNoteButton(note: notes[i],triggerNote: enabledNotes.contains(notes[i].getNoteLabel()) ? () {
              triggerNote(notes.length - i-1, notes[i]);
            } : null),
        ],
      ),
    );
  }
}