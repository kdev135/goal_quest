import 'package:flutter/material.dart';
import 'package:goal_quest/constants.dart';
import 'package:goal_quest/styles.dart';

class TextFieldModel extends StatelessWidget {
  const TextFieldModel(
      {Key? key, required this.textController, required this.label, required this.hintText, this.maxlines = 1, this.maxLength=700})
      : super(key: key);

  final TextEditingController textController;
  final String label;
  final String hintText;
  final int maxlines;
  final int maxLength;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20.0),
      child: TextFormField(
        controller: textController,
        maxLines: maxlines,
        maxLength:maxLength ,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            label: Text(label),
            filled: true,
            fillColor: interactiveFieldGrey,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            floatingLabelStyle: textFieldLabelFont,
            hintText: hintText,
            hintStyle: subtextFont,
            border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
        validator: (value) {
          if (value == null || value.length < 5) {
            return 'Please be more detailed';
          } else {
            return null;
          }
        },
      ),
    );
  }
}
