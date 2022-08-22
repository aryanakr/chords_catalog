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
  final void Function(String, Tuning, InstrumentSound) submit;
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
  List<String> tuning = Tuning.standardTuning().openNotes.map((e) => e.label).toList();
  String tuningName = Tuning.standardTuning().name;

  // Scale
  String scaleRoot = 'C';
  List<String> scaleNotes = ['C'];

  InstrumentSound instrumentSound = InstrumentSound.DefaultSounds[0];

  void _setStringNumber(int value) {
    setState(() {
      stringsNumber = value;
      final prevTuning = tuning;

      tuning = [
        for (int i =0 ; i<stringsNumber;  i++)
          i < prevTuning.length ? prevTuning[i] : ''
      ];

      tuningName = widget.loadedTunings[stringsNumber]?[0].name ?? '';
      if (tuningName.isNotEmpty) {
        tuning = widget.loadedTunings[stringsNumber]![0].openNotes.map((e) => e.label).toList();
      }
    
    });
  }

  void _setTuning(String name, List<String> selTuning) {
    setState(() {
      tuning = selTuning;
      tuningName = name;
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
    else if (tuning.any((element) => element == '')) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all pitches!')));
    } else {
      final midiNotes = tuning.map((e) => MidiNote.byLabel(label: e)).toList();
      final finalTuning = Tuning(name: tuningName, openNotes: midiNotes, numStrings: stringsNumber);
      widget.submit(_nameController.text, finalTuning, instrumentSound);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
                decoration: const InputDecoration(labelText: 'Log Name'),
                controller: _nameController,
              ),
          const SizedBox(height: 8,),
          Row(children: [
            const Text('Strings', style: TextStyle(fontSize: 18),),
            NumberPicker(value: stringsNumber, update: _setStringNumber, min: 1)
          ],),
          TuningConfigurationWidget(
            numStrings: stringsNumber, 
            update: _setTuning, 
            currentTuningPitches: tuning, 
            tuningName: tuningName, 
            defaultTunings: widget.loadedTunings[stringsNumber] ?? [],
            ),
          SizedBox(height: 16,),
          ScaleConfigurationWidget(root: scaleRoot, notes: scaleNotes, defaultScales: widget.loadedScales,),
          SizedBox(height: 16,),
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