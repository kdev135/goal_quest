 import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goal_quest/constants.dart';
import 'package:goal_quest/models/ui_models/animated_page_title_model.dart';
import 'package:goal_quest/styles.dart';

class SettingsScreen extends HookWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  final appDescription = 'Welcome to Goal Quest - the app that empowers you to achieve your dreams! With Goal Quest, you can set personalized goals and track your progress towards them, helping you stay accountable and motivated. Whether you want to write a book, save up for a new car, or learn a new skill, Goal Quest is the perfect companion for your journey towards personal growth and success. Remember, you have got what it takes to achieve your true potential.';
  final homeScreenText =
      'This is where you view the goals that you are yet to achieve.\n You can hold down on a goal to view possible actions. You can also tap on it to open it on the update screen. \nThe first icon button on the left of the bottom navigation bar will open the screen where you view your achieved goals. The larger centred button can be tapped to start creating a new goal. The button on the right opens this screen.';

  final newGoalScreen =
      'To create a new goal, you will need to complete the fields on this screen.\n\nMy goal - This is the name/ title of your goal. Let it be as descriptively accurate as it can be.\n\nGoal description - Describe your new goal, mentioning what needs to be fulfilled to consider it complete. Outline the budget, timeline, and any other relevant details.\n\nAction plan -Provide a detailed plan of action to achieve the goal, including information on budget acquisition and estimated time frame for completion. Be sure to break the project down into manageable steps to ensure successful implementation\n\nTarget date- How soon do you want to hav eachieved this goal? The default date is 6 months from the date of goal creation.';

  final editGoalScreen =
      'After creating a new goal, you can update certain parts of it here.\n\n Goal description and Action plan - This is where you can modify the particular to your goal\n\nMy progress - This is where you can record the milestones you hit.';
  final attainedGoalText =
      'Goals that are marked as done can be viewed on here. You can tap on a goal for further actions.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const AnimatedPageTitleModel(titleText: 'A B O U T'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(appDescription, style: defaultFont,),
                ),
              ),
              const SizedBox(
                height: 20,
             
              ),
              Text('A P P  S C R E E N S', style: titleFont2,textAlign: TextAlign.center,),
              ExpandablePanelModel(
                title: 'Home screen',
                longText: homeScreenText,
                previewText: 'View the goals you are yet to achieve',
              ),
              ExpandablePanelModel(
                title: 'New Goal Screen',
                longText: newGoalScreen,
                previewText: 'This is where you can create a new goal.',
              ),
              ExpandablePanelModel(
                title: 'Edit Goal Screen',
                longText: editGoalScreen,
                previewText: 'Update your goal here.',
              ),
              ExpandablePanelModel(
                title: 'Attained Goal Screen',
                longText: attainedGoalText,
                previewText: 'Attained goals are available here.',
              ),
            ],
          ),
        ));
  }
}

class ExpandablePanelModel extends StatelessWidget {
  const ExpandablePanelModel({super.key, required this.longText, required this.previewText, required this.title});

  final String longText;
  final String title;
  final String previewText;

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      child: Card(
        child: Column(
          children: [
            const SizedBox(
              height: 05,
            ),
            Expandable(
              // <-- Driven by ExpandableController from ExpandableNotifier
              collapsed: ExpandableButton(
                // <-- Expands when tapped 
                child: ListTile(
                  title: Text(
                    title,
                    style: titleFont2,
                  ),
                  trailing: Text(
                    'read more...',
                    style: subtextFont.copyWith(color: primaryColor),
                  ),
                  subtitle: Text(previewText, style: defaultFont),
                ),
              ),
              expanded: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    title,
                    style: titleFont2,
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    longText,
                    style: defaultFont,
                  ),
                  ExpandableButton(
                    // <-- Collapses when tapped on
                    child: Center(
                        child: Text(
                      'show less',
                      style: subtextFont,
                    )),
                  ),
                ]),
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
