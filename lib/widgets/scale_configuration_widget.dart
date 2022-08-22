import 'package:chords_catalog/components/painters/scale_interval_strip_painter.dart';
import 'package:chords_catalog/models/log_scale.dart';
import 'package:chords_catalog/models/note.dart';
import 'package:flutter/material.dart';

import '../theme/chord_log_colors.dart';

class ScaleConfigurationWidget extends StatefulWidget {

  final String root;
  final List<String> notes;
  final List<BaseScale> defaultScales;

  const ScaleConfigurationWidget({Key? key, required this.root, required this.notes, required this.defaultScales}) : super(key: key);

  @override
  State<ScaleConfigurationWidget> createState() => _ScaleConfigurationWidgetState();
}

class _ScaleConfigurationWidgetState extends State<ScaleConfigurationWidget> {
  
  @override
  Widget build(BuildContext context) {
    List<int> scaleIntervals = widget.defaultScales[0].intervals;

    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 1.5, color: ChordLogColors.primary)),
      child: Column(
        children: [
          const SizedBox(height: 16,),
          const Text('Scale', style: TextStyle(fontSize: 22)),
          Row(
            children: [
              SizedBox(width: 24,),
              Text("Root", style: TextStyle(fontSize: 16),),
              SizedBox(width: 32,),
              SizedBox(
                    width: 75,
                    child: DropdownButton(
                      alignment: Alignment.centerRight,
                      items: [
                        for (final note in MidiNote.sharpNoteLabels)
                          DropdownMenuItem(
                            child: Text(note),
                            value: note,
                          ),
                      ],
                      value: widget.root,
                      onChanged: (String? t) {},
                      isExpanded: true,
                    ),
                  ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 150,
                child: DropdownButton(
                  items: [
                    for (BaseScale baseScale in widget.defaultScales)
                      DropdownMenuItem(
                        child: Text(baseScale.name),
                        value: baseScale.intervals,
                      ),
                  ],
                  value: scaleIntervals,
                  onChanged: (List<int>? base) {},
                  isExpanded: true,
                ),
              ),
              TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [Text("New"), Icon(Icons.add)],
                  ))
            ],
          ),
          SizedBox(height: 8,),
          CustomPaint(size: Size(250, 60), painter: ScaleIntervalStripPainter(root: widget.root, notes: widget.notes)),
          

        ],
      ),

    );
  }
}