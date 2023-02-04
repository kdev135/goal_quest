import 'package:flutter/material.dart';
import 'package:goal_quest/models/ui_models/goal_card_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'no_goal_widget.dart';

 // ! Class Not in use yet
class GoalListview extends StatefulWidget {
  const GoalListview({
    Key? key,
  }) : super(key: key);

  @override
  State<GoalListview> createState() => _TestListViewState();
}

class _TestListViewState extends State<GoalListview> {
  final _goalBox = Hive.box('myGoalBox');

  @override
  void initState() {
    super.initState();
    confettiController.duration;
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> goalList = [];
    Widget goalWidget = ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: goalList,
    );
    createGoalCards() {
      _goalBox.toMap().forEach((key, value) {
        if(!value['isCompleted']){
            goalList.add(GoalCardModel(
          title: value['title'],
          timeSpan: value['timeSpan'],
          creationDate: value['creationDate'],
          dueBeforeDate: value['dueDate'],
          onDelete: (() {
            _goalBox.delete(value['title']);
            setState(() {
              goalWidget = goalList.isNotEmpty
                  ? ListView(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      children: goalList,
                    )
                  : const NoGoalsWidget();
            });
          }),
        ));
        }
      
      });
    }

    createGoalCards();
    return goalWidget;
  }
}