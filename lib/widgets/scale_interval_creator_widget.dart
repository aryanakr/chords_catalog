import 'package:chords_catalog/components/painters/scale_interval_strip_painter.dart';
import 'package:chords_catalog/models/note.dart';
import 'package:flutter/material.dart';

class ScaleIntervalCreatorWidget extends StatefulWidget {
  final String rootNote;
  final List<String> notes;
  final void Function(String) addNoteCallback;

  ScaleIntervalCreatorWidget({required this.rootNote, required this.notes, required this.addNoteCallback});

  @override
  State<ScaleIntervalCreatorWidget> createState() => _ScaleIntervalCreatorWidgetState();
}

class _ScaleIntervalCreatorWidgetState extends State<ScaleIntervalCreatorWidget> {

  @override
  Widget build(BuildContext context) {
    final selectedNotes = widget.notes;

    void _addNoteToScale (String noteLabel) {
      widget.addNoteCallback(noteLabel);
    }

    return Container(
      child: Column(
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width-50, 70),
            painter: ScaleIntervalStripPainter(root: widget.rootNote, notes: widget.notes),
          ),
          SizedBox(
            height: 130,
            width: MediaQuery.of(context).size.width,
            child: GridView.count(
              padding: EdgeInsets.all(10),
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              crossAxisCount: 6,
              children: [
                for(int i = 0; i<MidiNote.sharpNoteLabels.length ; i++)
                  ElevatedButton(onPressed: selectedNotes.contains(MidiNote.sharpNoteLabels[i]) ? null : () {_addNoteToScale(MidiNote.sharpNoteLabels[i]);},
                   child: Text(MidiNote.sharpNoteLabels[i]))
              ],
            ),
          ),
        ],
      ),
    );
  }
}