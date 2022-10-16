import 'package:chords_catalog/models/chord.dart';
import 'package:chords_catalog/models/midi_sequence.dart';
import 'package:chords_catalog/models/progression.dart';
import 'package:chords_catalog/theme/chord_log_custom_icons_icons.dart';
import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ProgressionViewWidget extends StatelessWidget {
  final List<ProgressionContentElement> content;
  final int editIndex;
  final bool isPlaying;

  const ProgressionViewWidget({Key? key, required this.content, required this.editIndex, required this.isPlaying}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    IconData getIconFromWeight(NoteWeight weight) {
      switch (weight) {
        case NoteWeight.whole:
          return ChordLogCustomIcons.whole_note;
        case NoteWeight.half:
          return ChordLogCustomIcons.half_note;
        case NoteWeight.quarter:
          return ChordLogCustomIcons.quarter_note;
        case NoteWeight.eighth:
          return ChordLogCustomIcons.eighth_note;
        case NoteWeight.sixteenth:
          return ChordLogCustomIcons.sixteenth_note;
        case NoteWeight.thirtySecond:
          return ChordLogCustomIcons.thirty_second_note;
      }
    }

    IconData getRestIconFromWeight(NoteWeight weight) {
      switch (weight) {
        case NoteWeight.whole:
          return Icons.remove;
        case NoteWeight.half:
          return Icons.remove;
        case NoteWeight.quarter:
          return ChordLogCustomIcons.quarter_silent_note;
        case NoteWeight.eighth:
          return ChordLogCustomIcons.eight_silent_note;
        case NoteWeight.sixteenth:
          return ChordLogCustomIcons.sixteenth_silent_note;
        case NoteWeight.thirtySecond:
          return ChordLogCustomIcons.thirty_second_silent_note;
      }
    }

    IconData getModeIcon(ChordPLayMode mode) {
      switch (mode) {
        case ChordPLayMode.downArpeggio:
          return Icons.keyboard_double_arrow_down;
        case ChordPLayMode.upArpeggio:
          return Icons.keyboard_double_arrow_up;
        case ChordPLayMode.strum:
          return Icons.more_vert_rounded;
      }
    }

    final ItemScrollController itemScrollController = ItemScrollController();
    final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) { 
      if (!isPlaying) {
        itemScrollController.scrollTo(index: editIndex, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      }
    });

    return Container(
      height: 120,
      padding: EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 2, color: Colors.black),)),
      child: ScrollablePositionedList.builder(
        itemCount: editIndex >= content.length ? content.length +1 : content.length,
        itemScrollController: itemScrollController,
        itemPositionsListener: itemPositionsListener,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          return i >= content.length ? Row(
            children: [
              if (i == 0 )
                  SizedBox(width: 16,),
              Icon(Icons.arrow_downward_outlined, color: Colors.blue,),
              if (i == content.length)
                  SizedBox(width: 16,),
            ],
          ) : content[i].chord != null ?
            Row(
              children: [
                if (i == 0)
                  SizedBox(width: 16,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                  if (editIndex == i)
                    Icon(Icons.arrow_downward_outlined, color: Colors.blue,),
                  SizedBox(height: 8,),
                  Container(color: content[i].chord!.cardColor, padding: EdgeInsets.symmetric(horizontal: 8),child: Text(content[i].chord!.name, style: TextStyle(fontSize: 24))),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(getIconFromWeight(content[i].weight), size: 48,),
                      Icon(getModeIcon(content[i].playMode))
                    ],
                  )
                ],),
                SizedBox(width: 16),
              ],
            )
          :
          Row(children: [
            if (i == 0)
                  SizedBox(width: 16,),
            Column(children: [
              if (editIndex == i)
                Icon(Icons.arrow_downward_outlined, color: Colors.blue,),
              SizedBox(height: 8,),
              Icon(getRestIconFromWeight(content[i].weight), size: 48,),
              
            ],),SizedBox(width: 16),
          ],);
        },),
    );
  }
}