import 'package:chords_catalog/models/chord.dart';
import 'package:chords_catalog/models/midi_sequence.dart';

class Progression {
  final MidiSequence sequence;
  final String name;
  final List<ProgressionContentElement> contentElements;

  Progression({required this.sequence, required this.name, required this.contentElements});
}

class ProgressionContentElement {
  final GuitarChord? chord;
  final NoteWeight weight;
  final ChordPLayMode playMode;
  final MidiSequence sequence;

  ProgressionContentElement({required this.chord, required this.weight, required this.playMode, required this.sequence});
  
}