import 'package:chords_catalog/theme/chord_log_colors.dart';
import 'package:flutter/material.dart';

class NumberPicker extends StatefulWidget {
  int value;
  final ValueChanged<int> update;
  final Axis buttonsAxis;
  final bool showArrowIcons;
  final int? min;
  final int? max;
  NumberPicker(
      {required this.value,
      required this.update,
      required this.buttonsAxis,
      required this.showArrowIcons,
      this.min,
      this.max});

  @override
  State<NumberPicker> createState() => _NumberPickerState();
}

class _NumberPickerState extends State<NumberPicker> {
  bool showArros = false;
  Axis buttonsAxis = Axis.vertical;

  @override
  void initState() {
    showArros = widget.showArrowIcons;
    super.initState();
  }

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
    final contentWidgets = <Widget>[
      TextButton(
          onPressed: widget.buttonsAxis == Axis.vertical
              ? increaseValue
              : decreaseValue,
          child: widget.showArrowIcons
              ? (widget.buttonsAxis == Axis.vertical
                  ? const Icon(
                      Icons.arrow_drop_up,
                      color: ChordLogColors.primary,
                      size: 36,
                    )
                  : const Icon(
                      Icons.arrow_left,
                      color: ChordLogColors.primary,
                      size: 48,
                    ))
              : (widget.buttonsAxis == Axis.horizontal
                  ? const Icon(
                      Icons.remove,
                      color: ChordLogColors.primary,
                      size: 32,
                    )
                  : const Icon(
                      Icons.add,
                      color: ChordLogColors.primary,
                      size: 36,
                    ))),
      Container(
        width: 48,
        padding: const EdgeInsets.all(12),
        child: Center(
          child: Text(
            widget.value.toString(),
            style: TextStyle(fontSize: 18),
          ),
        ),
        decoration:
            BoxDecoration(border: Border.all(color: ChordLogColors.primary, width: 1.5), borderRadius: BorderRadius.circular(8)),
      ),
      TextButton(
        onPressed:
            widget.buttonsAxis == Axis.vertical ? decreaseValue : increaseValue,
        child: widget.showArrowIcons
            ? (widget.buttonsAxis == Axis.vertical
                ? const Icon(
                    Icons.arrow_drop_down_outlined,
                    color: ChordLogColors.primary,
                    size: 36,
                  )
                : const Icon(
                    Icons.arrow_right,
                    color: ChordLogColors.primary,
                    size: 48,
                  ))
            : (widget.buttonsAxis == Axis.horizontal
                ? const Icon(
                    Icons.add,
                    color: ChordLogColors.primary,
                    size: 32,
                  )
                : const Icon(
                    Icons.remove,
                    color: ChordLogColors.primary,
                    size: 36,
                  )),
      )
    ];

    return SizedBox(
        child: widget.buttonsAxis == Axis.vertical
            ? Column(
                children: contentWidgets,
              )
            : Row(
                children: contentWidgets,
              ));
  }
}
