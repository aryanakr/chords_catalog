import 'package:flutter/material.dart';

import '../models/log_scale.dart';
import '../screens/create_chord_screen.dart';
import '../widgets/suggestion_triads_widget.dart';

class ChordSuggestionsDialog {

  static void show(BuildContext context, LogScale scale) {

    showDialog(
        context: context,
        builder: (BuildContext context) {
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
                    const SizedBox(height: 16,),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(CreateChordScreen.routeName,
                          arguments: CreateChordArgs(chord: null));
                      },
                      child: const Text('Create New Chord')
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
