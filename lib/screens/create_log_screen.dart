import 'package:chords_catalog/models/instrument.dart';
import 'package:chords_catalog/providers/log_provider.dart';
import 'package:chords_catalog/screens/scale_configuration_screen.dart';
import 'package:chords_catalog/widgets/instrument_configuration_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/chord_log_colors.dart';

class CreateLogScreen extends StatelessWidget {
  static const routeName = '/create-log';

  const CreateLogScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    void _onLogConfigSubmited(String logName, Tuning tuning, InstrumentSound sound) {
      // print('Got log name: $logName');
      // print('Got tuning with name: ${tuning.name}, pitches: ${tuning.openNotes.map((e) => e.label)}');
      // print('Got Sound ${sound.name}');
      Provider.of<LogProvider>(context, listen: false).setLog(logName, tuning, sound);
      Navigator.of(context).pushNamed(ScaleConfigurationScreen.routeName);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Create Log'),),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
                  gradient: ChordLogColors.backGroundGradient),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            height: 900,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(16),
                child: Card(
                  child: LogConfigurationWidget(submit: _onLogConfigSubmited),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
