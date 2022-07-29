import 'package:chords_catalog/models/chord.dart';
import 'package:chords_catalog/models/instrument.dart';
import 'package:chords_catalog/models/log_scale.dart';
import 'package:flutter/cupertino.dart';

class LogProvider extends ChangeNotifier {
  String name;
  Tuning? tuning;
  InstrumentSound? sound;

  LogScale? scale;

  List<GuitarChord> chords;


  LogProvider({required this.name, required this.tuning, required this.sound, required this.scale, required this.chords});

  void setLog(String name, Tuning tuning, InstrumentSound sound) {
    this.name = name;
    this.tuning = tuning;
    this.sound = sound;
  }

  void setLogScale(LogScale scale) {
    this.scale = scale;
  }

  void addChord(GuitarChord chord) {
    chords.add(chord);
  }


}