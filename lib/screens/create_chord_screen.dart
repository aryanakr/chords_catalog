import 'package:chords_catalog/components/number_picker.dart';
import 'package:chords_catalog/components/painters/chord_card_painter.dart';
import 'package:chords_catalog/models/chord.dart';
import 'package:chords_catalog/models/note.dart';
import 'package:chords_catalog/providers/log_provider.dart';
import 'package:chords_catalog/providers/sound_player_provider.dart';
import 'package:chords_catalog/screens/chord_view_screen.dart';
import 'package:chords_catalog/screens/dashboard_screen.dart';
import 'package:chords_catalog/widgets/chord_card_widget.dart';
import 'package:chords_catalog/widgets/create_chord_controls_widget.dart';
import 'package:chords_catalog/widgets/fretboard_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:random_color/random_color.dart';

import '../theme/chord_log_colors.dart';

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
  Chord? selectedBaseChord = null;
  String selectedChordType = '';

  void _setRootNote(String newLabel) {
    setState(() {
      selectedRootLabel = newLabel;
      selectedBaseChord = null;
      selectedChordType = '';

      clearCard();
    });
  }

  void _setChordType({Chord? newChord, bool keepNotes = false}) {
    setState(() {
      selectedBaseChord = newChord;
      selectedChordType = newChord?.type ?? '';
      if (!keepNotes) {
        clearCard();
      }
    });
  }

  void _setStartFret(int fret) {
    setState(() {
      startFret = fret;

      // remove out of card notes and set the start fret
      final fretDiff = fret - startFret;
      for (int i = 0; i < chordCardNotes.length; i++) {
        final t = chordCardNotes[i];
        if (t != null && t != 0 && (t < fret || t - fret > 4)) {
          chordCardNotes[i] = null;
        }
      }
    });
  }

  bool isFretboardVisibile = true;
  void _setFretboardVisibility(bool state) {
    setState(() {
      isFretboardVisibile = state;
    });
  }

  void _submit(BuildContext context) {
    if (selectedBaseChord == null) {
      return;
    }

    final guitarChord = GuitarChord(
        chord: selectedBaseChord!,
        name: _getChordName(),
        cardDotsPos: chordCardNotes,
        startFret: startFret,
        midiNotes: chordNotes,
        cardColor: currentColor);
    Provider.of<LogProvider>(context, listen: false)
        .saveChord(chord: guitarChord, index: logIndex);

    Navigator.of(context)
        .pushNamedAndRemoveUntil(DashboardScreen.routeName, (route) => false);
  }

  bool addNote(MidiNote note, int string, int fret) {
    setState(() {
      hasSuggested = false;
      if (chordNotes[string] != null &&
          chordNotes[string]!.midiNumber == note.midiNumber &&
          chordCardNotes[string] == fret) {
        chordNotes[string] = null;
        chordCardNotes[string] = null;
      } else {
        chordNotes[string] = note;
        chordCardNotes[string] = fret;
        Provider.of<SoundPlayerProvider>(context, listen: false).playNote(note);
      }
    });

    return true;
  }

  void _playChord() {

    if (!chordNotes.any((element) => element != null)) {
      return;
    }

    final guitarChord = GuitarChord(
        chord: selectedBaseChord!,
        name: _getChordName(),
        cardDotsPos: chordCardNotes,
        startFret: startFret,
        midiNotes: chordNotes,
        cardColor: currentColor);
    
    final soundPlayer = Provider.of<SoundPlayerProvider>(context, listen: false);

    soundPlayer.startSequence(guitarChord.getDemoSequence());
  }

  String _getChordName() {
    if (selectedBaseChord == null) {
      return "Select Chord Type";
    }

    return selectedBaseChord!.root + selectedBaseChord!.type;
  }

  void clearCard() {
    chordNotes = [for (int i = 0; i < numStrings; i++) null];
    chordCardNotes = [for (int i = 0; i < numStrings; i++) null];

    startFret = 1;
  }

  Future<void> suggestChord() async {
    setState(() {
      hasSuggested = true;
    });

    final lib = await Chord.loadLib();

    final List<String> notNullChordNotes = [];
    for (int i = 0; i < chordNotes.length; i++) {
      if (chordNotes[i] != null) {
        notNullChordNotes.add(chordNotes[i]!.getNoteLabel());
      }
    }

    Chord? suggestion = null;

    for (List<dynamic> row in lib) {
      final chord = Chord.createChordFromLibRow(row);

      if (chord.root == selectedRootLabel &&
          !chord.noteLabels
              .any((element) => !notNullChordNotes.contains(element))) {
        suggestion = chord;
        break;
      }
    }

    if (suggestion != null) {
      _setChordType(newChord: suggestion, keepNotes: true);
    }
  }

  void setChordTypeDef(Chord? chord) {
    _setChordType(newChord: chord);
  }

  bool hasSuggested = false;

  @override
  void initState() {
    super.initState();

    numStrings = Provider.of<LogProvider>(context, listen: false)
        .tuning!
        .openNotes
        .length;
    chordNotes = [for (int i = 0; i < numStrings; i++) null];
    chordCardNotes = [for (int i = 0; i < numStrings; i++) null];

    selectedRootLabel =
        Provider.of<LogProvider>(context, listen: false).scale!.root;
  }

  bool hasInit = false;
  GuitarChord? initialChord = null;
  int logIndex = -1;

  Color pickerColor = Colors.white;
  Color currentColor = Colors.white;

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  void showColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick color for card!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: changeColor,
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Set Color'),
              onPressed: () {
                setState(() => currentColor = pickerColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as CreateChordArgs;
    final chord = args.chord;
    if (!hasInit) {
      if (chord != null) {
        numStrings = chord.cardDotsPos.length;
        chordNotes = chord.midiNotes.isEmpty
            ? [for (int i = 0; i < numStrings; i++) null]
            : chord.midiNotes;
        chordCardNotes = chord.cardDotsPos;
        startFret = chord.startFret;
        selectedRootLabel = chord.chord.root;
        selectedBaseChord = chord.chord;
        selectedChordType = chord.chord.type;
        currentColor = chord.cardColor;
        pickerColor = currentColor;
        logIndex = args.logIndex;

        initialChord = chord;
      } else {
        pickerColor = RandomColor().randomColor(
            colorBrightness: ColorBrightness.veryLight,
            colorSaturation: ColorSaturation.mediumSaturation);
        currentColor = pickerColor;
      }
      hasInit = true;
    }

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            title: Text('Create Chord'),
            backgroundColor: ChordLogColors.bodyColor,
            actions: [
              IconButton(
                  onPressed: () => _submit(context), icon: const Icon(Icons.save))
            ],
          )
        ],
        body: Container(
          decoration:
              const BoxDecoration(gradient: ChordLogColors.backGroundGradient),
          child: Stack(children: [
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(38),
                  topRight: Radius.circular(38),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 16),
                          child: ElevatedButton(
                            onPressed: () {
                              showColorPicker();
                            },
                            child: Icon(Icons.color_lens),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(CircleBorder()),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.all(10)),
                              backgroundColor: MaterialStateProperty.all(
                                  ChordLogColors.primary),
                            ),
                          ),
                        ),
                        Container(
                          color: currentColor,
                          child: ChordCardWidget(
                              paintSize: 225,
                              name: _getChordName(),
                              numStrings: numStrings,
                              startFret: startFret,
                              notes: GuitarChord.toDrawCardDotsPos(
                                  chordCardNotes, startFret)),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 16),
                          child: ElevatedButton(
                            onPressed: _playChord,
                            child: Icon(Icons.volume_up),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(CircleBorder()),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.all(10)),
                              backgroundColor: MaterialStateProperty.all(
                                  ChordLogColors.primary),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CreateChordControlsWidget(
                        startFret: startFret,
                        setStartFret: _setStartFret,
                        chordKey: selectedRootLabel,
                        chordType: selectedChordType,
                        makeSuggestion: suggestChord,
                        hasSuggested: hasSuggested,
                        notes: selectedBaseChord != null
                            ? selectedBaseChord!.noteLabels
                            : chordNotes.map((e) => e?.getNoteLabel()).toList(),
                        submitKey: _setRootNote,
                        submitChord: setChordTypeDef),
                    SizedBox(
                      height: 32,
                    ),
                    ElevatedButton(
                        onPressed: () => _submit(context),
                        child: Text('Save Chord')),
                    SizedBox(
                      height:
                          isFretboardVisibile ? 25.0 * (numStrings - 2) : 32,
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width,
                        color: ChordLogColors.bodyColor,
                        child: TextButton(
                          child: isFretboardVisibile
                              ? Icon(
                                  Icons.arrow_downward_rounded,
                                  color: Colors.white,
                                )
                              : Icon(
                                  Icons.arrow_upward_rounded,
                                  color: Colors.white,
                                ),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size(50, 30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () => _setFretboardVisibility(
                              isFretboardVisibile ? false : true),
                        )),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 250),
                      height: isFretboardVisibile
                          ? chordCardNotes.length * 30.0 + 20
                          : 0,
                      child: Wrap(
                        children: [
                          FretboardWidget(
                              addNote: addNote,
                              startFret: startFret,
                              enabledNotes: selectedBaseChord == null
                                  ? chordNotes.any((element) => element != null)
                                      ? Provider.of<LogProvider>(context,
                                              listen: false)
                                          .scale!
                                          .notes
                                      : [selectedRootLabel]
                                  : selectedBaseChord!.noteLabels),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}

class CreateChordArgs {
  final GuitarChord? chord;
  int logIndex;

  CreateChordArgs({this.chord, this.logIndex = -1});
}
