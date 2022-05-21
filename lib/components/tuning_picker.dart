import 'package:flutter/material.dart';

class TuningPicker extends StatefulWidget {
  int numStrings;

  TuningPicker({required this.numStrings});

  @override
  State<TuningPicker> createState() => _TuningPickerState();
}

class _TuningPickerState extends State<TuningPicker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Text('Tuning'),
              DropdownButton(items: const [
                DropdownMenuItem(
                  child: Text('Standard'),
                  value: 5,
                ),
              ], onChanged: (i) {})
            ],
          ),
          Text('Pitches'),
          Row(
            children: [
              for (int i = 0; i < widget.numStrings; i++)
                DropdownButton(items: const [
                  DropdownMenuItem(
                    child: Text('A2'),
                    value: 5,
                  ),
                ], 
                value: 5,
                onChanged: (i) {})
            ],
          )
        ],
      ),
    );
  }
}
