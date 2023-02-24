import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goal_quest/models/ui_models/animated_page_title_model.dart';

class SettingsScreen extends HookWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(title: const AnimatedPageTitleModel(titleText: 'S E T T I N G S'),centerTitle: true,),
      body: const Center(child: Text('Coming soon'),),
    );
  }
}
