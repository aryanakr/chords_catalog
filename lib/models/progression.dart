import 'package:chords_catalog/models/chord.dart';
import 'package:chords_catalog/models/midi_sequence.dart';

class Progression {
  int id;
  final MidiSequence sequence;
  final String name;
  final List<ProgressionContentElement> contentElements;

  Progression({this.id = -1, required this.sequence, required this.name, required this.contentElements});

  static Progression createFromDBObjects(DBProgression progression, List<GuitarChord> chords, List<DBProgressionChord> dbChords, List<DBProgressionRest> dbRests) {
    final contentElements = <ProgressionContentElement>[];

    List<SequenceNote> progressionSequenceNotes = [];

    int chordHead = 0;
    int restHead = 0;
    for (int i = 0; i < progression.length; i++) {
      if (i == dbChords[chordHead].position) {
        final dbChord = dbChords[chordHead];
        final chord = chords.firstWhere((element) => element.id == dbChords[chordHead].chordId);
        final playMode = ChordPLayMode.values.firstWhere((element) => element.toString() == dbChord.mode);
        final weight = NoteWeight.values.firstWhere((element) => element.value == dbChord.weight);

        final sequenceNotes = chord.getSequenceNotesByMode(weight, playMode);
        final sequence = MidiSequence(notes: sequenceNotes, tempo: progression.tempo);
        final element = ProgressionContentElement (chord: chord, playMode: playMode, sequence: sequence, weight: weight);

        progressionSequenceNotes.addAll(sequenceNotes);

        contentElements.add(element);
        chordHead++;
      } else if (i == dbRests[restHead].position) {
        final rest = dbRests[restHead];

        final weight = NoteWeight.values.firstWhere((element) => element.value == rest.weight);
        final sequence = MidiSequence(notes: [SequenceNote (notes: [], weight: weight)], tempo: progression.tempo);
        final element = ProgressionContentElement (chord: null, playMode: ChordPLayMode.strum, sequence: sequence, weight: weight);

        progressionSequenceNotes.add(SequenceNote (notes: [], weight: weight));

        contentElements.add(element);
        restHead++;
      } else {
        print('Error: Progression content element not found at position $i');
      }
    }

    final sequence = MidiSequence(notes: progressionSequenceNotes, tempo: progression.tempo);
    return Progression(id: progression.id, sequence: sequence, name: progression.name, contentElements: contentElements);

  }

  DBProgression getDBProgression(int logId) {
    return DBProgression(
      name: name,
      tempo: sequence.tempo,
      length: contentElements.length,
      logId: logId
    );
  }

  List<DBProgressionRest> getDBProgressionRests(int progressionId) {
    List<DBProgressionRest> rests = [];
    for (int i = 0 ; i<contentElements.length ; i++) {
      final element = contentElements[i];
      if (element.chord == null) {
        rests.add(DBProgressionRest(
          progressionId: progressionId,
          weight: element.weight.value,
          position: i
        ));
      }
    }
    return rests;
  }

  List<DBProgressionChord> getDBProgressionChords(int progressionId) {
    List<DBProgressionChord> chords = [];
    for (int i = 0 ; i<contentElements.length ; i++) {
      final element = contentElements[i];
      if (element.chord != null) {
        chords.add(DBProgressionChord(
          progressionId: progressionId,
          chordId: element.chord!.id,
          weight: element.weight.value,
          mode: element.playMode.toString(),
          position: i
        ));
      }
    }
    return chords;
  }
}

class ProgressionContentElement {
  final GuitarChord? chord;
  final NoteWeight weight;
  final ChordPLayMode playMode;
  final MidiSequence sequence;

  ProgressionContentElement({required this.chord, required this.weight, required this.playMode, required this.sequence});
  
}

class DBProgression {

  final int id;
  final String name;
  final int tempo;
  final int length;
  final int logId;

  DBProgression({this.id = -1, required this.name, required this.tempo, required this.length, required this.logId});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'tempo': tempo,
      'length': length,
      'log_id': logId,
    };
  }

  static DBProgression fromMap(Map<String, dynamic> map) {
    return DBProgression(
      id: map['id'],
      name: map['name'],
      tempo: map['tempo'],
      length: map['length'],
      logId: map['log_id'],
    );
  }
}

class DBProgressionRest {
  final int progressionId;
  final int weight;
  final int position;

  DBProgressionRest({required this.progressionId, required this.weight, required this.position});

  Map<String, dynamic> toMap() {
    return {
      'progression_id': progressionId,
      'weight': weight,
      'position': position,
    };
  }

  static DBProgressionRest fromMap(Map<String, dynamic> map) {
    return DBProgressionRest(
      progressionId: map['progression_id'],
      weight: map['weight'],
      position: map['position'],
    );
  }
}

class DBProgressionChord {
  final int chordId;
  final int progressionId;
  final int weight;
  final String mode;
  final int position;

  DBProgressionChord({required this.chordId, required this.progressionId, required this.weight, required this.mode, required this.position});

  Map<String, dynamic> toMap() {
    return {
      'chord_id': chordId,
      'progression_id': progressionId,
      'weight': weight,
      'mode': mode,
      'position': position,
    };
  }

  static DBProgressionChord fromMap(Map<String, dynamic> map) {
    return DBProgressionChord(
      chordId: map['chord_id'],
      progressionId: map['progression_id'],
      weight: map['weight'],
      mode: map['mode'],
      position: map['position'],
    );
  }
}