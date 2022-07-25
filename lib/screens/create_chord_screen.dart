import 'package:chords_catalog/components/painters/chord_card_painter.dart';
import 'package:chords_catalog/models/chord.dart';
import 'package:chords_catalog/models/note.dart';
import 'package:chords_catalog/providers/log_provider.dart';
import 'package:chords_catalog/screens/chord_view_screen.dart';
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
  int startFret = 0;

  String selectedRootLabel = 'C';

  void _submit(BuildContext context) {
    Navigator.of(context).pushNamed(ChordViewScreen.routeName);
  }

  bool addNote(MidiNote note, int string, int fret) {
    setState(() {
      chordNotes[string] = note;
      chordCardNotes[string] = fret;
    });

    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    numStrings = Provider.of<LogProvider>(context, listen: false)
        .tuning!
        .openNotes
        .length;
    chordNotes = [for (int i = 0; i < numStrings; i++) null];
    chordCardNotes = [for (int i = 0; i < numStrings; i++) null];
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
          Center(
              child: CustomPaint(
            size: Size(200, 200),
            painter: ChordCardPainter(
                numStrings: numStrings,
                startFret: startFret,
                notes: chordCardNotes),
          )),
          SizedBox(
            height: 10,
          ),
          FutureBuilder(
              future: Chord.loadLib(),
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                  final data = snapshot.data as List<List<dynamic>>;

                  final List<List<dynamic>> dataFiltered = [];

                  for (List<dynamic> row in data) {
                    if (row[0].toString() == selectedRootLabel) {
                      dataFiltered.add(row);
                    }
                  }

                  
                  return Text(dataFiltered[1].toString());
                }
                  return Text("Hello");
                
                
              })
              ),
          Expanded(child: Container()),
          FretboardWidget(
            addNote: addNote,
          )
        ],
      ),
    );
  }
}
