import 'package:flutter/material.dart';
import 'package:goal_quest/styles.dart';

import 'text_field_model.dart';

// Model for goal property fields on new_goal_screen. Contains description, title and text field of new goals
class GoalPropCardModel extends StatelessWidget {
  const GoalPropCardModel(
      {Key? key,
      required this.textController,
      required this.title,
      this.label,
      required this.description,
      required this.hintText,
      this.fieldMaxlines = 1,
       this.maxLength =700})
      : super(key: key);

  final TextEditingController textController;
  final String title;
  final String? label;
  final String description;
  final String hintText;
  final int fieldMaxlines;
final int maxLength;
  @override
  Widget build(BuildContext context) {
    return Card(
           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                title,
                style: titleFont2,
              ),
            ),
            Text(
              description,
              style: defaultFont,
            ),
            TextFieldModel(
              textController: textController,
              label: label ?? title,
              hintText: hintText,
              maxlines: fieldMaxlines,
              maxLength: maxLength,
            ),
          ],
        ),
      ),
    );
  }
}
