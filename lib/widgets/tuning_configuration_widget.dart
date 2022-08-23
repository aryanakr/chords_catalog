import 'package:chords_catalog/models/note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../components/painters/string_number_painter.dart';
import '../models/instrument.dart';
import '../theme/chord_log_colors.dart';

class TuningConfigurationWidget extends StatefulWidget {
  final Tuning currentTuning;
  final List<Tuning> defaultTunings;
  final void Function(Tuning) update;

  TuningConfigurationWidget(
      {Key? key,
      required this.currentTuning,
      required this.defaultTunings,
      required this.update})
      : super(key: key);

  @override
  State<TuningConfigurationWidget> createState() =>
      _TuningConfigurationWidgetState();
}

class _TuningConfigurationWidgetState extends State<TuningConfigurationWidget> {
  bool isCreatingTuning = false;

  final _tuningNameController = TextEditingController();
  
  void _setTuning(Tuning newTuning) {
    setState(() {
      widget.update(newTuning);
    });
  }

  void _updatePitch(int index, String label) {
    final List<MidiNote?> pitches = [];
    pitches.addAll(widget.currentTuning.openNotes);
    pitches[index] = MidiNote.byLabel(label: label);

    Tuning newTuning = Tuning(name: _tuningNameController.text, openNotes: pitches, numStrings: widget.currentTuning.numStrings, isCustomTuning: true);
    _setTuning(newTuning);
  }

  void _switchEditing() {
    setState(() {
      isCreatingTuning = !isCreatingTuning;

      if (!isCreatingTuning) {
        widget.update(widget.defaultTunings[0]);
      }
    });
  }

  void _showPitchPicker(BuildContext context, int index) {
    final String currentNoteLabel = widget.currentTuning.openNotes[index]?.getNoteLabel() ?? '';
    final int currentNoteOctave = widget.currentTuning.openNotes[index]?.getNoteOctave() ?? 0;

    final int _labelIndex = MidiNote.sharpNoteLabels.indexOf(currentNoteLabel);
    final int labelInex = _labelIndex == -1 ? 0 : _labelIndex;

    Picker picker = Picker(
      adapter: PickerDataAdapter(data: [
        for (String p in MidiNote.sharpNoteLabels)
          PickerItem(text: Text(p), children: [
            for (int o = -2; o<=8 ; o++)
              PickerItem(text: Text(o.toString()), value: o)
          ]),
      ]),
      textAlign: TextAlign.left,
      selecteds: [labelInex,currentNoteOctave+2],
      title: Text('${6-index}th String Tuning'),
      onConfirm: (Picker picker, List value) {
        final int octave = value[1] - 2;
        final String note = MidiNote.sharpNoteLabels[value[0]];
        final label = note + octave.toString();
        _updatePitch(index, label);
      }
    );
    picker.show(Scaffold.of(context));
  }

  @override
  Widget build(BuildContext context) {
    List<Tuning> tuningsList = widget.defaultTunings;

    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 1.5, color: ChordLogColors.primary)),
      child: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          const Text('Tuning', style: TextStyle(fontSize: 22)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 150,
                child: isCreatingTuning ? TextField(decoration: const InputDecoration(
                labelText: 'Name', hintText: 'Custom Tuning',contentPadding: EdgeInsets.all(4)),
            controller: _tuningNameController,): DropdownButton(
                  alignment: Alignment.centerRight,
                  items: [
                    for (Tuning t in tuningsList)
                      DropdownMenuItem(
                        child: Text(t.name),
                        value: t.name,
                      ),
                  ],
                  value: widget.currentTuning.name,
                  onChanged: (String? selTuning) {
                    if (selTuning != null) {
                      final tuning = tuningsList
                          .firstWhere((element) => element.name == selTuning);
                      
                      _setTuning(tuning);
                    }
                  },
                  isExpanded: true,
                ),
              ),
              TextButton(
                  onPressed:
                    _switchEditing,
                  child: Row(
                    children: isCreatingTuning ? [const Text("Discard"), const Icon(Icons.remove)] :[const Text("New"), const Icon(Icons.add)],
                  ))
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            margin: EdgeInsets.all(12),
            child: StaggeredGrid.count(
              crossAxisCount: 3,
              crossAxisSpacing: 0,
              mainAxisSpacing: 12,
              children: [
                for (int i = 0; i < widget.currentTuning.numStrings; i++)
                  isCreatingTuning ?
                  Row(
                    children: [
                      CustomPaint(
                        size: Size(30, 30),
                        painter:
                            StringNumberPainter(number: widget.currentTuning.numStrings - i),
                      ),
                      TextButton(onPressed: (){_showPitchPicker(context, i);}, child: Row(children: [Text(widget.currentTuning.openNotes[i]?.label ?? '' , style: TextStyle(fontSize: 16),),
                      Icon(Icons.arrow_drop_down)],),)
                    ],
                  )
                  :
                  Row(
                    children: [
                      CustomPaint(
                        size: Size(30, 30),
                        painter:
                            StringNumberPainter(number: widget.currentTuning.numStrings - i),
                      ),
                      const SizedBox(width: 8),
                      Text(widget.currentTuning.openNotes[i]?.label ?? '')
                    ],
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}
