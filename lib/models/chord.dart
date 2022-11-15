

import 'package:chords_catalog/models/midi_sequence.dart';
import 'package:chords_catalog/models/note.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Chord {

  final String root;
  final String type;
  final String structure;
  List<String> noteLabels;

  Chord({required this.root, required this.type, required this.structure, required this.noteLabels});

  static Future<List<List<dynamic>>> loadLib () async {
    
    final rawData = await rootBundle.loadString("assets/chords.csv");
    final List<List<dynamic>> data = CsvToListConverter().convert(rawData);

    return data;
  }

  static Chord createChordFromLibRow(List<dynamic> row) {
    final root = row[0].toString();
    final type = row[1].toString();
    final structure = row[2].toString();
    final noteLabels = row[3].toString().split(',');

    return Chord(root: root, type: type, structure: structure, noteLabels: noteLabels);
  }
  
}

class GuitarChord {

  int id = -1;
  final Chord chord;
  final List<int?> cardDotsPos;
  final String name;
  final int startFret;
  final List<MidiNote?> midiNotes;
  final Color cardColor;


  Map<String, dynamic> toMap(int logId) {
    return {
      'name': name,
      'root': chord.root,
      'type': chord.type,
      'structure': chord.structure,
      'note_labels': chord.noteLabels.join(','),
      'dots_pos': cardDotsPos.join(','),
      'start_fret': startFret,
      'notes': midiNotes.map((e) => e?.midiNumber).join(','),
      'color': cardColor.value,
      'log_id': logId,
    };
  }

  static GuitarChord fromMap(Map<String, dynamic> map) {
    print('dots pos: ${map['dots_pos']}');
    return GuitarChord(
      id: map['id'],
      chord: Chord(
        root: map['root'],
        type: map['type'],
        structure: map['structure'],
        noteLabels: map['note_labels'].toString().split(','),
      ),
      cardDotsPos: map['dots_pos'].toString().split(',').map((e) => e == 'null' ? null : int.parse(e)).toList(),
      name: map['name'],
      startFret: map['start_fret'],
      midiNotes: map['notes'].toString().split(',').map((e) => e == 'null' ? null : MidiNote.byMidiNumber(midiNumber: int.parse(e))).toList(),
      cardColor: Color(int.parse(map['color'])),
    );
  }

  List<int?> drawCardDotsPos() {

    return cardDotsPos.map((e) => e == null || e == 0 ? e : e - startFret + 1).toList();
  }

  static List<int?> toDrawCardDotsPos(List<int?> notes, int startFret) {
    return notes.map((e) => e == null || e == 0 ? e : e - startFret + 1).toList();
  }

  GuitarChord({this.id = -1, required this.chord, required this.name, required this.cardDotsPos, required this.startFret, required this.midiNotes, required this.cardColor});

  List<SequenceNote> getDownStrockSequenceNotes(NoteWeight weight) {
    List<SequenceNote> notes = [];
    for (int i = 0 ; i<midiNotes.length ; i++) {
      if (midiNotes[i] != null) {
        final sequenceNote = SequenceNote(
          notes: [midiNotes[i]!],
          weight: weight
        );
        notes.add(sequenceNote);
      }      
    }
    return notes;
  }

  MidiSequence getDownStrockSequence(NoteWeight weight, int tempo) {
    List<SequenceNote> notes = getDownStrockSequenceNotes(weight);
    return MidiSequence(notes: notes, tempo: tempo);
  }

  List<SequenceNote> getUpStrockSequenceNotes(NoteWeight weight) {
    List<SequenceNote> notes = [];
    for (int i = midiNotes.length-1 ; i>=0 ; i--) {
      if (midiNotes[i] != null) {
        final sequenceNote = SequenceNote(
          notes: [midiNotes[i]!],
          weight: weight
        );
        notes.add(sequenceNote);
      }      
    }
    return notes;
  }

  List<SequenceNote> getSequenceNotesByMode(NoteWeight weight, ChordPLayMode mode) {
    switch(mode) {
      case ChordPLayMode.downArpeggio:
        return getDownStrockSequenceNotes(weight);
      case ChordPLayMode.upArpeggio:
        return getUpStrockSequenceNotes(weight);
      case ChordPLayMode.strum:
        return [getStrumSequenceNote(weight)];
    }
  }

  MidiSequence getUpStrockSequence(NoteWeight weight, int tempo) {
    List<SequenceNote> notes = getUpStrockSequenceNotes(weight);
    return MidiSequence(notes: notes, tempo: tempo);
  }

  SequenceNote getStrumSequenceNote(NoteWeight weight) {
    List<MidiNote> notes = [];
    for (int i = 0 ; i < midiNotes.length; i++) {
      if (midiNotes[i] != null) {
        notes.add(midiNotes[i]!);
      }      
    }
    return SequenceNote(notes: notes, weight: weight);
  }

  MidiSequence getDemoSequence() {
    final downStrock = getDownStrockSequence(NoteWeight.eighth, 120);
    final upStrock = getUpStrockSequence(NoteWeight.eighth, 120);
    final strumNotes = getStrumSequenceNote(NoteWeight.half);
    final strum = MidiSequence(notes: [strumNotes], tempo: 120);
    final restNotes = SequenceNote(notes: [], weight: NoteWeight.quarter);
    final rest = MidiSequence(notes: [restNotes], tempo: 120);

    final sequence =  MidiSequence.getMerged([downStrock,rest, strum, rest, upStrock], 120);
    return sequence;
  }

}

enum ChordPLayMode{
  downArpeggio,
  strum,
  upArpeggio
}