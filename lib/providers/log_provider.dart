import 'package:chords_catalog/models/chord.dart';
import 'package:chords_catalog/models/instrument.dart';
import 'package:chords_catalog/models/log_scale.dart';
import 'package:chords_catalog/models/midi_sequence.dart';
import 'package:chords_catalog/models/progression.dart';
import 'package:flutter/cupertino.dart';

class LogProvider extends ChangeNotifier {
  String name;
  Tuning? tuning;
  InstrumentSound? sound;

  LogScale? scale;

  List<GuitarChord> chords;
  List<Progression> progressions;


  LogProvider({required this.name, required this.tuning, required this.sound, required this.scale, required this.chords, required this.progressions});

  void setLog(String name, Tuning tuning, InstrumentSound sound, LogScale scale) {
    this.name = name;
    this.tuning = tuning;
    this.sound = sound;
    this.scale = scale;
  }

  void setLogScale(LogScale scale) {
    this.scale = scale;
  }

  void saveChord({required GuitarChord chord, int index = -1}) {
    if (index == -1) {
      chords.add(chord);
    } else {
      chords[index] = chord;
    }
  }


}