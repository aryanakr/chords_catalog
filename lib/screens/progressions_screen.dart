import 'package:chords_catalog/providers/log_provider.dart';
import 'package:chords_catalog/screens/create_progression_screen.dart';
import 'package:chords_catalog/screens/dashboard_screen.dart';
import 'package:chords_catalog/theme/chord_log_colors.dart';
import 'package:chords_catalog/theme/chord_log_custom_icons_icons.dart';
import 'package:chords_catalog/widgets/progression_list_tile_widget.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class ProgressionsScreen extends StatelessWidget {
  static const routeName = '/progressions';

  const ProgressionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    void _navigateToDashboard() {
      Navigator.of(context).pushReplacementNamed(DashboardScreen.routeName);
    }

    void _fabButtonPressed() {
      Navigator.of(context).pushNamed(CreateProgressionScreen.routeName);
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _fabButtonPressed,
        backgroundColor: ChordLogColors.bodyColor,
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
        currentIndex: 1,
        selectedItemColor: ChordLogColors.bodyColor,
        onTap: (index) {
          if (index == 0) {
            _navigateToDashboard();
          }
        },
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          const SliverAppBar(
            title: Text("Progressions"),
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
                  crossAxisCount: MediaQuery.of(context).size.width < 600 ? 1 : 2,
                  children: [
                    for (int i = 0; i < log.progressions.length; i++)
                      ProgressionListTileWidget(index: i, progression: log.progressions[i])
                  ],
                );
              },
            ),
          )
        ),
      ),
    );
  }
}