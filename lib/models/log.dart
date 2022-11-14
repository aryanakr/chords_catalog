import 'package:chords_catalog/helpers/db_helper.dart';

class Log {
  final int id;
  final String name;
  final String soundName;
  final int tuningId;
  final int scaleId;

  Log({this.id = 0, required this.name, required this.soundName, required this.tuningId, required this.scaleId});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'sound_name': soundName,
      'tuning_id': tuningId,
      'scale_id': scaleId,
    };
  }

  static Log fromMap(Map<String, dynamic> map) {
    return Log(
      id: map['id'],
      name: map['name'],
      soundName: map['sound_name'],
      tuningId: map['tuning_id'],
      scaleId: map['scale_id'],
    );
  }

  static Future<List<Log>> retrieveSavedLogs() async {
    final dbHelper = DBHelper.instance;

    return await dbHelper.queryAllLogs();
  }

  @override
  String toString() {
    return 'Log{name: $name, soundName: $soundName, tuningId: $tuningId, scaleId: $scaleId}';
  }

  // TODO: use SELECT last_insert_rowid() to get the id of the last inserted row
  
}