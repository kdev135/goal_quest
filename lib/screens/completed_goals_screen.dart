import 'package:flutter/material.dart';
import 'package:goal_quest/components/no_goal_widget.dart';
import 'package:goal_quest/models/ui_models/animated_page_title_model.dart';

import 'package:goal_quest/styles.dart';

import '../constants.dart';
import '../utils/operations/rebuild_goal_listview.dart';

class CompletedGoalsScreen extends StatefulWidget {
  const CompletedGoalsScreen({super.key});
  static String routeName = 'attained';

  @override
  State<CompletedGoalsScreen> createState() => _CompletedGoalsScreenState();
}

class _CompletedGoalsScreenState extends State<CompletedGoalsScreen> {
  final List<String> selectedItems = [];

  @override
  Widget build(BuildContext context) {
    // var items = useState(achievedGoalBox.values.length);
    return Scaffold(
        appBar: AppBar(
           leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
          title: const AnimatedPageTitleModel(
            titleText: ' A T T A I N E D  G O A L S',
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          centerTitle: true,
        ),
        body: achievedGoalBox.isEmpty
            ?
            // If no completed goals, show this
            const NoGoalsWidget(message: "Achieved goals will appear here",)
            : const AchievedGoalListView()

        // goals exist? show this

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
              // Todo : add reports & achievement time to alert dialog
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '[ ${mapValue['title']} ]',
                            style: AppTextStyles.headline2,
                          ),
                          const Divider(),
                          const Text(
                            'Goal Description',
                            style: AppTextStyles.headline2,
                          ),
                          Text('${mapValue['description']}', style: AppTextStyles.captionText),
                          const Divider(),
                          const Text(
                            'Action Plan',
                            style: AppTextStyles.headline2,
                          ),
                          Text('${mapValue['actionPlan']}', style: AppTextStyles.captionText),
                          const Divider(),
                          Text(
                              'Allocated time: ${mapValue['timeSpan']} days [${(mapValue['timeSpan'] / 31).round()} months]',
                              style: AppTextStyles.bodyText1),
                          Text('Achievement time: ${mapValue['achievementTime']} days', style: AppTextStyles.bodyText1),
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
                                    style: AppTextStyles.bodyText1.copyWith(color: Colors.red),
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
                    style: AppTextStyles.headline2,
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
                      Text('Created on: ${mapValue['creationDate']}', style: AppTextStyles.captionText),
                      Text(
                        'Target date: ${mapValue['dueDate']}',
                        style: AppTextStyles.captionText,
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
