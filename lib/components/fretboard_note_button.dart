import 'package:chords_catalog/models/note.dart';
import 'package:chords_catalog/theme/chord_log_colors.dart';
import 'package:flutter/material.dart';

class FretboardNoteButton extends StatefulWidget {
  final Function? triggerNote;
  final MidiNote note;
  FretboardNoteButton({required this.note, required this.triggerNote});

  @override
  _FretboardNoteButtonState createState() => _FretboardNoteButtonState();
}

class _FretboardNoteButtonState extends State<FretboardNoteButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: ChordLogColors.secondary,
            border: Border.all(color: ChordLogColors.bodyColor, width: 0.5)),
        height: 30,
        child: ElevatedButton(
            onPressed: widget.triggerNote == null ? null : () => widget.triggerNote!(), child: Text(widget.note.getNoteLabel())));
  }
}
