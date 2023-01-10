import 'package:flutter/material.dart';
import 'package:goal_quest/styles.dart';

class NoGoalsWidget extends StatelessWidget {
  const NoGoalsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 100.0),
        child: Text(
          'No goals here yet',
          style: defaultFont.copyWith(fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}