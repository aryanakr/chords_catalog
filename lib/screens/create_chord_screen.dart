import 'package:chords_catalog/components/number_picker.dart';
import 'package:chords_catalog/components/painters/chord_card_painter.dart';
import 'package:chords_catalog/models/chord.dart';
import 'package:chords_catalog/models/note.dart';
import 'package:chords_catalog/providers/log_provider.dart';
import 'package:chords_catalog/screens/chord_view_screen.dart';
import 'package:chords_catalog/screens/dashboard_screen.dart';
import 'package:chords_catalog/widgets/chord_card_widget.dart';
import 'package:chords_catalog/widgets/fretboard_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateChordScreen extends StatefulWidget {
  static const routeName = '/create-chord';
  const CreateChordScreen({Key? key}) : super(key: key);

  @override
  State<CreateChordScreen> createState() => _CreateChordScreenState();
}

class _CreateChordScreenState extends State<CreateChordScreen> {
  late List<MidiNote?> chordNotes;
  late List<int?> chordCardNotes;
  late int numStrings;
  int startFret = 1;

  String selectedRootLabel = 'C';
  Chord? selectedChordType = null;
  int selectedChordIndex = -1;

  void _setRootNote(String newLabel) {
    setState(() {
      selectedRootLabel = newLabel;
      selectedChordType = null;
      selectedChordIndex = -1;

      clearCard();
    });
  }

  void _setChordType(Chord? newChord, int index) {

    setState(() {
      selectedChordType = newChord;
      selectedChordIndex = index;

      clearCard();
    });

  }

  void _setStartFret(int fret) {
    setState(() {
      startFret = fret;

      // remove out of card notes and set the start fret
        final fretDiff = fret - startFret;
        for (int i = 0; i < chordCardNotes.length; i++) {
            final t = chordCardNotes[i];
            if (t != null && t != 0 && (t < fret || t-fret > 4)) {
              chordCardNotes[i] = null;
            }
          }
    });
  }

  void _submit(BuildContext context) {

    if (selectedChordType == null) {
      return;
    }

    final List<MidiNote> midiNotes = [];

    for (MidiNote? m in chordNotes) {
      if (m != null) {
        midiNotes.add(m);
      }
    }

    final guitarChord = GuitarChord(chord: selectedChordType!, name: _getChordName(), cardDotsPos: chordCardNotes, startFret: startFret, midiNotes: midiNotes);
    Provider.of<LogProvider>(context, listen: false).addChord(guitarChord);

    Navigator.of(context).pushReplacementNamed(DashboardScreen.routeName);
  }

  bool addNote(MidiNote note, int string, int fret) {
    setState(() {
      if (chordNotes[string] != null && chordNotes[string]!.midiNumber == note.midiNumber && chordCardNotes[string] == fret ) {
        chordNotes[string] = null;
        chordCardNotes[string] = null;
      } else {
        chordNotes[string] = note;
        chordCardNotes[string] = fret;
      }
    });

    return true;
  }

  String _getChordName() {
    if (selectedChordType == null) {
      return "Select Chord Type";
    }

    return selectedChordType!.root + selectedChordType!.type;
  }

  void clearCard() {
    chordNotes = [for (int i = 0; i < numStrings; i++) null];
    chordCardNotes = [for (int i = 0; i < numStrings; i++) null];

    startFret = 1;
  }

  @override
  void initState() {
    numStrings = Provider.of<LogProvider>(context, listen: false)
        .tuning!
        .openNotes
        .length;
    chordNotes = [for (int i = 0; i < numStrings; i++) null];
    chordCardNotes = [for (int i = 0; i < numStrings; i++) null];

    selectedRootLabel = Provider.of<LogProvider>(context, listen: false).scale!.root;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Chord'),
        actions: [
          IconButton(onPressed: () => _submit(context), icon: Icon(Icons.check))
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          ChordCardWidget(name: _getChordName(), numStrings: numStrings, startFret: startFret, notes: GuitarChord.toDrawCardDotsPos(chordCardNotes, startFret)),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text('Key:'),
              DropdownButton(
                  items: [
                    for (String noteLabel in Provider.of<LogProvider>(context, listen: false).scale!.notes)
                      DropdownMenuItem(
                        child: Text(noteLabel),
                        value: noteLabel,
                      ),
                  ],
                  value: selectedRootLabel,
                  onChanged: (String? s) {
                    if (s != null) _setRootNote(s);
                  }),
            ],
          ),
          FutureBuilder(
              future: Chord.loadLib(),
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data != null) {
                  final data = snapshot.data as List<List<dynamic>>;

                  final List<List<dynamic>> dataFiltered = [];

                  final scale = Provider.of<LogProvider>(context, listen: false).scale!.notes;

                  for (List<dynamic> row in data) {
                    final rowNotes = row[3].toString().split(',');
                    if (row[0].toString() == selectedRootLabel && !rowNotes.any((element) => !scale.contains(element))) {
                      dataFiltered.add(row);
                    }
                  }

                  return Row(
                    children: [
                      Text('Type:'),
                      DropdownButton(
                          items: [
                            DropdownMenuItem(
                              child: Text('Select'),
                              value: -1,
                            ),
                            for (int i = 0; i < dataFiltered.length; i++)
                              DropdownMenuItem(
                                child: Text(dataFiltered[i][1].toString()),
                                value: i,
                              ),
                          ],
                          value: selectedChordIndex,
                          onChanged: (int? index) {
                            if (index != null  && index >= 0){
                              Chord newChord = Chord(root: dataFiltered[index][0].toString(), type: dataFiltered[index][1].toString(), structure:  dataFiltered[index][2].toString(), noteLabels: dataFiltered[index][3].toString().split(','));
                              _setChordType(newChord, index);
                            }
                            else {
                              _setChordType(null, -1);
                            }
                          }),
                    ],
                  );
                }
                return Container();
              })),
          
          Row(
            children: [
              Text('Starting fret'),
              NumberPicker(min: 1, max: 19, value: startFret, update: _setStartFret),
            ],
          ),
          Expanded(child: Container()),
          FretboardWidget(
            addNote: addNote,
            startFret: startFret,
            enabledNotes: selectedChordType == null ? Provider.of<LogProvider>(context, listen: false).scale!.notes : selectedChordType!.noteLabels
          )
        ],
      ),
    );
  }
}
