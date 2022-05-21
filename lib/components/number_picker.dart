import 'package:flutter/material.dart';

class NumberPicker extends StatefulWidget {

  int value;
  final ValueChanged<int> update;
  final int? min;
  final int? max;
  NumberPicker({required this.value, required this.update, this.min, this.max });

  @override
  State<NumberPicker> createState() => _NumberPickerState();
}

class _NumberPickerState extends State<NumberPicker> {

  void increaseValue() {

    if (widget.max != null && widget.max! <= widget.value) {
      return;
    }

    setState(() {
      widget.value += 1;
    });
    widget.update(widget.value);
  }

  void decreaseValue() {

    if (widget.min != null && widget.min! >= widget.value) {
      return;
    }
    
    setState(() {
      widget.value -= 1;
    });
    widget.update(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        IconButton(onPressed: increaseValue, icon: Icon(Icons.arrow_drop_up)),
        Text(widget.value.toString()),
        IconButton(onPressed: decreaseValue, icon: Icon(Icons.arrow_drop_down)),
      ],),
    );
  }
}