import 'dart:convert';

import 'package:chords_catalog/models/note.dart';
import 'package:flutter/services.dart';

class InstrumentSound {
  String path;
  String name;

  InstrumentSound({required this.path, required this.name});

  static List<InstrumentSound> DefaultSounds = [
    InstrumentSound(path: 'assets/ElectricGuitars.sf2', name: 'ElectricGuitar'),
    InstrumentSound(path: 'assets/PerfectSine.sf2', name: 'PerfectSine'),
    InstrumentSound(path: 'assets/Piano.sf2', name: 'Piano')
  ];

  static getSoundFromName(String name) {
    return DefaultSounds.firstWhere((element) => element.name == name);
  }
}

class Tuning {
  late int id;
  late String name;
  late List<MidiNote?> openNotes;
  late bool isCustomTuning;
  late int numStrings;

  Tuning({this.id = -1, required this.name, required this.openNotes, required this.numStrings, this.isCustomTuning = false});


  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'open_notes': openNotes.map((e) => e!.label).join(','),
      'num_strings': numStrings,
      'is_custom': isCustomTuning ? 1 : 0,
    };
  }

  static Tuning fromMap(Map<String, dynamic> map) {
    return Tuning(
      id: map['id'],
      name: map['name'],
      openNotes: map['open_notes'].split(',').map((e) => MidiNote.byLabel(label : e)).toList(),
      numStrings: map['num_strings'],
      isCustomTuning: map['is_custom'] == 1,
    );
  }

  Tuning.standardTuning() {
    openNotes = [
      MidiNote.byLabel(label: 'E2'),
      MidiNote.byLabel(label: 'A2'),
      MidiNote.byLabel(label: 'D3'),
      MidiNote.byLabel(label: 'G3'),
      MidiNote.byLabel(label: 'B3'),
      MidiNote.byLabel(label: 'E4'),
    ];
    isCustomTuning = false;
    name = 'Standard';
    numStrings = 6;

  }

  static Future<Map<String, dynamic>> loadLib() async {

    // Load the JSON file from the "assets" folder
    final String response = await rootBundle.loadString('assets/tunings.json');
    final Map<String, dynamic> data = await json.decode(response);

    return data;
  }

  static String customTuningName =  'Custom';

}

