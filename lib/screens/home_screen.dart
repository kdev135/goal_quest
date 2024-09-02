import 'package:flutter/material.dart';
import 'package:goal_quest/components/blog_preview_list_view.dart';
import 'package:goal_quest/models/ui_models/goal_card_model.dart';
import 'package:goal_quest/constants.dart';

import 'package:goal_quest/screens/completed_goals_screen.dart';
import 'package:goal_quest/screens/new_goal_screen.dart';
import 'package:goal_quest/screens/resource_screen.dart';
import 'package:goal_quest/screens/sample_content_screen.dart';
import 'package:goal_quest/screens/settings_screen.dart';
import 'package:goal_quest/styles.dart';

import 'package:hive_flutter/hive_flutter.dart';

import '../utils/operations/fetch_quote_data.dart';
import '../utils/operations/get_achievement_time.dart';
import '../utils/operations/rebuild_goal_listview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static String routeName = '/';

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


    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Create a new goal',
        onPressed: () {
          Navigator.pushNamed(context, NewGoalScreen.routeName);
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: SizedBox(
              width: 800,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height / 4,
                    width: double.infinity,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Hello there, friend!',
                              style: AppTextStyles.headline2,
                            ),
                            Text(
                              quoteData,
                              style: AppTextStyles.captionText,
                              textAlign: TextAlign.center,
                            ),
                            const Text(
                              '',
                              style: AppTextStyles.captionText,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Tips and Resources",
                        style: AppTextStyles.headline2,
                      ),
                      TextButton(onPressed: ()=> Navigator.pushNamed(context, ResourceScreen.routeName), child: const Text("view more", style: AppTextStyles.buttonText,),)
                    ],
                  ),
             
                  const SizedBox(
                    height: 80,
                    
                    
                    child: BlogPreviewListView(scrollDirection: Axis.horizontal,)
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'My Goals',
                          style: AppTextStyles.headline2,
                        ),
                        const Text("No goals yet. Get started now"),
                        goalBox.isEmpty ? const GoalSectionPlaceholderColumn() : const GoalListview()
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.checklist_sharp),
                onPressed: () {
                  Navigator.pushNamed(context, CompletedGoalsScreen.routeName);
                },
              ),
              IconButton(
                icon: const Icon(Icons.info_outline),
                tooltip: 'How it works',
                onPressed: () async {
                  Navigator.pushNamed(context, SettingsScreen.routeName);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

/// Shown in the HomeScreen when there are no goals created yet
class GoalSectionPlaceholderColumn extends StatelessWidget {
  const GoalSectionPlaceholderColumn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Card(
            child: ListTile(
          leading: const Icon(Icons.list_alt_sharp),
          title: const Text(
            "Create A New Goal",
            style: AppTextStyles.headline3,
          ),
          subtitle: const Text(
            "Get started by creating your first goals",
            style: AppTextStyles.captionText,
          ),onTap: () => Navigator.pushNamed(context, NewGoalScreen.routeName),
        )),
        Card(
            child: ListTile(
          leading: const Icon(Icons.lightbulb_rounded),
          title: const Text(
            "See Example",
            style: AppTextStyles.headline3,
          ),
          subtitle: const Text(
            "Not sure where to start? View a sample goal",
            style: AppTextStyles.captionText,
          ), onTap: () => Navigator.pushNamed(context, SampleContentScreen.routeName),
        ))
      ],
    );
  }
}

// A Listview with all goal cards
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
