import 'package:chords_catalog/models/chord.dart';
import 'package:chords_catalog/models/note.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

class LogScale {
  String root;
  List<String> notes;
  BaseScale base;

  LogScale({required this.root, required this.notes, required this.base});

  
  static Future<List<List<dynamic>>> loadLib () async {
    
    final rawData = await rootBundle.loadString("assets/scales.csv");
    final List<List<dynamic>> data = CsvToListConverter().convert(rawData);

    return data;
  }

  Future<List<Triad>> getTriads () async {

    final lib = await Chord.loadLib();
    List<Triad> triads = [];
    for (int i = 0 ; i<notes.length ; i++) {
      final root = notes[i];
      final third = notes[(i+2)%notes.length];
      final fifth = notes[(i+4)%notes.length];

      final tiradNotes = [root, third, fifth];
      print('$i tiradd notes: $tiradNotes');

      for (List<dynamic> chordRow in lib) {
        final chord = Chord.createChordFromLibRow(chordRow);
        //if (chord.noteLabels.length == 3 && chord.noteLabels.every((element) => tiradNotes.contains(element)))
        if (chord.noteLabels.length == 3 && chord.noteLabels[0] == root && chord.noteLabels[1] == third && chord.noteLabels[2] == fifth) {
          chord.noteLabels = tiradNotes;
          triads.add(Triad(chord: chord, number: i+1));
        }
      }

    }
    return triads;
  }
}

class Triad extends Chord {
  final int number;
  Triad({required Chord chord, required this.number}) : super(root: chord.root, type: chord.type, structure: chord.structure, noteLabels: chord.noteLabels);
  
  String getNumberLabel () {
    switch (number) {
      case 1:
        return "I";
      case 2:
        return "II";
      case 3:
        return "III";
      case 4:
        return "IV";
      case 5:
        return "V";
      case 6:
        return "VI";
      case 7:
        return "VII";
      default:
        return "";
    }
  }
}

class BaseScale {
  final String name;
  final List<int> intervals;
  final bool isCustomScale;

  BaseScale({required this.name, required this.intervals, this.isCustomScale = false});

  List<String> getNotes(String rootKey) {
    final allNotes = MidiNote.sharpNoteLabelsFromKey(rootKey);

    final List<String> res = [];

    final List<int> tmpIntervals = [];
    tmpIntervals.addAll(intervals);
    tmpIntervals.removeLast();

    int index = 0;
    for (int interval in tmpIntervals) {
      index += interval;
      res.add(allNotes[index]);
    }

    return res;
  }

  LogScale createLogScale(String rootKey) {
    return LogScale(root: rootKey, notes: getNotes(rootKey), base: this);
  }
}