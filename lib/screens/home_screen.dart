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
      appBar: AppBar(
        title: const Text('Chord Logs'),
      ),
      body: Container(
        decoration: const BoxDecoration(
                gradient: ChordLogColors.backGroundGradient),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 32),
              const Text("Chord Logs", style: TextStyle(fontSize: 64, fontFamily: 'GreatVibes' )),
              const SizedBox(height: 12,),
              Container(margin: const EdgeInsets.symmetric(horizontal: 18), child: const Text("Helps you with get more familiar with your guitar", style: TextStyle(fontSize: 22), textAlign: TextAlign.center)),
              const SizedBox(height: 28,),
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
                          child: const Text('New Log'),
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
