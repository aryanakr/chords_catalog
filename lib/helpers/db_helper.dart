import 'dart:convert';
import 'dart:io';
import 'package:chords_catalog/models/log.dart';
import 'package:chords_catalog/models/progression.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/chord.dart';
import '../models/instrument.dart';
import '../models/log_scale.dart';

class DBHelper{

  static final _databaseName = "ChordsLogDatabase.db";
  static final _databaseVersion = 1;

  DBHelper._privateConstructor();

  static final DBHelper instance = DBHelper._privateConstructor();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null){ 
      return _database;
    }
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    // Log table
    await db.execute('''  
        CREATE TABLE log (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          name TEXT NOT NULL,
          sound_name TEXT NOT NULL,
          tuning_id INTEGER NOT NULL,
          scale_id INTEGER NOT NULL,
          FOREIGN KEY (tuning_id) REFERENCES tuning(id)
          ON DELETE NO ACTION ON UPDATE NO ACTION,
          FOREIGN KEY (scale_id) REFERENCES scale(id)
          ON DELETE NO ACTION ON UPDATE NO ACTION
        )''');
    // Scale table
    await db.execute('''  
        CREATE TABLE base_scale (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          name TEXT NOT NULL,
          intervals TEXT NOT NULL,
          is_custom BOOLEAN NOT NULL
        )''');

    await db.execute('''  
        CREATE TABLE scale (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          root TEXT NOT NULL,
          notes TEXT NOT NULL,
          base_scale_id INTEGER NOT NULL,
          FOREIGN KEY (base_scale_id) REFERENCES base_scale(id)
          ON DELETE NO ACTION ON UPDATE NO ACTION
        )''');
    // Tuning table
    await db.execute('''  
        CREATE TABLE tuning (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          name TEXT NOT NULL,
          num_strings INTEGER NOT NULL,
          open_notes TEXT NOT NULL,
          is_custom BOOLEAN NOT NULL
        )''');
    // Chord table
    await db.execute('''  
        CREATE TABLE chord (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          root TEXT NOT NULL,
          type TEXT NOT NULL,
          structure TEXT NOT NULL,
          note_labels TEXT NOT NULL,
          dots_pos TEXT NOT NULL,
          name TEXT NOT NULL,
          start_fret INTEGER NOT NULL,
          notes TEXT NOT NULL,
          color TEXT NOT NULL,
          log_id INTEGER NOT NULL,
          FOREIGN KEY (log_id) REFERENCES log(id)
          ON DELETE NO ACTION ON UPDATE NO ACTION
        )''');

    // Progression table
    await db.execute('''  
        CREATE TABLE progression (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          name TEXT NOT NULL,
          length INTEGER NOT NULL,
          tempo INTEGER NOT NULL,
          log_id INTEGER NOT NULL,
          FOREIGN KEY (log_id) REFERENCES log(id)
          ON DELETE NO ACTION ON UPDATE NO ACTION
        )''');

    // Progression Chord table
    await db.execute('''  
        CREATE TABLE progression_chord (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          chord_id INTEGER NOT NULL,
          progression_id INTEGER NOT NULL,
          weight INTEGER NOT NULL,
          mode TEXT NOT NULL,
          position INTEGER NOT NULL,
          FOREIGN KEY (chord_id) REFERENCES chord(id)
          ON DELETE NO ACTION ON UPDATE NO ACTION,
          FOREIGN KEY (progression_id) REFERENCES progression(id)
          ON DELETE NO ACTION ON UPDATE NO ACTION
        )''');

    // Progression Rest table
    await db.execute('''  
        CREATE TABLE progression_rest (
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          progression_id INTEGER NOT NULL,
          weight INTEGER NOT NULL,
          position INTEGER NOT NULL,
          FOREIGN KEY (progression_id) REFERENCES progression(id)
          ON DELETE NO ACTION ON UPDATE NO ACTION
        )''');
  }

  // Log Dao
  Future<int> insertLog(Log log) async {
    Database? db = await instance.database;

    if (db != null) {
      return await db.insert('log', log.toMap());
    } else {
      return -1;
    }
  }

  Future<List<Log>> queryAllLogs() async {
    Database? db = await instance.database;
    List<Map<String, dynamic>> maps = [];

    if (db != null) {
      maps = await db.query('log');
    }

    return List.generate(maps.length, (i) {
      return Log.fromMap(maps[i]);
    });
  }

  // Base Scale Dao
  Future<int> insertBaseScale(BaseScale baseScale) async {
    Database? db = await instance.database;

    if (db != null) {
      return await db.insert('base_scale', baseScale.toMap());
    } else {
      return -1;
    }
  }

  Future<List<BaseScale>> queryAllBaseScales() async {
    Database? db = await instance.database;
    List<Map<String, dynamic>> maps = [];

    if (db != null) {
      maps = await db.query('base_scale');
    }

    return List.generate(maps.length, (i) {
      return BaseScale.fromMap(maps[i]);
    });
  }

  Future<BaseScale> getBaseScaleById(int id) async {
    Database? db = await instance.database;
    List<Map<String, dynamic>> maps = [];

    if (db != null) {
      maps = await db.query('base_scale', where: 'id = ?', whereArgs: [id]);
    }

    return BaseScale.fromMap(maps[0]);
  }

  // Scale Dao
  Future<int> insertScale(LogScale scale) async {
    Database? db = await instance.database;

    if (db != null) {
      return await db.insert('scale', scale.toMap());
    } else {
      return -1;
    }
  }

  Future<LogScale?> getScaleById(int id) async{
    Database? db = await instance.database;

    if (db != null) {
      // get base scale
      

      final maps = await db.query('scale', where: 'id = ?', whereArgs: [id]);
      if (maps.isNotEmpty) {
        
        // get base scale
        final baseMaps = await db.query('base_scale', where: 'id = ?', whereArgs: [maps[0]['base_scale_id']]);

        if (baseMaps.isNotEmpty) {
          return LogScale.fromMap(maps[0], BaseScale.fromMap(baseMaps[0]));
        }
      }
    }

    return null;
    
  }

  // Tuning Dao
  Future<int> insertTuning(Tuning tuning) async {
    Database? db = await instance.database;

    if (db != null) {
      return await db.insert('tuning', tuning.toMap());
    } else {
      return -1;
    }
  }

  Future<List<Tuning>> queryAllTunings() async {
    Database? db = await instance.database;
    List<Map<String, dynamic>> maps = [];

    if (db != null) {
      maps = await db.query('tuning');
    }

    return maps.map((e) => Tuning.fromMap(e)).toList();
  }

  Future<Tuning?> getTuningById(int id) async {
    Database? db = await instance.database;

    if (db != null) {
      final maps = await db.query('tuning', where: 'id = ?', whereArgs: [id]);
      if (maps.isNotEmpty) {
        return Tuning.fromMap(maps[0]);
      }
    }

    return null;
  }

  // Chord Dao
  Future<int> insertChord(GuitarChord chord, int logId) async {
    Database? db = await instance.database;

    if (db != null) {
      return await db.insert('chord', chord.toMap(logId));
    } else {
      return -1;
    }
  }

  Future<void> updateChord(GuitarChord chord, int logId) async {
    Database? db = await instance.database;

    if (db != null && chord.id != -1) {
      await db.update('chord', chord.toMap(logId),
          where: 'id = ?', whereArgs: [chord.id]);
    }
  }

  Future<void> deleteChord(GuitarChord chord) async {
    Database? db = await instance.database;

    if (db != null && chord.id != -1) {
      await db.delete('chord', where: 'id = ?', whereArgs: [chord.id]);
    }
  }

  Future<List<GuitarChord>> queryAllChords(int logId) async {
    Database? db = await instance.database;
    List<Map<String, dynamic>> maps = [];

    if (db != null) {
      maps = await db.query('chord', where: 'log_id = ?', whereArgs: [logId]);
    }

    return List.generate(maps.length, (i) {
      return GuitarChord.fromMap(maps[i]);
    });
  }

  // Progression Dao
  Future<int> insertProgression(DBProgression progression) async {
    Database? db = await instance.database;

    if (db != null) {
      return await db.insert('progression', progression.toMap());
    } else {
      return -1;
    }
  }

  Future<void> updateProgression(DBProgression progression) async {
    Database? db = await instance.database;

    if (db != null && progression.id != -1) {
      await db.update('progression', progression.toMap(),
          where: 'id = ?', whereArgs: [progression.id]);
    }
  }

  Future<void> deleteProgression(int id) async {
    Database? db = await instance.database;

    if (db != null && id != -1) {
      await db.delete('progression', where: 'id = ?', whereArgs: [id]);
    }
  }

  Future<List<DBProgression>> queryAllProgressions(int logId) async {
    Database? db = await instance.database;
    List<Map<String, dynamic>> maps = [];

    if (db != null) {
      maps = await db.query('progression', where: 'log_id = ?', whereArgs: [logId]);
    }

    return List.generate(maps.length, (i) {
      return DBProgression.fromMap(maps[i]);
    });
  }

  // progression chord Dao
  Future<int> insertProgressionChord(DBProgressionChord progChord) async {
    Database? db = await instance.database;

    if (db != null) {
      return await db.insert('progression_chord', progChord.toMap());
    } else {
      return -1;
    }
  }

  Future<void> deleteProgressionChords(int progressionId) async {
    Database? db = await instance.database;

    if (db != null) {
      await db.delete('progression_chord', where: 'progression_id = ?', whereArgs: [progressionId]);
    }
  }

  Future<List<DBProgressionChord>> queryAllProgressionChords(int progressionId) async {
    Database? db = await instance.database;
    List<Map<String, dynamic>> maps = [];

    if (db != null) {
      maps = await db.query('progression_chord', where: 'progression_id = ?', whereArgs: [progressionId], orderBy: 'position ASC');
    }

    return List.generate(maps.length, (i) {
      return DBProgressionChord.fromMap(maps[i]);
    });
  }

  // progression rest dao
  Future<int> insertProgressionRest(DBProgressionRest progRest) async {
    Database? db = await instance.database;

    if (db != null) {
      return await db.insert('progression_rest', progRest.toMap());
    } else {
      return -1;
    }
  }

  Future<void> deleteProgressionRests(int progressionId) async {
    Database? db = await instance.database;

    if (db != null) {
      await db.delete('progression_rest', where: 'progression_id = ?', whereArgs: [progressionId]);
    }
  }

  Future<List<DBProgressionRest>> queryAllProgressionRests(int progressionId) async {
    Database? db = await instance.database;
    List<Map<String, dynamic>> maps = [];

    if (db != null) {
      maps = await db.query('progression_rest', where: 'progression_id = ?', whereArgs: [progressionId], orderBy: 'position ASC');
    }

    return List.generate(maps.length, (i) {
      return DBProgressionRest.fromMap(maps[i]);
    });
  }



}