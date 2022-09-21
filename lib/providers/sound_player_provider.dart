import 'dart:async';
import 'dart:math';

import 'package:chords_catalog/models/instrument.dart';
import 'package:chords_catalog/models/midi_sequence.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';

class SoundPlayerProvider extends ChangeNotifier {
  final _flutterMidi = FlutterMidi();

  StreamSubscription? _subscription;

  bool get isPlaying => _subscription != null && !_subscription!.isPaused;

  int _playSequenceIndex = 0;
  int _playRemainingWeight = 0;

  SoundPlayerProvider() {
    final defaultInstrument = InstrumentSound.DefaultSounds[0];
    rootBundle.load(defaultInstrument.path).then((sf2) {
      _flutterMidi.prepare(sf2: sf2, name: defaultInstrument.name);
    });
  }

  void setSound(InstrumentSound sound) {
    rootBundle.load(sound.path).then((sf2) {
      _flutterMidi.prepare(sf2: sf2, name: sound.name);
    });
  }

  void startSequence(MidiSequence sequence) {
    _subscription?.cancel();

    if (sequence.notes.isEmpty) {
      return;
    }

    _playSequenceIndex = 0;
    _playRemainingWeight = sequence.notes[0].weight.value;

    _subscription = Stream.periodic(
      Duration(milliseconds: sequence.baseDuration),
    ).listen((value) => _playSequence(sequence));
  }

  void _playSequence(MidiSequence sequence) {

    //print current remaining weight
    print(_playRemainingWeight);
    

    if (_playRemainingWeight == sequence.notes[_playSequenceIndex].weight.value && sequence.notes[_playSequenceIndex].notes.isNotEmpty) {
      for (var note in sequence.notes[_playSequenceIndex].notes) {
        _flutterMidi.playMidiNote(midi: note.midiNumber);
      }
    }

    _playRemainingWeight -= 1;
    
    if (_playRemainingWeight <= 0) {
      _playSequenceIndex += 1;
      if (_playSequenceIndex >= sequence.notes.length) {
        if (sequence.loop) {
          _playSequenceIndex = 0;
        } else {
          pause();
          return;
        }
      }
      _playRemainingWeight = sequence.notes[_playSequenceIndex].weight.value;
    }

    notifyListeners();
  }

  void pause() {
    _subscription?.pause();
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

/*

class BarPlayerState extends ChangeNotifier {

  var _currentSelectedWeight = NoteWeigth.half;
  var _playIndex = 0;
  var _playRestCounter = 0;

  var _selectedIndex = 0;

  BarPlayerState({this.tempo = 125, this.signature = 4}) {
    rootBundle.load("assets/Electric-Guitars.sf2").then((sf2) {
      _flutterMidi.prepare(sf2: sf2, name: "Electric-Guitars.sf2");
    });
     addNote();
  }

  List<TabNote> get barContent => _barContent;
  bool get isPlaying => _subscription != null && !_subscription!.isPaused;

  int get currentActiveIndex => _selectedIndex;

  NoteWeigth get currentNoteWeight => _currentSelectedWeight;

  void setIndexWeight(NoteWeigth newWeight) {
    _currentSelectedWeight = newWeight;
    _barContent[_selectedIndex].weight = newWeight;
  }
  void nextIndex(){
    _selectedIndex += 1;
    if (_selectedIndex >= _barContent.length) {
      addNote();
    } else {
      _currentSelectedWeight = _barContent[_selectedIndex].weight;
    }
    notifyListeners();
  }

  void previousIndex(){
    if (_selectedIndex > 0) {
      _selectedIndex --;
      _currentSelectedWeight = _barContent[_selectedIndex].weight;
      notifyListeners();
    }
  }
  
  void addNote() {
    var newNote = TabNote(notes: [], weight: _currentSelectedWeight);
    _barContent.add(newNote);
    notifyListeners();
  }

  void toggleKeyinNote(Note note){
    print("---------------------selected index $_selectedIndex");
    if (_barContent[_selectedIndex].notes.map((e) => (e.fret == note.fret && e.string==note.string)).toList().contains(true)){
      _barContent[_selectedIndex].notes.removeWhere((e) => (e.fret == note.fret && e.string==note.string));
    } else {
      _barContent[_selectedIndex].addNote(note);
    }
    notifyListeners();
  }

  void reset() {
    _subscription?.pause();
    _playIndex = 0;
    notifyListeners();
  }

  void pause() {
    _subscription?.pause();
    notifyListeners();
  }

  

  void playMidiNote(int note) {
    _flutterMidi.playMidiNote(midi: note);
  }

 

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
  
}
*/