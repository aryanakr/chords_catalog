import 'package:chords_catalog/screens/create_chord_screen.dart';
import 'package:chords_catalog/screens/create_log_screen.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = '/dashboard';
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    void _createNewChord() {
      Navigator.of(context).pushNamed(CreateChordScreen.routeName);
    }

    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      floatingActionButton: FloatingActionButton(onPressed: _createNewChord, child: Icon(Icons.add),),
      body: Center(child: Text("Nothing to show")),
    );
  }
}