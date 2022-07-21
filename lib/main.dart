import 'package:chords_catalog/providers/sound_player_provider.dart';
import 'package:chords_catalog/screens/chord_view_screen.dart';
import 'package:chords_catalog/screens/configuration_screen.dart';
import 'package:chords_catalog/screens/create_chord_screen.dart';
import 'package:chords_catalog/screens/create_log_screen.dart';
import 'package:chords_catalog/screens/dashboard_screen.dart';
import 'package:chords_catalog/screens/home_screen.dart';
import 'package:chords_catalog/screens/scale_configuration_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/log_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LogProvider>(
      create: (context) => LogProvider(name: '', sound: null, tuning: null, scale: null),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
        routes: {
          HomeScreen.routeName: (ctx) => HomeScreen(),
          CreateLogScreen.routeName: (ctx) => CreateLogScreen(),
          ScaleConfigurationScreen.routeName: (ctx) => ScaleConfigurationScreen(),
          DashboardScreen.routeName: (ctx) => DashboardScreen(),
          CreateChordScreen.routeName: (ctx) => CreateChordScreen(),
          ChordViewScreen.routeName: (ctx) => ChordViewScreen()
        },
      ),
    );
  }
}
