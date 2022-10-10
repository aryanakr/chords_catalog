import 'package:chords_catalog/models/chord.dart';
import 'package:chords_catalog/models/midi_sequence.dart';

class Progression {
  final MidiSequence sequence;
  final String name;

  Progression({required this.sequence, required this.name});
}

class ProgressionUIContentElement {
  final GuitarChord? chord;
  final NoteWeight weight;
  final ChordPLayMode playMode;

  ProgressionUIContentElement({required this.chord, required this.weight, required this.playMode});
  
}