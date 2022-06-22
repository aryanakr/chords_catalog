import 'package:chords_catalog/models/note.dart';
import 'package:chords_catalog/widgets/scale_interval_creator_widget.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';

class ScaleConfigurationScreen extends StatefulWidget {
    static const routeName = '/scale-configuration';

  const ScaleConfigurationScreen({Key? key}) : super(key: key);

  @override
  State<ScaleConfigurationScreen> createState() => _ScaleConfigurationScreenState();
}

class _ScaleConfigurationScreenState extends State<ScaleConfigurationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scale Configuration')),
      body: Card(
        child: Column(
          children: [
            Text('Intervals'),
            Row(children: [
              Text('Key:'),
              DropdownButton(items: [
              for (String noteLabel in MidiNote.sharpNoteLabels)
                  DropdownMenuItem(
                    child: Text(noteLabel),
                    value: noteLabel,
                  ),
                ], 
                value: 'C',
                onChanged: (i) {}),
            ],),
            ScaleIntervalCreatorWidget()
          ],
        ),
      ),
    );
  }
}