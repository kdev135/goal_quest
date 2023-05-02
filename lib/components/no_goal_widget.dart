import 'package:flutter/material.dart';
import 'package:goal_quest/styles.dart';

class NoGoalsWidget extends StatelessWidget {
  const NoGoalsWidget({Key? key, required this.message}) : super(key: key);
  final String message;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 100.0),
        child: Text(
          message,
          style: defaultFont.copyWith(
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
