

import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

class Chord {

  static Future<List<List<dynamic>>> loadLib () async {
    
    final rawData = await rootBundle.loadString("assets/chords.csv");
    List<List<dynamic>> data = CsvToListConverter().convert(rawData);
    print(data[0].toString());

    return data;
  }
  


}