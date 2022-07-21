import 'package:chords_catalog/models/note.dart';
import 'package:flutter/material.dart';

class FretboardNoteButton extends StatefulWidget {
  final Function triggerNote;
  final MidiNote note;
  FretboardNoteButton({required this.note, required this.triggerNote});

  @override
  _FretboardNoteButtonState createState() => _FretboardNoteButtonState();
}

class _FretboardNoteButtonState extends State<FretboardNoteButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 25,
        color: Colors.pink,
        child: ElevatedButton(
            onPressed: () => widget.triggerNote(), child: Text(widget.note.label)));
  }
}
