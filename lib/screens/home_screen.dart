import 'package:flutter/material.dart';
import 'package:goal_quest/components/custom_clip_path.dart';
import 'package:goal_quest/components/no_goal_widget.dart';
import 'package:goal_quest/models/ui_models/goal_card_model.dart';
import 'package:goal_quest/constants.dart';
import 'package:goal_quest/operations/fetch_quote_data.dart';
import 'package:goal_quest/operations/get_achievement_time.dart';
import 'package:goal_quest/operations/notification_handler.dart';
import 'package:goal_quest/operations/rebuild_goal_listview.dart';
import 'package:goal_quest/styles.dart';

import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var quoteData = defaultQuote;

  @override
  void initState() {
    super.initState();
    fetchNewQuote();
  }

  Future<void> fetchNewQuote() async {
    String fetchedData = await fetchQuoteData();
    setState(() {
      quoteData = fetchedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Create a new goal',
        backgroundColor: kCPrimaryCTAColor,
        onPressed: () {
          Navigator.pushNamed(context, '/new_goal_screen');
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipPath(
                clipper: CustomClipperPath(),
                child: Container(
                  decoration:
                      BoxDecoration(image: DecorationImage(image: AssetImage('assets/ss.jpg'), fit: BoxFit.fill)),
                  height: height / 3,
                  width: width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Hello there, friend!',
                          style: titleTextStyle1,
                        ),
                        Text(
                          quoteData,
                          style: quoteTextStyle,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '',
                          style: quoteTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'M Y  G O A L S',
                      style: titleTextStyle1,
                    ),
                    goalBox.isEmpty
                        ? const NoGoalsWidget(
                            message: 'Tap on the  ➕  icon to create a goal',
                          )
                        : const GoalListview()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
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
              IconButton(
                icon: const Icon(Icons.info_outline),
                tooltip: 'How it works',
                onPressed: () async {
                  Navigator.pushNamed(context, '/settings_screen');
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

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

// Create a goal for each goal
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

// Do this when  goal is marked as done
          onMarked: () {
            var finishedGoal = goalBox.get(value['title']);
            String achievementTime = getAchievementTime(dateToFormat: finishedGoal['creationDate']);
            finishedGoal['achievementTime'] = achievementTime; // Time taken to achieve the goal
            achievedGoalBox.put(value['title'], finishedGoal);
            goalBox.delete(value['title']);
            setState(() {
              rebuildGoalList(goalWidget, goalList);
            });
          },
        ),
      );
    });
    return goalWidget;
  }
}
