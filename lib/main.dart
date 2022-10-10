import 'package:chords_catalog/screens/chord_view_screen.dart';
import 'package:chords_catalog/screens/create_chord_screen.dart';
import 'package:chords_catalog/screens/create_log_screen.dart';
import 'package:chords_catalog/screens/create_progression_screen.dart';
import 'package:chords_catalog/screens/dashboard_screen.dart';
import 'package:chords_catalog/screens/home_screen.dart';
import 'package:chords_catalog/screens/progressions_screen.dart';
import 'package:chords_catalog/theme/chord_log_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'providers/log_provider.dart';
import 'providers/sound_player_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LogProvider>(create: (context) => LogProvider(name: '', sound: null, tuning: null, scale: null, chords: [], progressions: [])),
        ChangeNotifierProvider<SoundPlayerProvider>(create: (context) => SoundPlayerProvider()),],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: ChordLogColors.materialPrimary
          ).copyWith(secondary:  ChordLogColors.secondary, onPrimary: Colors.white),
        ),
        home: const HomeScreen(),
        routes: {
          HomeScreen.routeName: (ctx) => const HomeScreen(),
          CreateLogScreen.routeName: (ctx) => const CreateLogScreen(),
          DashboardScreen.routeName: (ctx) => const DashboardScreen(),
          CreateChordScreen.routeName: (ctx) => const CreateChordScreen(),
          ChordViewScreen.routeName: (ctx) => const ChordViewScreen(),
          ProgressionsScreen.routeName: (ctx) => const ProgressionsScreen(),
          CreateProgressionScreen.routeName: (ctx) => const CreateProgressionScreen(),
        },
      ),
    );
  }
}
