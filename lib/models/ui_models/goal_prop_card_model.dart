import 'package:flutter/material.dart';
import 'package:goal_quest/constants.dart';
import 'package:goal_quest/styles.dart';

import 'text_field_model.dart';

class GoalPropCardModel extends StatelessWidget {
  const GoalPropCardModel(
      {Key? key,
      required this.textController,
      required this.title,
      this.label,
      required this.description,
      required this.hintText,
      this.fieldMaxlines = 1,
      this.maxLength = 700})
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
      barrierColor: Color.fromRGBO(0, 0, 0, 0.8),
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                    style: titleFont2,
                  ),
                ),
                TextButton.icon(
                  icon: Icon(
                    Icons.help,
                    color: kCLightGrey,
                  ),
                  label: Text(
                    'help',
                    style: subtextTextStyle,
                  ),
                  onPressed: () => _showDialog(context),
                ),
              ],
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
