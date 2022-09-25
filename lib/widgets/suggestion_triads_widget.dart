import 'package:chords_catalog/models/log_scale.dart';
import 'package:chords_catalog/widgets/triad_chord_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../models/chord.dart';

class SuggestionTriadsWidget extends StatelessWidget {
  final LogScale scale;

  const SuggestionTriadsWidget({Key? key, required this.scale})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final triads = scale.getTriads();
    return SizedBox(
      child: StaggeredGrid.count(
        crossAxisCount: 3,
        children: [
          for (var chord in triads)
            TriadChordWidget(
              triad: chord,
            )
        ],
      ),
    );
  }
}
