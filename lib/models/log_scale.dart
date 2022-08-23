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
    return LogScale(root: rootKey, notes: getNotes(rootKey));
  }
}