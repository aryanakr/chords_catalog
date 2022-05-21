import 'package:chords_catalog/screens/create_log_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  const HomeScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My chords Log'),),
      body: Center(
        child: Card(
          child: ElevatedButton(child: Text('New Log'), onPressed: () {
            Navigator.of(context).pushNamed(CreateLogScreen.routeName);
          }),
        ),
      ),
    );
  }
}