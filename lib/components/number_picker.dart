import 'package:chords_catalog/theme/chord_log_colors.dart';
import 'package:flutter/material.dart';

class NumberPicker extends StatefulWidget {
  int value;
  final ValueChanged<int> update;
  final int? min;
  final int? max;
  NumberPicker({required this.value, required this.update, this.min, this.max});

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
    return SizedBox(
      width: 80,
      child: Column(
        children: [
          IconButton(
              onPressed: increaseValue,
              icon: const Icon(
                Icons.arrow_drop_up,
                color: ChordLogColors.primary,
                size: 36,
              )),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(12),
            child: Text(
              widget.value.toString(),
              style: TextStyle(fontSize: 18),
            ),
            decoration: BoxDecoration(
                border: Border.all(color: ChordLogColors.primary)),
          ),
          IconButton(
            onPressed: decreaseValue,
            icon: const Icon(
              Icons.arrow_drop_down,
              color: ChordLogColors.primary,
              size: 36,
            ),
          ),
        ],
      ),
    );
  }
}
