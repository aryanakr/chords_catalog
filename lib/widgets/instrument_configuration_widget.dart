import 'package:chords_catalog/components/number_picker.dart';
import 'package:chords_catalog/components/tuning_picker.dart';
import 'package:flutter/material.dart';

class InstrumentConfigurationWidget extends StatefulWidget {
  const InstrumentConfigurationWidget({ Key? key }) : super(key: key);

  @override
  State<InstrumentConfigurationWidget> createState() => _InstrumentConfigurationWidgetState();
}

class _InstrumentConfigurationWidgetState extends State<InstrumentConfigurationWidget> {
  int stringsNumber = 6;

  void _setStringNumber(int value) {
    setState(() {
      stringsNumber = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(children: [
            Text('Number of Strings'),
            NumberPicker(value: this.stringsNumber, update: _setStringNumber, min: 1)
          ],),
          TuningPicker(numStrings: stringsNumber,),
          Row(children: [
            Text('Sound'),
            DropdownButton(items: const [
                  DropdownMenuItem(
                    child: Text('A2'),
                    value: 5,
                  ),
                ], 
                value: 5,
                onChanged: (i) {})
          ],),
          ElevatedButton(onPressed: () {print(stringsNumber);}, child: Text('Next'))
        ],
      ),
    );
  }
}