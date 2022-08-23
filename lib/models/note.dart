
class MidiNote {

  late String label;
  late int midiNumber;

  String getNoteLabel() {
    return label.replaceAll(RegExp('[-0-9]'),'');
  }

  int getNoteOctave() {
    return int.parse(label.replaceAll(RegExp('[^-0-9]'), ''));
  }

  MidiNote.byMidiNumber({required this.midiNumber}) {

    String noteLabel = sharpNoteLabels[midiNumber % 12];

    int octave = (midiNumber/12).floor() - 2;

    label = noteLabel + octave.toString();
  }

  MidiNote.byLabel({required this.label}) {
    int octave = int.parse(label.replaceAll(RegExp('[^-0-9]'), ''));
    String noteLabel = label.replaceAll(RegExp('[-0-9]'),'');

    midiNumber = (octave + 2) * 12 + sharpNoteLabels.indexOf(noteLabel);
  }

  static List<String> sharpNoteLabels = [
    'C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'
  ];

  static List<String> sharpNoteLabelsFromKey(String note) {
    final List<String> res = [];

    final keyIndex = sharpNoteLabels.indexOf(note);

    for (int i = keyIndex; i<sharpNoteLabels.length ; i++) {
      res.add(sharpNoteLabels[i]);
    }

    for (int i = keyIndex-1 ; i >= 0 ; i--) {
      res.add(sharpNoteLabels[i]);
    }

    return res;
  }

  static List<String> allNoteLabels() {
    List<String> res = [];
    for (int i = -2 ; i <=8 ; i++ ) {
      for (String l in sharpNoteLabels) {

        if (res.length > 127) {
          break;
        }

        res.add(l + i.toString());
      }
    }
    return res;
  }

  static List<MidiNote> allMidiNotes() {
    List<MidiNote> res = [];

    for (String l in allNoteLabels()) {
      res.add(MidiNote.byLabel(label: l));
    }

    return res;
  }

}
