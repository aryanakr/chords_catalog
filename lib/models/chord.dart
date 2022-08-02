

import 'package:chords_catalog/models/note.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

class Chord {

  final String root;
  final String type;
  final String structure;
  final List<String> noteLabels;

  Chord({required this.root, required this.type, required this.structure, required this.noteLabels});

  static Future<List<List<dynamic>>> loadLib () async {
    
    final rawData = await rootBundle.loadString("assets/chords.csv");
    final List<List<dynamic>> data = CsvToListConverter().convert(rawData);

    return data;
  }
  
}

class GuitarChord {

  final Chord chord;
  final List<int?> cardDotsPos;
  final String name;
  final int startFret;
  final List<MidiNote> midiNotes;

  List<int?> drawCardDotsPos() {

    return cardDotsPos.map((e) => e == null || e == 0 ? e : e - startFret + 1).toList();
  }

  static List<int?> toDrawCardDotsPos(List<int?> notes, int startFret) {
    return notes.map((e) => e == null || e == 0 ? e : e - startFret + 1).toList();
  }

  GuitarChord({required this.chord, required this.name, required this.cardDotsPos, required this.startFret, required this.midiNotes});
}