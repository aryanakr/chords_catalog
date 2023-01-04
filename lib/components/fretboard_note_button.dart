import 'package:chords_catalog/models/note.dart';
import 'package:chords_catalog/providers/log_provider.dart';
import 'package:chords_catalog/theme/chord_log_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final isInScale = Provider.of<LogProvider>(context, listen: false).scale!.notes.contains(widget.note.getNoteLabel());

    return Container(
        decoration: BoxDecoration(
          color: isInScale ? ChordLogColors.secondary : ChordLogColors.materialSecondary.shade800,
            border: Border.all(color: ChordLogColors.bodyColor, width: 0.5)),
        height: 30,
        width: 70,
        child: ElevatedButton(
            onPressed: widget.triggerNote == null ? null : () => widget.triggerNote!(), child: Text(isInScale ? widget.note.getNoteLabel() : '(${widget.note.getNoteLabel()})')));
  }
}
