import 'package:chords_catalog/models/chord.dart';
import 'package:chords_catalog/models/midi_sequence.dart';
import 'package:chords_catalog/models/progression.dart';
import 'package:chords_catalog/providers/log_provider.dart';
import 'package:chords_catalog/providers/sound_player_provider.dart';
import 'package:chords_catalog/screens/progressions_screen.dart';
import 'package:chords_catalog/theme/chord_log_colors.dart';
import 'package:chords_catalog/theme/chord_log_custom_icons_icons.dart';
import 'package:chords_catalog/widgets/progression_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:provider/provider.dart';

import '../widgets/chord_card_widget.dart';

class CreateProgressionScreen extends StatefulWidget {
  static const routeName = '/create-progression';
  const CreateProgressionScreen({Key? key}) : super(key: key);

  @override
  State<CreateProgressionScreen> createState() =>
      _CreateProgressionScreenState();
}

class _CreateProgressionScreenState extends State<CreateProgressionScreen> {
  void submit() {

    if (_nameController.text.isEmpty) {
      const snackBar = SnackBar(
        content: Text('Please enter a name for the progression.'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    final log = Provider.of<LogProvider>(context, listen: false);

    final sequences =progressionUIContent.map((e) => e.sequence).toList();
    final sequence = MidiSequence.getMerged(sequences, tempo);

    final progression = Progression(
      name: _nameController.text,
      sequence: sequence,
      contentElements: progressionUIContent,
    );

    log.saveProgression(progression: progression, index: progressionIndex);

    // remove navigator content and go back to progressions screen
    Navigator.of(context).pushNamedAndRemoveUntil(ProgressionsScreen.routeName,(route) => false);
  }

  void addChord(GuitarChord? chord) {
    final weight = getSelectedWeight();
    final mode = getSelectedPlayMode();

    setState(() {

      MidiSequence sequence = chord == null ? 
        MidiSequence(
            tempo: tempo, notes: [SequenceNote(notes: [], weight: weight)])
       : 
        MidiSequence(tempo: tempo, notes: chord.getSequenceNotesByMode(weight, mode));
      
      final newContent = ProgressionContentElement(chord: chord, weight: weight, playMode: mode, sequence: sequence);
      if (editIndex >= progressionUIContent.length) {
        progressionUIContent.add(newContent);
      } else {
        progressionUIContent[editIndex] = newContent;
      }
      moveEditForward();
    });
  }

  void showTempoPicker(BuildContext context) {
    final picker = Picker(
        adapter: NumberPickerAdapter(data: [
          NumberPickerColumn(begin: 20, end: 300, initValue: tempo),
        ]),
        title: const Text('Set Tempo'),
        onConfirm: (Picker picker, List value) {
          setState(() {
            tempo = picker.getSelectedValues()[0];
          });
        });

    picker.show(Scaffold.of(context));
  }

  void deleteNote() {
    setState(() {
      progressionUIContent.removeAt(editIndex);
    });
  }

  void demoChord(GuitarChord chord) {
    final weight = getSelectedWeight();
    final mode = getSelectedPlayMode();

    final sequence = MidiSequence(tempo: tempo, notes: chord.getSequenceNotesByMode(weight, mode));
    final player = Provider.of<SoundPlayerProvider>(context, listen: false);
    player.startSequence(sequence);
  }

  void play() {

    final sequences =progressionUIContent.map((e) => e.sequence).toList();

    final sequence = MidiSequence.getMerged(sequences, tempo);
    Provider.of<SoundPlayerProvider>(context, listen: false)
        .startSequence(sequence);
  }

  void stop() {
    Provider.of<SoundPlayerProvider>(context, listen: false).pause();
  }

  void incrementEditIndex(int i) {
    setState(() {
      editIndex += i;
    });
  }

  NoteWeight getSelectedWeight() {
    final selectIndex = selectedWeightStates.indexOf(true);
    return NoteWeight.values[selectIndex];
  }

  ChordPLayMode getSelectedPlayMode() {
    final selectIndex = selectedModeStates.indexOf(true);
    return ChordPLayMode.values[selectIndex];
  }

  final List<bool> selectedWeightStates = [
    false,
    false,
    true,
    false,
    false,
    false
  ];

  final List<bool> selectedModeStates = [false, true, false];

  void moveEditForward() {
    incrementEditIndex(1);
  }

  void moveEditBackward() {
    incrementEditIndex(-1);
  }

  int tempo = 120;
  int editIndex = 0;

  int progressionIndex = -1;

  List<ProgressionContentElement> progressionUIContent = [];

  final TextEditingController _nameController = TextEditingController();

  void loadProgression(CreateProgressionArgs args) {
    if (args.progression == null) {
      return;
    }

    setState(() {
      tempo = args.progression!.sequence.tempo;
      _nameController.text = args.progression!.name;
      progressionUIContent = args.progression!.contentElements;
      progressionIndex = args.index;
    });
  }

  bool hasInit = false;

  @override
  Widget build(BuildContext context) {

    if (!hasInit){
      final args = ModalRoute.of(context)!.settings.arguments as CreateProgressionArgs;
      loadProgression(args);
      hasInit = true;
    }

    final isPlaying = Provider.of<SoundPlayerProvider>(context).isPlaying;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            title: const Text('Create Progression'),
            backgroundColor: ChordLogColors.bodyColor,
            actions: [
              IconButton(
                onPressed: submit,
                icon: const Icon(Icons.save),
              ),
            ],
            //add text field below title
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 2 - 24,
                          child: TextField(
                              controller: _nameController,
                              style: TextStyle(fontSize: 18),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                labelStyle: TextStyle(
                                    color: Colors.white, fontSize: 16),
                                labelText: 'Progression Name',
                              ))),
                      InkWell(
                        onTap: () => showTempoPicker(context),
                        child: Container(
                      child: Column(
                        children: [
                          const Text(
                            'Tempo',
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text('$tempo',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18)),
                        ],
                      ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
          ),
        ],
        body: Container(
          color: ChordLogColors.bodyColor,
          child: MediaQuery.of(context).orientation == Orientation.portrait
              ? bodyContent(isPlaying)
              : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: bodyContent(isPlaying),
                ),
        ),
      ),
    );
  }

  Widget bodyContent(bool isPlaying) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(38),
          topRight: Radius.circular(38),
        ),
      ),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              children: [
                SizedBox(
                  height:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? 72
                          : 24,
                ),
                ProgressionViewWidget(
                  isPlaying: isPlaying,
                  content: progressionUIContent,
                  editIndex: editIndex,
                )
              ],
            ),
            const SizedBox(height: 16,),
            controlPanel(isPlaying)
          ]),
    );
  }

  Widget controlPanel(bool isPlaying) {
    return Container(
      color: ChordLogColors.secondary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: MediaQuery.of(context).orientation == Orientation.portrait ? [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  controlPanelMainActions(isPlaying),
                  controlPanelModeSelection(),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      color: ChordLogColors.primary,
                      onPressed: editIndex < progressionUIContent.length
                          ? deleteNote
                          : null,
                      icon: Icon(Icons.delete)),
                  controlPanelWeightSelection()
                ],
              )
            ] : [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  controlPanelMainActions(isPlaying),
                  IconButton(
                      color: ChordLogColors.primary,
                      onPressed: editIndex < progressionUIContent.length
                          ? deleteNote
                          : null,
                      icon: Icon(Icons.delete)),
                  controlPanelModeSelection(),
                  controlPanelWeightSelection()
                ],
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          controlPanelChords()
        ],
      ),
    );
  }

  Widget controlPanelMainActions(bool isPlaying) {
    return Row(
      children: [
        IconButton(
            color: ChordLogColors.primary,
            onPressed: editIndex > 0 ? moveEditBackward : null,
            icon: Icon(Icons.arrow_back)),
        IconButton(
            color: ChordLogColors.primary,
            onPressed: progressionUIContent.length > 0
                ? (isPlaying ? stop : play)
                : null,
            icon: isPlaying ? Icon(Icons.stop) : Icon(Icons.play_arrow)),
        IconButton(
            color: ChordLogColors.primary,
            onPressed:
                editIndex < progressionUIContent.length ? moveEditForward : null,
            icon: Icon(Icons.arrow_forward)),
      ],
    );
  }

  Widget controlPanelModeSelection() {
    return Container(
        color: Colors.white,
        child: ToggleButtons(
          children: const [
            Icon(Icons.keyboard_double_arrow_down),
            Icon(Icons.more_vert_rounded),
            Icon(Icons.keyboard_double_arrow_up)
          ],
          isSelected: selectedModeStates,
          onPressed: (int index) {
            setState(() {
              for (int buttonIndex = 0;
                  buttonIndex < selectedModeStates.length;
                  buttonIndex++) {
                selectedModeStates[buttonIndex] = index == buttonIndex;
              }
            });
          },
          fillColor: ChordLogColors.bodyColor,
          selectedColor: Colors.white,
          borderColor: ChordLogColors.bodyColor,
        ));
  }

  Widget controlPanelWeightSelection() {
    return Container(
      color: Colors.white,
      child: ToggleButtons(
        children: const [
          Icon(ChordLogCustomIcons.whole_note, size: 14),
          Icon(ChordLogCustomIcons.half_note),
          Icon(ChordLogCustomIcons.quarter_note),
          Icon(ChordLogCustomIcons.eighth_note),
          Icon(ChordLogCustomIcons.sixteenth_note),
          Icon(ChordLogCustomIcons.thirty_second_note),
        ],
        isSelected: selectedWeightStates,
        onPressed: (int index) {
          setState(() {
            for (int i = 0; i < selectedWeightStates.length; i++) {
              selectedWeightStates[i] = i == index;
            }
          });
        },
        fillColor: ChordLogColors.bodyColor,
        selectedColor: Colors.white,
        borderColor: ChordLogColors.bodyColor,
      ),
    );
  }

  Widget controlPanelChords() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Consumer<LogProvider>(builder: (context, log, child) {
            return Row(
              children: [
                for (int i = 0; i < log.chords.length; i++)
                  Card(
                    elevation: 8,
                    color: log.chords[i].cardColor,
                    child: InkWell(
                      onTap: () {
                        addChord(log.chords[i]);
                      },
                      onLongPress: () {
                        demoChord(log.chords[i]);
                      },
                      child: ChordCardWidget(
                          paintSize: 120,
                          name: log.chords[i].name,
                          notes: log.chords[i].drawCardDotsPos(),
                          numStrings: log.tuning!.numStrings,
                          startFret: log.chords[i].startFret),
                    ),
                  )
              ],
            );
          }),
          Card(
            elevation: 8,
            color: Colors.white,
            child: InkWell(
              onTap: () {
                addChord(null);
              },
              child: const SizedBox(
                width: 115,
                height: 175,
                child: Center(
                  child: Icon(ChordLogCustomIcons.eight_silent_note, size: 75),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CreateProgressionArgs {
  final Progression? progression;
  int index;

  CreateProgressionArgs({this.progression, this.index = -1});
}
