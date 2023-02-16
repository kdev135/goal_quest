import 'package:flutter/material.dart';
import 'package:goal_quest/components/no_goal_widget.dart';
import 'package:goal_quest/models/ui_models/animated_page_title_model.dart';

import 'package:goal_quest/styles.dart';

import '../constants.dart';

class CompletedGoalsScreen extends StatefulWidget {
  const CompletedGoalsScreen({super.key});

  @override
  State<CompletedGoalsScreen> createState() => _CompletedGoalsScreenState();
}

class _CompletedGoalsScreenState extends State<CompletedGoalsScreen> {
  final List<String> selectedItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: const AnimatedPageTitleModel(
          titleText: 'A T T A I N E D  G O A L S',
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        centerTitle: true,
      ),
      body: achievedGoalBox.length == 0
          ?
          // If no completed goals, show this
          const NoGoalsWidget()
          :
          // Completed goals exist? show this
          ListView(
              shrinkWrap: true,
              children: [completeGoalCard(context)],
            ),
    );
  }
}

Column completeGoalCard(BuildContext context) {
  List<Widget> cards = [];

  achievedGoalBox.toMap().forEach((key, value) {
    cards.add(Padding(
      padding: const EdgeInsets.all(10.0),
      child: AnimatedSize(
        duration: const Duration(seconds: 1),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: InkWell(
            onTap: (() {
              // Todo : add reports & achievement time to alert dialog
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            key.toString(),
                            style: titleFont2,
                          ),
                          const Divider(),
                          Text(
                            'Goal Description',
                            style: titleFont2,
                          ),
                          Text('${value['description']}', style: subtextFont),
                          const Divider(),
                          Text(
                            'Action Plan',
                            style: titleFont2,
                          ),
                          Text('${value['actionPlan']}', style: subtextFont),
                          const Divider(),
                          Text('Allocated time: ${value['timeSpan']} days [${(value['timeSpan'] / 31).round()} months]',
                              style: defaultFont),
                          Text('Achievement time: ${value['achievementTime']} days', style: defaultFont),
                        ],
                      ),
                    );
                  });
            }),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    key.toString(),
                    style: titleFont2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('Time span: ${value['timeSpan']} days'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Created on: ${value['creationDate']}', style: subtextFont),
                      Text(
                        'Target date: ${value['dueDate']}',
                        style: subtextFont,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  });
  return Column(
    children: cards,
  );
}
