import 'package:chords_catalog/models/log_scale.dart';
import 'package:chords_catalog/models/note.dart';
import 'package:chords_catalog/providers/log_provider.dart';
import 'package:chords_catalog/screens/dashboard_screen.dart';
import 'package:chords_catalog/widgets/scale_interval_creator_widget.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScaleConfigurationScreen extends StatefulWidget {
    static const routeName = '/scale-configuration';

  const ScaleConfigurationScreen({Key? key}) : super(key: key);

  @override
  State<ScaleConfigurationScreen> createState() => _ScaleConfigurationScreenState();
}

class _ScaleConfigurationScreenState extends State<ScaleConfigurationScreen> {
  
  String scaleKey = 'C';
  List<String> notes = ['C'];

  void _setScaleKey (String newKey) {
    setState(() {
      scaleKey = newKey;
      notes = [newKey];
    });
  }

  void _addNote (String noteLabel) {
    setState(() {
      notes.add(noteLabel);
    });
  }

  void _submitScale() {
    print(notes);

    Provider.of<LogProvider>(context, listen: false).setLogScale(LogScale(root: scaleKey, notes: notes));

    Navigator.of(context).pushNamed(DashboardScreen.routeName);
  }

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
                value: scaleKey,
                onChanged: (String? s) {if (s != null) _setScaleKey(s);}),
            ],),
            ScaleIntervalCreatorWidget(rootNote: scaleKey, notes: notes, addNoteCallback: _addNote),
            ElevatedButton(onPressed: _submitScale, child: Text("Finish"))
          ],
        ),
      ),
    );
  }
}