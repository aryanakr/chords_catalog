import 'package:chords_catalog/models/progression.dart';
import 'package:chords_catalog/theme/chord_log_colors.dart';
import 'package:flutter/material.dart';

class ProgressionListTileWidget extends StatelessWidget {
  final int index;
  final Progression progression;
  const ProgressionListTileWidget(
      {Key? key, required this.index, required this.progression})
      : super(key: key);

  void _playProgression() {}

  void _navigateToEditProgression() {}

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      color: Colors.white,
      child: InkWell(
        onTap: _navigateToEditProgression,
        child: Container(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(progression.name),
              Container(
                margin: EdgeInsets.only(bottom: 16),
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
