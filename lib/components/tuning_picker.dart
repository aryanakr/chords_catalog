import 'package:chords_catalog/models/instrument.dart';
import 'package:chords_catalog/models/note.dart';
import 'package:flutter/material.dart';

class TuningPicker extends StatefulWidget {
  final int numStrings;
  final String tuningName;
  List<String> currentTuningPitches;
  final void Function(String, List<String>) update;
  

  TuningPicker({
    required this.numStrings,
    required this.tuningName,
    required this.currentTuningPitches,
    required this.update
      });

  @override
  State<TuningPicker> createState() => _TuningPickerState();
}

class _TuningPickerState extends State<TuningPicker> {
  void _setTuning(List<String> tune) {
    setState(() {
      widget.currentTuningPitches = tune;
      widget.update(widget.tuningName, tune);
    });
  }

  void _setTuningPitch(int index, String? pitchLabel) {
    setState(() {
      widget.currentTuningPitches[index] = pitchLabel ?? '';
      widget.update(widget.tuningName, widget.currentTuningPitches);
    });
  }

  void _setTuningFromDefaults() {
    
  }

  @override
  Widget build(BuildContext context) {
    List<Tuning> tuningsList =
        Tuning.retrieveKnownTuningForStrings(widget.numStrings);

    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Text('Tuning'),
              DropdownButton(
                  items: [
                    for (Tuning t in tuningsList)
                      DropdownMenuItem(
                        child: Text(t.name),
                        value: t,
                      ),
                  ],
                  value: tuningsList[0],
                  onChanged: (Tuning? selTuning) {
                    if (selTuning != null && !selTuning.isCustomTuning) {
                      final labels =
                          selTuning.openNotes.map((e) => e.label).toList();
                      _setTuning(labels);
                    }
                  })
            ],
          ),
          Text('Pitches'),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                for (int pitchIndex = 0;
                    pitchIndex < widget.numStrings;
                    pitchIndex++)
                  Row(
                    children: [
                      DropdownButton(
                          items: [
                            const DropdownMenuItem(
                              child: Text(''),
                              value: '',
                            ),
                            for (String label in MidiNote.allNoteLabels())
                              DropdownMenuItem(
                                child: Text(label),
                                value: label,
                              ),
                          ],
                          value: widget.currentTuningPitches[pitchIndex],
                          onChanged: (String? selPitchLabel) {
                            _setTuningPitch(pitchIndex, selPitchLabel);
                          }),
                      SizedBox(
                        width: 12,
                      )
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
