import 'package:chords_catalog/models/chord.dart';
import 'package:chords_catalog/models/midi_sequence.dart';
import 'package:chords_catalog/models/note.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

class LogScale {
  String root;
  List<String> notes;
  BaseScale base;

  LogScale({required this.root, required this.notes, required this.base});

  
  static Future<List<List<dynamic>>> loadLib () async {
    
    final rawData = await rootBundle.loadString("assets/scales.csv");
    final List<List<dynamic>> data = CsvToListConverter().convert(rawData);

    return data;
  }

  List<Triad> getTriads () {

    List<Triad> triads = [];

    for (int i = 0 ; i<notes.length ; i++) {
      final root = notes[i];
      final allNotes = MidiNote.sharpNoteLabelsFromKey(root);

      // check major
      String third = allNotes[4];
      String fifth = allNotes[7];
      if (notes.contains(third) && notes.contains(fifth)){
        final chord = Chord(root: root, type: 'maj', structure: '1,3,5', noteLabels: [root, third, fifth]);
        triads.add(Triad(chord: chord, romanNumber: Triad.getNumberLabel(i+1)));
        continue;
      }

      // check minor
      third = allNotes[3];
      fifth = allNotes[7];
      if (notes.contains(third) && notes.contains(fifth)){
        final chord = Chord(root: root, type: 'm', structure: '1,b3,5', noteLabels: [root, third, fifth]);
        triads.add(Triad(chord: chord, romanNumber: Triad.getNumberLabel(i+1).toLowerCase()));
        continue;
      }
      

      // check diminished
      third = allNotes[3];
      fifth = allNotes[6];
      if (notes.contains(third) && notes.contains(fifth)){
        final chord = Chord(root: root, type: 'dim', structure: '1,b3,b5', noteLabels: [root, third, fifth]);
        triads.add(Triad(chord: chord, romanNumber: Triad.getNumberLabel(i+1).toLowerCase() + "°"));
        continue;
      }

      // check augmented
      third = allNotes[4];
      fifth = allNotes[8];
      if (notes.contains(third) && notes.contains(fifth)){
        final chord = Chord(root: root, type: 'aug', structure: '1,3,#5', noteLabels: [root, third, fifth]);
        triads.add(Triad(chord: chord, romanNumber: Triad.getNumberLabel(i+1).toLowerCase() + "+"));
        continue;
      }

      // check sus2
      third = allNotes[2];
      fifth = allNotes[5];
      if (notes.contains(third) && notes.contains(fifth)){
        final chord = Chord(root: root, type: 'sus2', structure: '1,2,5', noteLabels: [root, third, fifth]);
        triads.add(Triad(chord: chord, romanNumber: Triad.getNumberLabel(i+1).toLowerCase() + "sus2"));
        continue;
      }

      // check sus4
      third = allNotes[5];
      fifth = allNotes[2];
      if (notes.contains(third) && notes.contains(fifth)){
        final chord = Chord(root: root, type: 'sus4', structure: '1,4,5', noteLabels: [root, third, fifth]);
        triads.add(Triad(chord: chord, romanNumber: Triad.getNumberLabel(i+1).toLowerCase() + "sus4"));
        continue;
      }

    }
    return triads;
  }

  MidiSequence getDemoSequence () {
    List<SequenceNote> notes = [];
    for (int i = 0 ; i<this.notes.length ; i++) {
      final note = MidiNote.byLabel(label: this.notes[i]+"3");
      notes.add(SequenceNote(notes: [note], weight: NoteWeight.quarter));
    }
    return MidiSequence(tempo: 60, notes: notes);
  }
}

class Triad extends Chord {
  final String romanNumber;
  Triad({required Chord chord, required this.romanNumber}) : super(root: chord.root, type: chord.type, structure: chord.structure, noteLabels: chord.noteLabels);
  
  static String getNumberLabel (int number) {
    switch (number) {
      case 1:
        return "I";
      case 2:
        return "II";
      case 3:
        return "III";
      case 4:
        return "IV";
      case 5:
        return "V";
      case 6:
        return "VI";
      case 7:
        return "VII";
      default:
        return "";
    }
  }
}

class BaseScale {
  final String name;
  final List<int> intervals;
  final bool isCustomScale;

  BaseScale({required this.name, required this.intervals, this.isCustomScale = false});

  List<String> getNotes(String rootKey) {
    final allNotes = MidiNote.sharpNoteLabelsFromKey(rootKey);

    final List<String> res = [];

    final List<int> tmpIntervals = [];
    tmpIntervals.addAll(intervals);
    tmpIntervals.removeLast();

    res.add(rootKey);

    int index = 0;
    for (int interval in tmpIntervals) {
      index += interval;
      res.add(allNotes[index]);
    }

    return res;
  }

  LogScale createLogScale(String rootKey) {
    return LogScale(root: rootKey, notes: getNotes(rootKey), base: this);
  }
}