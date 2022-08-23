import 'dart:convert';

import 'package:chords_catalog/models/instrument.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../components/painters/string_number_painter.dart';
import '../theme/chord_log_colors.dart';

class TuningCreatorWidget extends StatefulWidget {
  final Tuning initialTuning;
  final BuildContext parentContext;
  final void Function(Tuning) submit;
  const TuningCreatorWidget(
      {Key? key, required this.initialTuning, required this.submit, required this.parentContext})
      : super(key: key);

  @override
  State<TuningCreatorWidget> createState() => _TuningCreatorWidgetState();
}

class _TuningCreatorWidgetState extends State<TuningCreatorWidget> {

  void _showPitchPicker(BuildContext context) {
    Picker picker = Picker(
      adapter: PickerDataAdapter<String>(pickerdata: ['1','2']),
      changeToFirst: true,
      textAlign: TextAlign.left,
      columnPadding: const EdgeInsets.all(8.0),
      onConfirm: (Picker picker, List value) {
        print(value.toString());
        print(picker.getSelectedValues());
      }
    );
    picker.show(Scaffold.of(widget.parentContext));
  }

  @override
  Widget build(BuildContext context) {
    final _nameController = TextEditingController(
        text: widget.initialTuning.isCustomTuning
            ? widget.initialTuning.name
            : '');

    final pitches =
        widget.initialTuning.openNotes.map((e) => e?.label ?? '').toList();

    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'New Tuning',
            style: TextStyle(color: ChordLogColors.primary, fontSize: 18),
          ),
          const SizedBox(
            height: 16,
          ),
          TextField(
            decoration: const InputDecoration(
                labelText: 'Tuning Name', hintText: 'Tuning Name'),
            controller: _nameController,
          ),
          const SizedBox(
            height: 32,
          ),
          StaggeredGrid.count(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 12,
            children: [
              for (int i = 0; i < widget.initialTuning.numStrings; i++)
                Container(
                  color: ChordLogColors.secondary,
                  padding: EdgeInsets.only(top: 8),
                  child: Column(
                    children: [
                      CustomPaint(
                        size: Size(30, 30),
                        painter: StringNumberPainter(
                            number: widget.initialTuning.numStrings - i),
                      ),
                      const SizedBox(height: 2),
                      TextButton(
                          onPressed: () {_showPitchPicker(context);},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                pitches[i],
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(
                                width: 0,
                              ),
                              Icon(Icons.arrow_drop_down_circle_outlined)
                            ],
                          ))
                    ],
                  ),
                )
            ],
          ),
          SizedBox(
            height: 16,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Create',
                style: TextStyle(fontSize: 18),
              )),
        ],
      ),
    );
  }
}
