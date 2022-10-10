import 'package:chords_catalog/models/note.dart';


class MidiSequence {
  final int tempo;
  final List<SequenceNote> notes;
  final bool loop;

  MidiSequence({required this.tempo, required this.notes, this.loop = false});

  int get baseDuration => (60000 / tempo / 8).round();

  static MidiSequence getMerged(List<MidiSequence> sequences, int tempo) {
    List<SequenceNote> mnotes = [];
    for (int i = 0; i < sequences.length; i++) {
      mnotes.addAll(sequences[i].notes);
    }
    return MidiSequence(tempo: tempo, notes: mnotes);
  }
}

class SequenceNote{
  final List<MidiNote> notes; // empty for rest
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