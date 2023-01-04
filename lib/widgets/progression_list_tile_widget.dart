import 'package:chords_catalog/models/progression.dart';
import 'package:chords_catalog/providers/sound_player_provider.dart';
import 'package:chords_catalog/theme/chord_log_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/create_progression_screen.dart';

class ProgressionListTileWidget extends StatelessWidget {
  final int index;
  final Progression progression;
  const ProgressionListTileWidget(
      {Key? key, required this.index, required this.progression})
      : super(key: key);

  

  void _navigateToEditProgression(BuildContext context) {
    Navigator.of(context).pushNamed(CreateProgressionScreen.routeName, arguments: CreateProgressionArgs(progression: progression, index: index));
  }

  @override
  Widget build(BuildContext context) {
    void _playProgression() {
      final soundPlayer = Provider.of<SoundPlayerProvider>(context, listen: false);
      soundPlayer.startSequence(progression.sequence);
    }

    return Card(
      elevation: 8,
      color: Colors.white,
      child: InkWell(
        onTap: () => _navigateToEditProgression(context),
        child: Container(
          height: 80,
          margin: EdgeInsets.only(left: 32, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(progression.name, style: TextStyle(fontSize: 22),),
              Container(
                child: ElevatedButton(
                  onPressed: _playProgression,
                  child: Icon(Icons.play_arrow),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(CircleBorder()),
                    padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                    backgroundColor:
                        MaterialStateProperty.all(ChordLogColors.primary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
