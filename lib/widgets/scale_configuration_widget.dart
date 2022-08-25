import 'package:chords_catalog/components/painters/scale_interval_strip_painter.dart';
import 'package:chords_catalog/models/log_scale.dart';
import 'package:chords_catalog/models/note.dart';
import 'package:chords_catalog/widgets/scale_interval_creator_widget.dart';
import 'package:flutter/material.dart';

import '../theme/chord_log_colors.dart';

class ScaleConfigurationWidget extends StatefulWidget {

  final String root;
  final BaseScale baseScale;
  final List<BaseScale> defaultScales;
  final void Function(String, BaseScale) submit;

  const ScaleConfigurationWidget({Key? key, required this.root, required this.baseScale, required this.defaultScales, required this.submit}) : super(key: key);

  @override
  State<ScaleConfigurationWidget> createState() => _ScaleConfigurationWidgetState();
}

class _ScaleConfigurationWidgetState extends State<ScaleConfigurationWidget> {

  void _submitNewScale(BaseScale base) {
    widget.submit(widget.root, base);
  }

  Dialog createIntervalConfigDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 6,
      child: ScaleIntervalCreatorWidget(
        rootNote: widget.root,
        submit: _submitNewScale,
        currentScale: widget.baseScale.isCustomScale ? widget.baseScale : BaseScale(name: '', intervals: [],
        isCustomScale: true)),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 1.5, color: ChordLogColors.primary)),
      child: Column(
        children: [
          const SizedBox(height: 16,),
          const Text('Scale', style: TextStyle(fontSize: 22)),
          Row(
            children: [
              const SizedBox(width: 24,),
              const Text("Root", style: TextStyle(fontSize: 16),),
              const SizedBox(width: 32,),
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
                      onChanged: (String? newRoot) {
                        if (newRoot != null) {
                          widget.submit(newRoot, widget.baseScale);
                        }
                      },
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
                child: widget.baseScale.isCustomScale? Text(widget.baseScale.name, style: TextStyle(fontSize: 18),textAlign: TextAlign.center,) : DropdownButton(
                  items: [
                    for (BaseScale baseScale in widget.defaultScales)
                      DropdownMenuItem(
                        child: Text(baseScale.name),
                        value: baseScale.name,
                      ),
                  ],
                  value: widget.baseScale.name,
                  onChanged: (String? baseName) {
                    if (baseName != null) {
                      final base = widget.defaultScales.firstWhere((element) => element.name == baseName);
                      widget.submit(widget.root, base);
                    }
                  },
                  isExpanded: true,
                ),
              ),
              TextButton(
                  onPressed: () {showDialog(context: context,
                  builder: (BuildContext context){
                    return createIntervalConfigDialog();
                  });},
                  child: Row(
                    children: [Text("New"), Icon(Icons.add)],
                  ))
            ],
          ),
          SizedBox(height: 8,),
          CustomPaint(size: Size(250, 60), painter: ScaleIntervalStripPainter(root: widget.root, notes: widget.baseScale.getNotes(widget.root))),
          

        ],
      ),

    );
  }
}