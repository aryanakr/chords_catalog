import 'package:chords_catalog/models/chord.dart';
import 'package:chords_catalog/providers/log_provider.dart';
import 'package:chords_catalog/screens/create_chord_screen.dart';
import 'package:chords_catalog/screens/create_log_screen.dart';
import 'package:chords_catalog/widgets/chord_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

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
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewChord,
        child: Icon(Icons.add),
      ),
      body: Consumer<LogProvider>(
        builder: (context, log, child) {
          return SingleChildScrollView(
            child: StaggeredGrid.count(
              crossAxisCount: 2,
              children: [
                for (int i = 0; i < log.chords.length; i++)
                  ChordCardWidget(name: log.chords[i].name, notes: log.chords[i].drawCardDotsPos(), numStrings: log.tuning!.numStrings, startFret: log.chords[i].startFret)
              ],
            ),
          );
        },
      ),
    );
  }
}
