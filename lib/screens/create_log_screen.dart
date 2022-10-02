import 'package:chords_catalog/models/instrument.dart';
import 'package:chords_catalog/models/log_scale.dart';
import 'package:chords_catalog/providers/log_provider.dart';
import 'package:chords_catalog/screens/dashboard_screen.dart';
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
        String logName, Tuning tuning, InstrumentSound sound, LogScale scale) {
      // print('Got log name: $logName');
      // print('Got tuning with name: ${tuning.name}, pitches: ${tuning.openNotes.map((e) => e.label)}');
      // print('Got Sound ${sound.name}');
      print('Got scale ${scale.base.name} with notes ${scale.notes}');
      Provider.of<LogProvider>(context, listen: false)
          .setLog(logName, tuning, sound, scale);
      Navigator.of(context).pushNamedAndRemoveUntil(DashboardScreen.routeName, (route) => false);
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
        res.add(BaseScale(name: data[i][0], intervals: intervals, isCustomScale: false));
      }
      return res;
    }

    return Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
              const SliverAppBar(
                title: Text("Create New Log"),
                backgroundColor: ChordLogColors.bodyColor,
              ),
          ],
          body: SingleChildScrollView(
            child: Container(
              decoration:
                  const BoxDecoration(gradient: ChordLogColors.backGroundGradient),
              child: FutureBuilder(
                  future: Future.wait([
                    Tuning.loadLib(),
                    LogScale.loadLib()
                  ]),
                  builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                  
                    final tunings = _parseTuningList(snapshot.data![0]);
                    final scales = _parseScaleList(snapshot.data![1]);
                  
                    return Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(38),
                          topRight: Radius.circular(38),
                        ),
                      ),
                      child: LogConfigurationWidget(
                        submit: _onLogConfigSubmited,
                        loadedTunings: tunings,
                        loadedScales: scales,
                      ),
                    );
                  }),
            ),
          ),
        ));
  }
}
