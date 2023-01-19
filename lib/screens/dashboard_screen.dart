import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../theme/chord_log_colors.dart';
import '../dialogs/chord_suggestions_dialog.dart';
import '../dialogs/exit_confirmation_dialog.dart';
import '../providers/log_provider.dart';
import '../providers/sound_player_provider.dart';
import '../screens/create_chord_screen.dart';
import '../screens/progressions_screen.dart';
import '../theme/chord_log_custom_icons_icons.dart';
import '../widgets/chord_card_widget.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = '/dashboard';

  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final soundPlayer = Provider.of<SoundPlayerProvider>(context);

    void _fabButtonPressed() {
      final scale = Provider.of<LogProvider>(context, listen: false).scale;
      if (scale == null) {
        return;
      }
      ChordSuggestionsDialog.show(context, scale);
    }

    return WillPopScope(
      onWillPop: () async {
        ExitConfirmationDialog.show(context);
        return false;
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: _fabButtonPressed,
          backgroundColor: ChordLogColors.primary,
          child: const Icon(Icons.add),
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
                            onLongPress: () {
                              if (!soundPlayer.isPlaying){
                                soundPlayer.pause();
                              }
                              soundPlayer.startSequence(log.chords[i].getDemoSequence());
                            },
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
      ),
    );
  }
}
