import 'package:flutter/material.dart';
import 'package:goal_quest/constants.dart';
import 'package:goal_quest/styles.dart';

class EditableTextModel extends StatelessWidget {
  const EditableTextModel({Key? key, required this.sampleTextController, this.fontStyle, this.maxLines = 1})
      : super(key: key);

  final TextEditingController sampleTextController;
  final TextStyle? fontStyle;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Card(
           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: interactiveFieldGrey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: EditableText(
            maxLines: maxLines,
            controller: sampleTextController,
            focusNode: FocusNode(canRequestFocus: true),
            style: fontStyle ?? defaultFont,
            cursorColor: Colors.orange,
            backgroundCursorColor: Colors.green),
      ),
    );
  }
}
