import 'package:chords_catalog/components/painters/scale_interval_strip_painter.dart';
import 'package:chords_catalog/models/log_scale.dart';
import 'package:chords_catalog/models/note.dart';
import 'package:flutter/material.dart';

class ScaleIntervalCreatorWidget extends StatefulWidget {
  final String rootNote;
  final BaseScale currentScale;
  final void Function(BaseScale) submit;

  ScaleIntervalCreatorWidget({required this.rootNote, required this.currentScale, required this.submit});

  @override
  State<ScaleIntervalCreatorWidget> createState() => _ScaleIntervalCreatorWidgetState();
}

class _ScaleIntervalCreatorWidgetState extends State<ScaleIntervalCreatorWidget> {
  final _nameController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {

    final selectedNotes = [widget.rootNote];
    final rootIndex = MidiNote.sharpNoteLabels.indexOf(widget.rootNote);

    void _addNoteToScale (String noteLabel) {
      setState(() {
        
      });
    }


    return Container(
      child: Column(
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width-50, 70),
            painter: ScaleIntervalStripPainter(root: widget.rootNote, notes: [widget.rootNote]),
          ),
          SizedBox(height: 8,)
          ,
          SizedBox(
            height: MediaQuery.of(context).size.width * 3 / 10,
            width: MediaQuery.of(context).size.width,
            child: GridView.count(
              padding: EdgeInsets.all(10),
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              crossAxisCount: 6,
              children: [
                for(int i = rootIndex; i<MidiNote.sharpNoteLabels.length ; i++)
                  ElevatedButton(onPressed: i == rootIndex ? null: () {_addNoteToScale(MidiNote.sharpNoteLabels[i]);},
                   child: Text(MidiNote.sharpNoteLabels[i]), style: ElevatedButton.styleFrom(primary: selectedNotes.contains(MidiNote.sharpNoteLabels[i]) ? Colors.amber : Colors.blue,)),
                   for(int i = rootIndex-1; i>=0 ; i--)
                  ElevatedButton(onPressed: () {_addNoteToScale(MidiNote.sharpNoteLabels[i]);},
                   child: Text(MidiNote.sharpNoteLabels[i]), style: ElevatedButton.styleFrom(primary: selectedNotes.contains(MidiNote.sharpNoteLabels[i]) ? Colors.amber : Colors.blue,))
              ],
            ),
          ),
          ElevatedButton(onPressed: (){Navigator.of(context).pop();}, child: Text('Submit'))
        ],
      ),
    );
  }
}