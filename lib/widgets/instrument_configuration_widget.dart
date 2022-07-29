import 'dart:ffi';

import 'package:chords_catalog/components/number_picker.dart';
import 'package:chords_catalog/components/tuning_picker.dart';
import 'package:chords_catalog/models/instrument.dart';
import 'package:chords_catalog/models/note.dart';
import 'package:chords_catalog/screens/scale_configuration_screen.dart';
import 'package:flutter/material.dart';

class InstrumentConfigurationWidget extends StatefulWidget {
  final void Function(String, Tuning, InstrumentSound) submit;

  InstrumentConfigurationWidget({required this.submit});

  @override
  State<InstrumentConfigurationWidget> createState() => _InstrumentConfigurationWidgetState();
}

class _InstrumentConfigurationWidgetState extends State<InstrumentConfigurationWidget> {

  // Form Values

  final _nameController = TextEditingController();
  // Tuning
  int stringsNumber = 6;
  List<String> tuning = Tuning.standardTuning().openNotes.map((e) => e.label).toList();
  String tuningName = Tuning.standardTuning().name;

  InstrumentSound instrumentSound = InstrumentSound.DefaultSounds[0];

  void _setStringNumber(int value) {
    setState(() {
      stringsNumber = value;
      final prevTuning = tuning;

      tuning = [
        for (int i =0 ; i<stringsNumber;  i++)
          i < prevTuning.length ? prevTuning[i] : ''
      ];
    
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
      child: Column(
        children: [
          TextField(
                decoration: InputDecoration(labelText: 'Log Name'),
                controller: _nameController,
              ),
          Row(children: [
            Text('Number of Strings'),
            NumberPicker(value: this.stringsNumber, update: _setStringNumber, min: 1)
          ],),
          TuningPicker(numStrings: stringsNumber, update: _setTuning, currentTuningPitches: tuning, tuningName: tuningName),
          Row(children: [
            Text('Sound'),
            DropdownButton(items: [
              for (InstrumentSound sound in InstrumentSound.DefaultSounds)
                  DropdownMenuItem(
                    child: Text(sound.name),
                    value: sound,
                  ),
                ], 
                value: instrumentSound,
                onChanged: (InstrumentSound? selectedSound) {
                  if (selectedSound != null)
                    _setSound(selectedSound);
                })
          ],),
          ElevatedButton(onPressed: () {
            _submitForm();
          }, child: Text('Next'))
        ],
      ),
    );
  }
}