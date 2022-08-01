import 'package:chords_catalog/models/instrument.dart';
import 'package:chords_catalog/models/note.dart';
import 'package:flutter/material.dart';

class TuningPicker extends StatefulWidget {
  final int numStrings;
  final String tuningName;
  List<String> currentTuningPitches;
  final void Function(String, List<String>) update;

  TuningPicker(
      {Key? key,
      required this.numStrings,
      required this.tuningName,
      required this.currentTuningPitches,
      required this.update})
      : super(key: key);

  @override
  State<TuningPicker> createState() => _TuningPickerState();
}

class _TuningPickerState extends State<TuningPicker> {
  void _setTuning(String name, List<String> tune) {
    setState(() {
      widget.currentTuningPitches = tune;
      widget.update(name, tune);
    });
  }

  void _setTuningPitch(int index, String? pitchLabel) {
    setState(() {
      widget.currentTuningPitches[index] = pitchLabel ?? '';
      widget.update(Tuning.customTuningName, widget.currentTuningPitches);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Tuning> tuningsList =
        Tuning.retrieveKnownTuningForStrings(widget.numStrings);

    return Column(
      children: [
        Row(
          children: [
            const Text('Tuning'),
            const SizedBox(
              width: 24,
            ),
            DropdownButton(
                items: [
                  for (Tuning t in tuningsList)
                    DropdownMenuItem(
                      child: Text(t.name),
                      value: t.name,
                    ),
                ],
                value: widget.tuningName,
                onChanged: (String? selTuning) {
                  if (selTuning != null) {
                    final tuning = tuningsList
                        .firstWhere((element) => element.name == selTuning);
                    if (!tuning.isCustomTuning) {
                      final labels =
                          tuning.openNotes.map((e) => e.label).toList();
                      _setTuning(tuning.name, labels);
                    }
                  }
                })
          ],
        ),
        const SizedBox(
          height: 18,
        ),
        const Text('Pitches'),
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
                          for (String label
                              in MidiNote.allNoteLabels().skip(24))
                            DropdownMenuItem(
                              child: Text(label),
                              value: label,
                            ),
                        ],
                        value: widget.currentTuningPitches[pitchIndex],
                        onChanged: (String? selPitchLabel) {
                          _setTuningPitch(pitchIndex, selPitchLabel);
                        }),
                    const SizedBox(
                      width: 12,
                    )
                  ],
                )
            ],
          ),
        )
      ],
    );
  }
}
