import 'package:chords_catalog/models/chord.dart';
import 'package:chords_catalog/models/instrument.dart';
import 'package:chords_catalog/models/log.dart';
import 'package:chords_catalog/models/log_scale.dart';
import 'package:chords_catalog/models/midi_sequence.dart';
import 'package:chords_catalog/models/progression.dart';
import 'package:flutter/cupertino.dart';

import '../helpers/db_helper.dart';

class LogProvider extends ChangeNotifier {
  String name;
  Tuning? tuning;
  InstrumentSound? sound;

  LogScale? scale;

  List<GuitarChord> chords;
  List<Progression> progressions;

  int? id;

  LogProvider({required this.name, required this.tuning, required this.sound, required this.scale, required this.chords, required this.progressions});

  Future<void> loadLog(Log log) async {
    
    final dbInstance = DBHelper.instance;

    id = log.id;
    name = log.name;
    
    // load sound
    sound = InstrumentSound.getSoundFromName(log.soundName);

    // load tuning
    tuning = await dbInstance.getTuningById(log.tuningId);

    // load scale
    scale = await dbInstance.getScaleById(log.scaleId).then((value) => scale = value);

    // load chords
    chords = await dbInstance.queryAllChords(log.id);

    // load progressions
    final baseProgressions = await dbInstance.queryAllProgressions(log.id);
    
    for (var dbProgression in baseProgressions) {
      final progressionId = dbProgression.id;

      final progressionChords = await dbInstance.queryAllProgressionChords(progressionId);
      final progressionRests = await dbInstance.queryAllProgressionRests(progressionId);

      final progression = Progression.createFromDBObjects(dbProgression, chords, progressionChords, progressionRests);
      progressions.add(progression);
    }

    notifyListeners();
  }

  
  Future<void> setLog(String name, Tuning tuning, InstrumentSound sound, LogScale scale) async {
    
    final dbInstance = DBHelper.instance;

    // save scale to database
    int scaleId;

    if (scale.id == -1 ) {
      scaleId = await dbInstance.insertScale(scale);
      scale.id = scaleId;
    } else {
      scaleId = scale.id;
    }

    // save tuning
    int tuningId;

    if (tuning.id == -1) {
      tuningId = await dbInstance.insertTuning(tuning);
      tuning.id = tuningId;
    } else {
      tuningId = tuning.id;
    }

    // save log to database
    final log = Log(name: name, tuningId: tuningId, soundName: sound.name, scaleId: scaleId);
    id = await dbInstance.insertLog(log);

    this.name = name;
    this.tuning = tuning;
    this.sound = sound;
    this.scale = scale;
  }

  Future<void> saveChord({required GuitarChord chord, int index = -1}) async {
    final dbInstance = DBHelper.instance;

    if (index == -1) {
      final chordId = await dbInstance.insertChord(chord, id!);
      
      chord.id = chordId;
      chords.add(chord);
    } else {
      dbInstance.updateChord(chord, id!);
      chords[index] = chord;
    }
  }

  Future<void> saveProgression({required Progression progression, int index = -1}) async {
    final dbInstance = DBHelper.instance;

    if (index == -1) {
      final progressionId = await _saveProgressionInDB(progression, dbInstance);
      
      progression.id = progressionId;
      progressions.add(progression);
    } else {

      // delete current progression from database
      await dbInstance.deleteProgressionRests(progression.id);
      await dbInstance.deleteProgressionChords(progression.id);
      await dbInstance.deleteProgression(progression.id);

      // save new progression to database
      final progressionId = await _saveProgressionInDB(progression, dbInstance);
      
      progression.id = progressionId;
      progressions[index] = progression;

    }

  }

  Future<int> _saveProgressionInDB (Progression progression, DBHelper dbInstance) async{
    final dbProgression = progression.getDBProgression(id!);
    final progressionId = await dbInstance.insertProgression(dbProgression);

    final pChords = progression.getDBProgressionChords(progressionId);
    final pRests = progression.getDBProgressionRests(progressionId);

    for (var i in pChords) {
      await dbInstance.insertProgressionChord(i);
    }

    for (var i in pRests) {
      await dbInstance.insertProgressionRest(i);
    }

    return progressionId;
  }


}