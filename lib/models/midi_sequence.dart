import 'package:chords_catalog/models/note.dart';


class MidiSequence {
  final int tempo;
  final List<SequenceNote> notes;
  final bool loop;

  MidiSequence({required this.tempo, required this.notes, this.loop = false});

  int get baseDuration => (60000 / tempo / 8).round();
}

class SequenceNote{
  final List<MidiNote> notes; // null for rest
  final NoteWeight weight; // 1/32 notes (eg. 8 = Quarter note or 1 beat)

  SequenceNote({required this.notes, required this.weight});
  
}

enum NoteWeight {
  whole,
  half,
  quarter,
  eighth,
  sixteenth,
  thirtySecond,
} 

extension GetNoteWeightValue on NoteWeight {
  int get value {
    switch (this) {
      case NoteWeight.whole:
        return 32;
      case NoteWeight.half:
        return 16;
      case NoteWeight.quarter:
        return 8;
      case NoteWeight.eighth:
        return 4;
      case NoteWeight.sixteenth:
        return 2;
      case NoteWeight.thirtySecond:
        return 1;
    }
  }
}