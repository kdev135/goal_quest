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

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.8),
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    title,
                    style: AppTextStyles.headline2,
                  ),
                ),
                TextButton.icon(
                  icon: const Icon(
                    Icons.help,
                   
                  ),
                  label: const Text(
                    'help',
                    style: AppTextStyles.captionText,
                  ),
                  onPressed: () => _showDialog(context),
                ),
              ],
            ),
            CustomFormField(
              textEditingController: textController,
              fieldLabel: label ?? title,
              hintText: hintText,
              linecount: fieldMaxlines,
              maxLength: maxLength,
            ),
          ],
        ),
      ),
    );
  }
}
