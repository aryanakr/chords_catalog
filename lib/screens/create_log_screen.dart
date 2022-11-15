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
      print('Got scale ${scale.base.name} with notes ${scale.notes}, with id ${scale.id}');
      Provider.of<LogProvider>(context, listen: false)
          .setLog(logName, tuning, sound, scale);
      Navigator.of(context).pushNamedAndRemoveUntil(DashboardScreen.routeName, (route) => false);
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
                    BaseScale.loadLib()
                  ]),
                  builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                  
                    final tunings = snapshot.data![0] as Map<int, List<Tuning>>;
                    final scales = snapshot.data![1] as List<BaseScale>;
                  
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
