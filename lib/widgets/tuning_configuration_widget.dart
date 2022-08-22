import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../components/painters/string_number_painter.dart';
import '../models/instrument.dart';
import '../theme/chord_log_colors.dart';

class TuningConfigurationWidget extends StatefulWidget {
  final int numStrings;
  final String tuningName;
  List<String> currentTuningPitches;
  List<Tuning> defaultTunings;
  final void Function(String, List<String>) update;

  TuningConfigurationWidget(
      {Key? key,
      required this.numStrings,
      required this.tuningName,
      required this.currentTuningPitches,
      required this.defaultTunings,
      required this.update})
      : super(key: key);

  @override
  State<TuningConfigurationWidget> createState() =>
      _TuningConfigurationWidgetState();
}

class _TuningConfigurationWidgetState extends State<TuningConfigurationWidget> {
  void _setTuning(String name, List<String> tune) {
    setState(() {
      widget.currentTuningPitches = tune;
      widget.update(name, tune);
    });
  }

  void _setTuningPitch(int index, String? pitchLabel) {
    setState(() {
      widget.currentTuningPitches[index] = pitchLabel ?? '';
      widget.update(Tuning.customTuningName, widget.currentTuningPitches);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Tuning> tuningsList = widget.defaultTunings;

    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 1.5, color: ChordLogColors.primary)),
      child: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          const Text('Tuning', style: TextStyle(fontSize: 22)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 150,
                child: DropdownButton(
                  alignment: Alignment.centerRight,
                  items: [
                    for (Tuning t in tuningsList)
                      DropdownMenuItem(
                        child: Text(t.name),
                        value: t.name,
                      ),
                  ],
                  value: widget.tuningName,
                  onChanged: (String? selTuning) {
                    if (selTuning != null) {
                      final tuning = tuningsList
                          .firstWhere((element) => element.name == selTuning);
                      if (!tuning.isCustomTuning) {
                        final labels =
                            tuning.openNotes.map((e) => e.label).toList();
                        _setTuning(tuning.name, labels);
                      }
                    }
                  },
                  isExpanded: true,
                ),
              ),
              TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            createTunningDialog());
                  },
                  child: Row(
                    children: [Text("New"), Icon(Icons.add)],
                  ))
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            margin: EdgeInsets.all(12),
            child: StaggeredGrid.count(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 12,
              children: [
                for (int i = 0; i < widget.numStrings; i++)
                  Row(
                    children: [
                      CustomPaint(
                        size: Size(35, 35),
                        painter:
                            StringNumberPainter(number: widget.numStrings - i),
                      ),
                      const SizedBox(width: 8),
                      Text(widget.currentTuningPitches[i])
                    ],
                  )
              ],
            ),
          )
        ],
      ),
    );
  }

  Dialog createTunningDialog() {
    String name = '';
    List<String> pitches = widget.currentTuningPitches;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'New Tuning',
                style: TextStyle(color: ChordLogColors.primary, fontSize: 18),
              ),
              SizedBox(
                height: 16,
              ),
              TextField(
                decoration: InputDecoration(
                    labelText: 'Tuning Name', hintText: 'Tuning Name'),
                onChanged: (String text) {
                  name = text;
                },
              ),
              SizedBox(
                height: 32,
              ),
              StaggeredGrid.count(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 12,
                children: [
                  for (int i = 0; i < widget.numStrings; i++)
                    Container(
                      color: ChordLogColors.secondary,
                      padding: EdgeInsets.only(top: 8),
                      child: Column(
                        children: [
                          CustomPaint(
                            size: Size(30, 30),
                            painter:
                                StringNumberPainter(number: widget.numStrings - i),
                          ),
                          const SizedBox(height: 2),
                          TextButton(
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(pitches[i], style: TextStyle(fontSize: 20),),
                                  SizedBox(
                                    width: 0,
                                  ),
                                  Icon(Icons.arrow_drop_down_circle_outlined)
                                ],
                              ))
                        ],
                      ),
                    )
                ],
              ),
              SizedBox(height: 16,),
              ElevatedButton(
                onPressed: () {
                  print(name);
                  Navigator.of(context).pop();
                },
                child: Text('Create', style: TextStyle(fontSize: 18),)),
            ],
          ),
        ),
      ),
    );
  }
}
