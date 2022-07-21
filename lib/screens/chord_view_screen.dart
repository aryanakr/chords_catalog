import 'package:flutter/material.dart';


class ChordViewScreen extends StatelessWidget {
  static const routeName = '/chord-view';
  const ChordViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chord view")),
      body: Center(child: Text("chord view")),
    );
  }
}