import 'package:flutter/material.dart';
import 'package:goal_quest/components/no_goal_widget.dart';

void rebuildGoalList(Widget goalWidget, List<Widget> goalList) {
  goalWidget = goalList.isNotEmpty
      ? ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: goalList,
        )
      : const NoGoalsWidget(message: "",);
}
