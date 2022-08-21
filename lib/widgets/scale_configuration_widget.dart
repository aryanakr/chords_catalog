import 'package:chords_catalog/components/painters/scale_interval_strip_painter.dart';
import 'package:flutter/material.dart';

import '../theme/chord_log_colors.dart';

class ScaleConfigurationWidget extends StatefulWidget {

  final String root;
  final List<String> notes;

  const ScaleConfigurationWidget({Key? key, required this.root, required this.notes}) : super(key: key);

  @override
  State<ScaleConfigurationWidget> createState() => _ScaleConfigurationWidgetState();
}

class _ScaleConfigurationWidgetState extends State<ScaleConfigurationWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 1.5, color: ChordLogColors.primary)),
      child: Column(
        children: [
          const SizedBox(height: 16,),
          const Text('Scale', style: TextStyle(fontSize: 22)),
          Row(
            children: [
              SizedBox(width: 24,),
              Text("Root", style: TextStyle(fontSize: 16),),
              SizedBox(width: 32,),
              SizedBox(
                    width: 75,
                    child: DropdownButton(
                      alignment: Alignment.centerRight,
                      items: [
                        DropdownMenuItem(
                          child: Text('t'),
                          value: 't',
                        ),
                      ],
                      value: 't',
                      onChanged: (String? t) {},
                      isExpanded: true,
                    ),
                  ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 150,
                child: DropdownButton(
                  alignment: Alignment.centerRight,
                  items: [
                    DropdownMenuItem(
                      child: Text('t'),
                      value: 't',
                    ),
                  ],
                  value: 't',
                  onChanged: (String? t) {},
                  isExpanded: true,
                ),
              ),
              TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [Text("New"), Icon(Icons.add)],
                  ))
            ],
          ),
          SizedBox(height: 8,),
          CustomPaint(size: Size(250, 60), painter: ScaleIntervalStripPainter(root: widget.root, notes: widget.notes)),
          

        ],
      ),

    );
  }
}