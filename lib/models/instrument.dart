import 'dart:convert';

import 'package:chords_catalog/helpers/db_helper.dart';
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
  int id = -1;
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

    final tuning = Tuning(
      id: map['id'],
      name: map['name'],
      openNotes: map['open_notes'].toString().split(',').map((e) => MidiNote.byLabel(label : e)).toList(),
      numStrings: map['num_strings'],
      isCustomTuning: map['is_custom'] == 1,
    );

    return tuning;
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

  static Future<Map<int, List<Tuning>>> loadLib() async {

    // Load the JSON file from the "assets" folder
    final String response = await rootBundle.loadString('assets/tunings.json');
    final Map<String, dynamic> data = await json.decode(response);

    // Load from databse
    final dbInstance = DBHelper.instance;
    final dbTunings = await dbInstance.queryAllTunings();

    return _parseTuningList(data, dbTunings);
  }

  static Map<int, List<Tuning>> _parseTuningList(Map<String, dynamic> data, List<Tuning> dbTunings) {

    print('dbtuning count: ${dbTunings.length}');
    final Map<int, List<Tuning>> res = {};

    for (var t in dbTunings) {
      if (!res.containsKey(t.numStrings)) {
        res[t.numStrings] = [];
      }
      res[t.numStrings]!.add(t);
    }

    for (final numStr in data.keys) {
      final Map<String, dynamic> strTunning = data[numStr];
      final numStrasInt = int.parse(numStr);
      final List<Tuning> tunings = [];
      for (final key in strTunning.keys) {
        final openNotes = strTunning[key]
            .toString()
            .split(',')
            .map((e) => MidiNote.byLabel(label: e))
            .toList();
        final tuning =
            Tuning(name: key, openNotes: openNotes, numStrings: numStrasInt);
        tunings.add(tuning);
      }

      if (!res.containsKey(numStrasInt)) {
        res[numStrasInt] = tunings;
      } else {
        final filteredTunings = tunings.where((element) => !res[numStrasInt]!.any((dbTuining) => dbTuining.name == element.name)).toList();
        res[numStrasInt]!.addAll(filteredTunings);
      }
    }

    return res;
  }

  static String customTuningName =  'Custom';

}

