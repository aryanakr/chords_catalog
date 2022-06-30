import 'package:chords_catalog/models/note.dart';

class LogScale {
  MidiNote root;
  List<MidiNote> notes;

  LogScale({required this.root, required this.notes});
}