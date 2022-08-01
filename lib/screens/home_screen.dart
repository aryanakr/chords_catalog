import 'package:chords_catalog/screens/create_log_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('My chords Log'),
      ),
      body: Center(
        child: Container(
          width: screenSize.width / 4 * 3,
          height: screenSize.height / 3 * 1,
          child: Card(
            child: Column(
              children: [
                ElevatedButton(
                  child: Text('New Log'),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CreateLogScreen.routeName);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
