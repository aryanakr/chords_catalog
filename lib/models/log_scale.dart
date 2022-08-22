import 'package:chords_catalog/models/note.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

class LogScale {
  String root;
  List<String> notes;

  LogScale({required this.root, required this.notes});

  
  static Future<List<List<dynamic>>> loadLib () async {
    
    final rawData = await rootBundle.loadString("assets/scales.csv");
    final List<List<dynamic>> data = CsvToListConverter().convert(rawData);

    return data;
  }
}

class BaseScale {
  final String name;
  final List<int> intervals;

  BaseScale({required this.name, required this.intervals});

  LogScale createLogScale(String rootKey) {
    final keyIndex = MidiNote.sharpNoteLabels.indexOf(rootKey);

    final List<String> notes = [MidiNote.sharpNoteLabels[keyIndex]];

    int currIndex = keyIndex;
    for (final interval in intervals) {
      if (currIndex+interval >= MidiNote.sharpNoteLabels.length) {
        currIndex =  (currIndex + interval) - MidiNote.sharpNoteLabels.length;
      } else {
        currIndex += interval;
      }
      notes.add(MidiNote.sharpNoteLabels[currIndex]);
    }

    return LogScale(root: rootKey, notes: notes);
  }
}