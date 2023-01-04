import 'package:chords_catalog/screens/home_screen.dart';
import 'package:flutter/material.dart';

class ExitConfirmationDialog{

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('Are you sure you want to exit to the home screen?'),
            ],
          ),
        ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false);},
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}