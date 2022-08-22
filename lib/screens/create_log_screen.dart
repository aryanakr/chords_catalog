import 'package:chords_catalog/models/instrument.dart';
import 'package:chords_catalog/models/log_scale.dart';
import 'package:chords_catalog/providers/log_provider.dart';
import 'package:chords_catalog/screens/scale_configuration_screen.dart';
import 'package:chords_catalog/widgets/instrument_configuration_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../theme/chord_log_colors.dart';

class CreateLogScreen extends StatelessWidget {
  static const routeName = '/create-log';

  const CreateLogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _onLogConfigSubmited(
        String logName, Tuning tuning, InstrumentSound sound) {
      // print('Got log name: $logName');
      // print('Got tuning with name: ${tuning.name}, pitches: ${tuning.openNotes.map((e) => e.label)}');
      // print('Got Sound ${sound.name}');
      Provider.of<LogProvider>(context, listen: false)
          .setLog(logName, tuning, sound);
      Navigator.of(context).pushNamed(ScaleConfigurationScreen.routeName);
    }

    Map<int, List<Tuning>> _parseTuningList(Map<String, dynamic> data) {
      final Map<int, List<Tuning>> res = {};

      for (final numStr in data.keys) {
        final Map<String, dynamic> strTunning = data[numStr];
        final numStrasInt = int.parse(numStr);
        final List<Tuning> tunings = [];
        for (final key in strTunning.keys) {
          final openNotes = strTunning[key]
              .toString()
              .split(',')
              .map((e) => MidiNote.byLabel(label: e))
              .toList();
          final tuning =
              Tuning(name: key, openNotes: openNotes, numStrings: numStrasInt);
          tunings.add(tuning);
        }
        res[numStrasInt] = tunings;
      }

      return res;
    }

    List<BaseScale> _parseScaleList(List<List<dynamic>> data) {
      print(data[0]);
      final List<BaseScale> res = [];

      for (int i = 1; i < data.length; i++) {
        final List<int> intervals = data[i][1].toString().split(',').map((e) => int.parse(e)).toList();
        res.add(BaseScale(name: data[i][0], intervals: intervals));
      }
      return res;
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Create Log'),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration:
              const BoxDecoration(gradient: ChordLogColors.backGroundGradient),
          child: FutureBuilder(
              future: Future.wait([
                Tuning.loadLib(),
                LogScale.loadLib()
              ]),
              builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final tunings = _parseTuningList(snapshot.data![0]);
                final scales = _parseScaleList(snapshot.data![1]);

                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    height: 900,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        child: Card(
                          child: LogConfigurationWidget(
                            submit: _onLogConfigSubmited,
                            loadedTunings: tunings,
                            loadedScales: scales,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ));
  }
}
