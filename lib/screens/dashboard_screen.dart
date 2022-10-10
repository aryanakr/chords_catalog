import 'package:chords_catalog/models/chord.dart';
import 'package:chords_catalog/providers/log_provider.dart';
import 'package:chords_catalog/screens/create_chord_screen.dart';
import 'package:chords_catalog/screens/create_log_screen.dart';
import 'package:chords_catalog/screens/progressions_screen.dart';
import 'package:chords_catalog/theme/chord_log_custom_icons_icons.dart';
import 'package:chords_catalog/widgets/chord_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../models/log_scale.dart';
import '../theme/chord_log_colors.dart';
import '../widgets/suggestion_triads_widget.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = '/dashboard';

  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _createNewChord() {
      Navigator.of(context).pushNamed(CreateChordScreen.routeName,
          arguments: CreateChordArgs(chord: null));
    }

    Dialog chordSuggestionsDialog(LogScale scale) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 6,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                SuggestionTriadsWidget(scale: scale),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                    onPressed: () => _createNewChord(),
                    child: const Text('Create New Chord'))
              ],
            ),
          ),
        ),
      );
    }

    void _fabButtonPressed() {
      final scale = Provider.of<LogProvider>(context, listen: false).scale!;

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return chordSuggestionsDialog(scale);
          });
    }

    final String chrodIconPath = 'assets/icons/chord.svg';

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _fabButtonPressed,
        backgroundColor: ChordLogColors.primary,
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(ChordLogCustomIcons.chord),
            label: 'Chords',
          ),
          BottomNavigationBarItem(
            icon: Icon(ChordLogCustomIcons.progression),
            label: 'Progressions',
          )
        ],
        elevation: 8,
        currentIndex: 0,
        selectedItemColor: ChordLogColors.bodyColor,
        onTap: (index) {
          if (index == 1) {
            Navigator.of(context).pushReplacementNamed(ProgressionsScreen.routeName);
          }
        },
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          const SliverAppBar(
            title: Text("Chords"),
            backgroundColor: ChordLogColors.bodyColor,
          ),
        ],
        body: Container(
          decoration:
              const BoxDecoration(gradient: ChordLogColors.backGroundGradient),
          child: SingleChildScrollView(
            child: Consumer<LogProvider>(
              builder: (context, log, child) {
                return StaggeredGrid.count(
                  crossAxisCount: 2,
                  children: [
                    for (int i = 0; i < log.chords.length; i++)
                      Card(
                        elevation: 8,
                        color: log.chords[i].cardColor,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                CreateChordScreen.routeName,
                                arguments: CreateChordArgs(
                                    logIndex: i,
                                    chord: log.chords[i]));
                          },
                          onLongPress: () {print('long press');},
                          child: ChordCardWidget(
                                paintSize: 175,
                                name: log.chords[i].name,
                                notes: log.chords[i].drawCardDotsPos(),
                                numStrings: log.tuning!.numStrings,
                                startFret: log.chords[i].startFret),
                        ),
                      )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
