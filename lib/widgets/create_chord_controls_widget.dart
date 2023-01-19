import 'package:chords_catalog/models/chord.dart';
import 'package:chords_catalog/providers/log_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/number_picker.dart';

class CreateChordControlsWidget extends StatefulWidget {
  final String chordKey;
  final String chordType;
  final List<String?> notes;
  final int startFret;
  final bool hasSuggested;
  final Function(int) setStartFret;
  final Function(String) submitKey;
  final Function(Chord?) submitChord;
  final Function makeSuggestion;

  const CreateChordControlsWidget(
      {Key? key,
      required this.startFret,
      required this.setStartFret,
      required this.chordKey,
      required this.chordType,
      required this.submitKey,
      required this.submitChord,
      required this.makeSuggestion,
      required this.hasSuggested,
      required this.notes})
      : super(key: key);

  @override
  State<CreateChordControlsWidget> createState() =>
      _CreateChordControlsWidgetState();
}

class _CreateChordControlsWidgetState extends State<CreateChordControlsWidget> {
  @override
  Widget build(BuildContext context) {
    List<String> uniqueNotes = [];

    for (int i = 0; i < widget.notes.length; i++) {
      if (widget.notes[i] != null && !uniqueNotes.contains(widget.notes[i])) {
        uniqueNotes.add(widget.notes[i]!);
      }
    }

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Root',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(
                width: 32,
              ),
              SizedBox(
                width: 100,
                child: DropdownButton(
                    items: [
                      for (String noteLabel
                          in Provider.of<LogProvider>(context, listen: false)
                              .scale!
                              .notes)
                        DropdownMenuItem(
                          child: Text(noteLabel),
                          value: noteLabel,
                        ),
                    ],
                    isExpanded: true,
                    value: widget.chordKey,
                    onChanged: (String? s) {
                      if (s != null) widget.submitKey(s);
                    }),
              ),
            ],
          ),
          FutureBuilder(
              future: Chord.loadLib(),
              initialData: [],
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data != null) {
                  final data = snapshot.data as List<List<dynamic>>;

                  final List<Chord> possibleChords = [];

                  final scale = Provider.of<LogProvider>(context, listen: false)
                      .scale!
                      .notes;

                  for (List<dynamic> row in data) {
                    final chord = Chord.createChordFromLibRow(row);

                    if (chord.root == widget.chordKey &&
                        !chord.noteLabels
                            .any((element) => !scale.contains(element))) {
                      possibleChords.add(chord);
                    }
                  }

                  return Row(
                    children: [
                      const Text(
                        'Type',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(
                        width: 32,
                      ),
                      SizedBox(
                        width: 100,
                        child: DropdownButton(
                            items: [
                              const DropdownMenuItem(
                                child: Text('Select'),
                                value: '',
                              ),
                              for (int i = 0; i < possibleChords.length; i++)
                                DropdownMenuItem(
                                  child: Text(possibleChords[i].type),
                                  value: possibleChords[i].type.toString(),
                                ),
                            ],
                            isExpanded: true,
                            value: widget.chordType,
                            onChanged: (String? selected) {
                              if (selected != null && selected.isNotEmpty) {
                                final selectedChord = possibleChords.firstWhere(
                                    (element) => element.type == selected);
                                widget.submitChord(selectedChord);
                              } else {
                                widget.submitChord(null);
                              }
                            }),
                      ),
                      SizedBox(
                        width: 36,
                      ),
                      if (widget.chordType.isEmpty &&
                          uniqueNotes.length > 2 &&
                          !widget.hasSuggested)
                        TextButton(
                            onPressed: () {
                              widget.makeSuggestion();
                            },
                            child: Row(
                              children: const [
                                Icon(Icons.lightbulb),
                                Text(
                                  'Suggest',
                                  style: TextStyle(fontSize: 16),
                                )
                              ],
                            ))
                    ],
                  );
                }
                return Row(
                  children: [
                    Text(
                      'Type',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      width: 32,
                    ),
                    SizedBox(
                      width: 100,
                      child: DropdownButton(
                          items: [
                            DropdownMenuItem(
                              child: widget.chordType.isEmpty
                                  ? Text('Select')
                                  : Text(widget.chordType),
                              value: widget.chordType,
                            )
                          ],
                          isExpanded: true,
                          value: widget.chordType,
                          onChanged: (String? selected) {}),
                    ),
                  ],
                );
              })),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Text(
                'Notes',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                width: 32,
              ),
              for (int i = 0; i < uniqueNotes.length; i++)
                Row(
                  children: [
                    Text(
                      uniqueNotes[i],
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                  ],
                ),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Text(
                'Starting fret',
                style: TextStyle(fontSize: 18),
              ),
              NumberPicker(
                min: 1,
                max: 20,
                value: widget.startFret,
                update: widget.setStartFret,
                buttonsAxis: Axis.horizontal,
                showArrowIcons: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
