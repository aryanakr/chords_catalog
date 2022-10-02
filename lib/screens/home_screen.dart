import 'package:chords_catalog/screens/create_log_screen.dart';
import 'package:chords_catalog/theme/chord_log_colors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
                gradient: ChordLogColors.mainBackgroundColor),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Container(margin: const EdgeInsets.symmetric(horizontal: 16) ,child: const Text("Guitar Chord Logs", style: TextStyle(fontSize: 58, fontFamily: 'GreatVibes'), textAlign: TextAlign.center)),
              const SizedBox(height: 30,),
              SizedBox(
                width: screenSize.width / 4 * 3,
                height: screenSize.height / 2 * 1,
                child: Card(
                  elevation: 8,
                  child: Container(
                    margin: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton(
                          child: const Text('Create New Log'),
                          onPressed: () {
                            Navigator.of(context).pushNamed(CreateLogScreen.routeName);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
