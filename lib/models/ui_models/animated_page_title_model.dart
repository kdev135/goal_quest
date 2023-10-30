import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:goal_quest/styles.dart';

class AnimatedPageTitleModel extends StatelessWidget {
  const AnimatedPageTitleModel({
    Key? key,
    required this.titleText,
  }) : super(key: key);

  final String titleText;

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      animatedTexts: [
        TyperAnimatedText(
          titleText,
          textStyle: titleTextStyle1,
          speed: const Duration(milliseconds: 50),
        ),
      ],
      isRepeatingAnimation: false,
      pause: const Duration(milliseconds: 0),
    );
  }
}
