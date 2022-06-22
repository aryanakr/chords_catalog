import 'package:flutter/cupertino.dart';

class SongPlayerProvider extends ChangeNotifier {
  
}

/*
import 'dart:async';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:guitar_tab_player/models/note.dart';


class BarPlayerState extends ChangeNotifier {
  final int tempo;
  final int signature;

  final _flutterMidi = FlutterMidi();

  StreamSubscription? _subscription;
  final List<TabNote> _barContent = [];

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

  void play() {
    _subscription?.cancel();

    _subscription = Stream.periodic(
      Duration(milliseconds: tempo),
    ).listen((value) => playMidiNotes());
  }

  void playMidiNotes() {
    var loop = true;
    
    if (_playRestCounter > 0) {
      _playRestCounter -= 1;
      
      return;
    }  
    
    if (_playIndex >= _barContent.length) {
      _playIndex= 0;
      if (!loop) {
        pause();
        reset();
      }
      return;
    }

    var waitTime = pow(2, 5-_barContent[_playIndex].weight.index) - 1;
    _playRestCounter = waitTime.toInt();
    var notes = _barContent[_playIndex].notes;

    if (notes.isNotEmpty) {
      for (var note in notes) {
        print('hell2');
        _flutterMidi.playMidiNote(midi: note.midi);
      }
    } 
    _playIndex = (_playIndex + 1);

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