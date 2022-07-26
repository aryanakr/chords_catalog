

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