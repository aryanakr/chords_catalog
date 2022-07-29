import 'package:chords_catalog/models/note.dart';

class Instrument {

  

}

class InstrumentSound {
  String path;
  String name;

  InstrumentSound({required this.path, required this.name});

  static List<InstrumentSound> DefaultSounds = [
    InstrumentSound(path: 'assets/Electric-Guitars.sf2', name: 'Electric Guitar'),
    InstrumentSound(path: 'assets/Perfect_Sine.sf2', name: 'Perfect Sine'),
    InstrumentSound(path: 'assets/Piano.sf2', name: 'Piano')
  ];
}

class Tuning {
  late String name;
  late List<MidiNote> openNotes;
  late bool isCustomTuning;
  late int numStrings;

  Tuning({required this.name, required this.openNotes, required this.numStrings, this.isCustomTuning = false});

  Tuning.standardTuning() {
    openNotes = [
      MidiNote.byLabel(label: 'E2'),
      MidiNote.byLabel(label: 'A2'),
      MidiNote.byLabel(label: 'D3'),
      MidiNote.byLabel(label: 'G3'),
      MidiNote.byLabel(label: 'B3'),
      MidiNote.byLabel(label: 'E4'),
    ];
    name = 'Standard';
    numStrings = 6;

  }

  static List<Tuning> retrieveKnownTuningForStrings(int numStrings) {
    Tuning custom = Tuning(name: 'Custom', openNotes: [], numStrings: numStrings, isCustomTuning: true);
    if (numStrings == 6) {
      return [Tuning.standardTuning(), custom];
    }

    return [custom];
  }

}

