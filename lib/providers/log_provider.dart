import 'package:chords_catalog/models/instrument.dart';
import 'package:chords_catalog/models/log_scale.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/services.dart';

class LogProvider extends ChangeNotifier {
  String name;
  Tuning? tuning;
  InstrumentSound? sound;

  LogScale? scale;


  LogProvider({required this.name, required this.tuning, required this.sound, required this.scale});

  void setLog(String name, Tuning tuning, InstrumentSound sound) {
    this.name = name;
    this.tuning = tuning;
    this.sound = sound;
  }

  void setLogScale(LogScale scale) {
    this.scale = scale;
  }


}