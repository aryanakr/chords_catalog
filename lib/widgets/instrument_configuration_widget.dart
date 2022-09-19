import 'dart:ffi';

import 'package:chords_catalog/components/number_picker.dart';
import 'package:chords_catalog/models/instrument.dart';
import 'package:chords_catalog/models/log_scale.dart';
import 'package:chords_catalog/models/note.dart';
import 'package:chords_catalog/screens/scale_configuration_screen.dart';
import 'package:chords_catalog/widgets/scale_configuration_widget.dart';
import 'package:chords_catalog/widgets/scale_interval_creator_widget.dart';
import 'package:chords_catalog/widgets/tuning_configuration_widget.dart';
import 'package:flutter/material.dart';

class LogConfigurationWidget extends StatefulWidget {
  final void Function(String, Tuning, InstrumentSound, LogScale) submit;
  final Map<int,List<Tuning>> loadedTunings;
  final List<BaseScale> loadedScales;

  LogConfigurationWidget({required this.submit, required this.loadedTunings, required this.loadedScales});

  @override
  State<LogConfigurationWidget> createState() => _LogConfigurationWidgetState();
}

class _LogConfigurationWidgetState extends State<LogConfigurationWidget> {

  // Form Values
  final _nameController = TextEditingController();

  // Tuning
  int stringsNumber = 6;
  Tuning tuning = Tuning.standardTuning();

  // Scale
  String scaleRoot = 'C';
  List<String> scaleNotes = ['C'];

  late BaseScale scaleBase;
  late LogScale scale;

  InstrumentSound instrumentSound = InstrumentSound.DefaultSounds[0];

  @override
  void initState() {
    scaleBase = widget.loadedScales[0];
    scale = scaleBase.createLogScale(scaleRoot);
    super.initState();
  }

  void _setStringNumber(int value) {
    setState(() {
      stringsNumber = value;

      final newTuningName = widget.loadedTunings[stringsNumber]?[0].name ?? '';
      if (newTuningName.isNotEmpty) {
        tuning = widget.loadedTunings[stringsNumber]![0];
      } else {
        final List<MidiNote?> newPitches = [
          for (int i =0 ; i<stringsNumber;  i++) 
            i < tuning.openNotes.length ? tuning.openNotes[i] : null
        ];
        tuning = Tuning(name: Tuning.customTuningName,numStrings: stringsNumber, openNotes: newPitches, isCustomTuning: true);
      }
    
    });
  }

  void _setTuning(Tuning newTuning) {
    setState(() {
      tuning = newTuning;
    });
  }

  void _setScale(String root, BaseScale baseScale) {
    setState(() {
      scaleRoot = root;
      scaleBase = baseScale;

      final allNotes = MidiNote.sharpNoteLabelsFromKey(scaleRoot);
      print('allNotes: $allNotes');
      final List<int> intervals = [];
      intervals.addAll(scaleBase.intervals);
      intervals.removeLast();

      scaleNotes.clear();
      scaleNotes.add(scaleRoot);

      int index = 0;
      for (int interval in intervals) {
        index += interval;
        final newNote = allNotes[index];
        print('interval $interval adding  '+newNote);
        scaleNotes.add(allNotes[index]);
      }
      
      scale = LogScale(root: scaleRoot, notes: scaleNotes, base: baseScale);
    });
  }

  void _setSound(InstrumentSound sound) {
    setState(() {
      instrumentSound = sound;
    });
  }

  void _submitForm() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please name this log!')));
    }
    else if (tuning.openNotes.any((element) => element == null)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all the tuning pitches!')));
    } else {
      widget.submit(_nameController.text, tuning, instrumentSound, scale);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
                decoration: const InputDecoration(labelText: 'Log Name', hintText: 'New Log'),
                controller: _nameController,
              ),
          const SizedBox(height: 8,),
          Row(children: [
            const Text('Strings', style: TextStyle(fontSize: 18),),
            NumberPicker(value: stringsNumber, update: _setStringNumber, min: 1)
          ],),
          TuningConfigurationWidget(
            update: _setTuning, 
            currentTuning: tuning, 
            defaultTunings: widget.loadedTunings[stringsNumber] ?? [],
            ),
          const SizedBox(height: 16,),
          ScaleConfigurationWidget(root: scaleRoot, baseScale: scaleBase, defaultScales: widget.loadedScales, submit: _setScale),
          const SizedBox(height: 16,),
          Row(children: [
            const Text('Sound', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 24,),
            DropdownButton(items: [
              for (InstrumentSound sound in InstrumentSound.DefaultSounds)
                  DropdownMenuItem(
                    child: Text(sound.name),
                    value: sound,
                  ),
                ], 
                value: instrumentSound,
                onChanged: (InstrumentSound? selectedSound) {
                  if (selectedSound != null) {
                    _setSound(selectedSound);
                  }
                }),
            IconButton(onPressed: (){}, icon: Icon(Icons.volume_down))
          ],),
          Expanded(child: Container(),),
          ElevatedButton(onPressed: () {
            _submitForm();
          }, child: const Text('Next'))
        ],
      ),
    );
  }
}