import 'package:chords_catalog/components/painters/scale_interval_strip_painter.dart';
import 'package:chords_catalog/models/log_scale.dart';
import 'package:chords_catalog/models/note.dart';
import 'package:chords_catalog/theme/chord_log_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ScaleIntervalCreatorWidget extends StatefulWidget {
  final String rootNote;
  final BaseScale currentScale;
  final void Function(BaseScale?) submit;

  ScaleIntervalCreatorWidget(
      {required this.rootNote,
      required this.currentScale,
      required this.submit});

  @override
  State<ScaleIntervalCreatorWidget> createState() =>
      _ScaleIntervalCreatorWidgetState();
}

class _ScaleIntervalCreatorWidgetState
    extends State<ScaleIntervalCreatorWidget> {
  final _nameController = TextEditingController();
  late List<String> selectedNotes;
  late int rootIndex;
  late List<String> sortedGridLabels;

  @override
  void initState() {
    selectedNotes = [widget.rootNote];
    rootIndex = MidiNote.sharpNoteLabels.indexOf(widget.rootNote);
    sortedGridLabels = MidiNote.sharpNoteLabelsFromKey(widget.rootNote);
    super.initState();
  }

  void _addNoteToScale(String noteLabel) {
    setState(() {
      final index = selectedNotes.indexOf(noteLabel);
      if (index == -1) {
        selectedNotes.add(noteLabel);
      } else {
        selectedNotes.removeAt(index);
      }
    });
  }

  void _submit () {
    List<int> intervals = [];
    final notesList = MidiNote.sharpNoteLabelsFromKey(widget.rootNote);

    int index = 1;
    String lastNote = widget.rootNote;
    for (int i = 1 ; i<notesList.length ; i++) {
      if (selectedNotes.contains(notesList[i])) {
        intervals.add(index);
        lastNote = notesList[i];
        index = 1;
      } else {
        index ++;
      }
    }

    final lastNoteList = MidiNote.sharpNoteLabelsFromKey(lastNote);
    int lastNoteInterval = lastNoteList.indexOf(lastNote);
    if (lastNoteInterval == 0) {
      lastNoteInterval = 12;
    }
    
    intervals.add(lastNoteInterval);

    setState(() {
      final resBaseScale = BaseScale(name: _nameController.text, intervals: intervals, isCustomScale: true);
      widget.submit(resBaseScale);
      Navigator.of(context).pop();
    });

  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Set Scale Notes',
              style: TextStyle(color: ChordLogColors.primary, fontSize: 18),
            ),
            SizedBox(
              height: 16,
            ),
            TextField(decoration: const InputDecoration(labelText: 'Name', hintText: 'New Scale'), controller: _nameController,),
            SizedBox(height: 16,),
            CustomPaint(
              size: Size(MediaQuery.of(context).size.width - 50, 70),
              painter: ScaleIntervalStripPainter(
                  root: widget.rootNote, notes: selectedNotes),
            ),
            SizedBox(
              height: 8,
            ),
            SizedBox(
              child: StaggeredGrid.count(
                crossAxisCount: 4,
                crossAxisSpacing: 6,
                mainAxisSpacing: 0,
                children: [
                  for (int i = 0;
                      i < sortedGridLabels.length;
                      i++)
                    ElevatedButton(
                        onPressed: i == rootIndex
                            ? null
                            : () {
                                _addNoteToScale(sortedGridLabels[i]);
                              },
                        child: Text(sortedGridLabels[i]),
                        style: ElevatedButton.styleFrom(
                          primary: selectedNotes
                                  .contains(sortedGridLabels[i])
                              ? Colors.amber
                              : Colors.blue,
                        ))
                ],
              ),
            ),
            SizedBox(
              height: 32,
            ),
            Row(
              children: [
                ElevatedButton(
                    onPressed: _submit,
                    child: Text('Submit')),
                widget.currentScale.isCustomScale ? TextButton(onPressed: (){widget.submit(null);
                Navigator.of(context).pop();
                }, child: Text('Discard')) : TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text('Cancel'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
