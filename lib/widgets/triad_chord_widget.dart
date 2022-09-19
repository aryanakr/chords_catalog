import 'package:chords_catalog/models/log_scale.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';


class TriadChordWidget extends StatelessWidget {
  final Triad triad;

  const TriadChordWidget({Key? key, required this.triad}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: TextButton(
      onPressed: () {},
      child: Column(children: [
        Text(triad.getNumberLabel()),
        Text(triad.root+triad.type),
        Text(triad.noteLabels.map((e) => e).join(' '))
      ],),
    ),);
  }
}