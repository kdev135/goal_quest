import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SettingsScreen extends HookWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final confettiController = ConfettiController(duration: Duration(seconds: 5));
    var isPlaying = useState(true);
    confettiController.play();
    return Scaffold(
      body: Center(
        child: ConfettiWidget(confettiController: confettiController),
      ),
    );
  }
}
