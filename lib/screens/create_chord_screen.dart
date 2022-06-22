import 'package:flutter/material.dart';

class CreateChordScreen extends StatelessWidget {
  const CreateChordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Chord')),
      body: Center(child: Text('create a chord')),
    );
  }
}