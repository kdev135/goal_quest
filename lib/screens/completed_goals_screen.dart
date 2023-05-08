import 'package:flutter/material.dart';
import 'package:goal_quest/components/no_goal_widget.dart';
import 'package:goal_quest/models/ui_models/animated_page_title_model.dart';
import 'package:goal_quest/operations/rebuild_goal_listview.dart';

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
            titleText: ' A T T A I N E D  G O A L S',
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          centerTitle: true,
        ),
        body: achievedGoalBox.length == 0
            ?
        
            const NoGoalsWidget(message: "Achieved goals will appear here",)
            : const AchievedGoalListView()

  

        );
  }
}

Column completeGoalCard(BuildContext context, itemCount) {
  List<Widget> cards = [];

  achievedGoalBox.toMap().forEach((key, mapValue) {
    cards.add(AchievedGoalCard(
      mapValue: mapValue,
    ));
  });
  return Column(
    children: cards,
  );
}

class AchievedGoalListView extends StatefulWidget {
  const AchievedGoalListView({super.key});

  @override
  State<AchievedGoalListView> createState() => _AchievedGoalListViewState();
}

class _AchievedGoalListViewState extends State<AchievedGoalListView> {
  @override
  Widget build(BuildContext context) {
    final List<AchievedGoalCard> goalList = [];
    Widget goalWidget = ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: goalList,
    );

    achievedGoalBox.toMap().forEach((key, mapValue) {
      goalList.add(AchievedGoalCard(
        mapValue: mapValue,
        action: () {
          setState(() {
            rebuildGoalList(goalWidget, goalList);
          });
        },
      ));
    });
    return goalWidget;
  }
}

class AchievedGoalCard extends StatelessWidget {
  const AchievedGoalCard({
    required this.mapValue,
    this.action,
    super.key,
  });
  final dynamic mapValue;
 final Function? action;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: AnimatedSize(
        duration: const Duration(seconds: 1),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: InkWell(
            onTap: (() {
           
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                           '[ ${ mapValue['title']} ]',
                            style: titleFont2,
                          ),
                          const Divider(),
                          Text(
                            'Goal Description',
                            style: titleFont2,
                          ),
                          Text('${mapValue['description']}', style: subtextFont),
                          const Divider(),
                          Text(
                            'Action Plan',
                            style: titleFont2,
                          ),
                          Text('${mapValue['actionPlan']}', style: subtextFont),
                          const Divider(),
                          Text(
                              'Allocated time: ${mapValue['timeSpan']} days [${(mapValue['timeSpan'] / 31).round()} months]',
                              style: defaultFont),
                          Text('Achievement time: ${mapValue['achievementTime']} days', style: defaultFont),
                          Visibility(
                              child: Row(
                            children: [
                              TextButton(
                                  onPressed: () {
                                    achievedGoalBox.delete(mapValue['title']);
                                    action!();
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Delete',
                                    style: defaultFont.copyWith(color: Colors.red),
                                  ))
                            ],
                          ))
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
                    mapValue['title'],
                    style: titleFont2,
                  ),
                  const Divider(),
                  Text('Time span: ${mapValue['timeSpan']} days'),
                  const SizedBox(height: 5),
                  Text('Achievement time: ${mapValue['achievementTime']} days'),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Created on: ${mapValue['creationDate']}', style: subtextFont),
                      Text(
                        'Target date: ${mapValue['dueDate']}',
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
    );
  }
}
