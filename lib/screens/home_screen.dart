import 'package:flutter/material.dart';
import 'package:goal_quest/components/custom_clip_path.dart';
import 'package:goal_quest/components/no_goal_widget.dart';
import 'package:goal_quest/models/ui_models/goal_card_model.dart';
import 'package:goal_quest/constants.dart';
import 'package:goal_quest/styles.dart';

import 'package:hive_flutter/hive_flutter.dart';

final achievedGoalBox = Hive.box('achievedGoalBox');
final goalBox = Hive.box('myGoalBox');

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

// read box

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Create a new goal',
        onPressed: () {
          Navigator.pushNamed(context, '/new_goal_screen');
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: primaryColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // physics: const BouncingScrollPhysics(),
            children: [
              ClipPath(
                clipper: CustomClipperPath(),
                child: Container(
                  color: primaryColor,
                  height: height / 4,
                  width: width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Hello there, Friend!',
                          style: titleFont1,
                        ),
                        Text(
                          '"Whatever the mind of man can conceive and believe, it can achieve."\n\n- Napoleon Hill',
                          style: quoteFont,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '',
                          style: quoteFont,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Body with goal cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'M Y  G O A L S',
                      style: titleFont1,
                    ),
                    goalBox.isEmpty ? const NoGoalsWidget() : const GoalListview()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      // Bottom navigation buttons here
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.checklist_sharp),
                onPressed: () {
                  Navigator.pushNamed(context, '/completed_goals_screen');
                },
              ),
              const Icon(Icons.settings)
            ],
          ),
        ),
      ),
    );
  }
}

// Listview with all goal card widgets
class GoalListview extends StatefulWidget {
  const GoalListview({
    Key? key,
  }) : super(key: key);

  @override
  State<GoalListview> createState() => _TestListViewState();
}

class _TestListViewState extends State<GoalListview> {
  final goalBox = Hive.box('myGoalBox');

  @override
  Widget build(BuildContext context) {
    final List<Widget> goalList = [];
    Widget goalWidget = ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: goalList,
    );
    createGoalCards() {
      goalBox.toMap().forEach((key, value) {
        goalList.add(
          GoalCardModel(
            title: value['title'],
            timeSpan: value['timeSpan'],
            creationDate: value['creationDate'],
            dueBeforeDate: value['dueDate'],
            onDelete: (() {
              goalBox.delete(value['title']);
              setState(() {
                rebuildGoalList(goalWidget, goalList);
              });
            }),
            onMarked: () {
              var finishedGoal = goalBox.get(value['title']);
              achievedGoalBox.put(value['title'], finishedGoal);
              goalBox.delete(value['title']);
              setState(() {
                rebuildGoalList(goalWidget, goalList);
              });
            },
          ),
        );
      });
    }

    createGoalCards();
    return goalWidget;
  }
}

void rebuildGoalList(var goalWidget, var goalList) {
  goalWidget = !goalList.isNotEmpty
      ? ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: goalList,
        )
      : const NoGoalsWidget();
}
