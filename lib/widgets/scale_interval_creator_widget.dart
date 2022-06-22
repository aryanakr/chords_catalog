import 'package:chords_catalog/components/painters/scale_interval_strip_painter.dart';
import 'package:chords_catalog/models/note.dart';
import 'package:flutter/material.dart';

class ScaleIntervalCreatorWidget extends StatefulWidget {
  const ScaleIntervalCreatorWidget({Key? key}) : super(key: key);

  @override
  State<ScaleIntervalCreatorWidget> createState() => _ScaleIntervalCreatorWidgetState();
}

class _ScaleIntervalCreatorWidgetState extends State<ScaleIntervalCreatorWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width-50, 70),
            painter: ScaleIntervalStripPainter(),
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
                  ElevatedButton(onPressed: () {}, child: Text(MidiNote.sharpNoteLabels[i]))
              ],
            ),
          ),
          ElevatedButton(onPressed: () {}, child: Text("Finish"))
        ],
      ),
    );
  }
}