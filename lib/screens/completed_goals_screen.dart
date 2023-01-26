import 'package:flutter/material.dart';
import 'package:goal_quest/screens/home_screen.dart';
import 'package:goal_quest/styles.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CompletedGoalsScreen extends StatefulWidget {
  CompletedGoalsScreen({super.key});

  @override
  State<CompletedGoalsScreen> createState() => _CompletedGoalsScreenState();
}

class _CompletedGoalsScreenState extends State<CompletedGoalsScreen> {
  final _achievedGoalBox = Hive.box('achievedGoalBox');
  final List<String> selectedItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'C O M P L E T E D  G O A L S',
          style: titleFont1,
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        centerTitle: true,
      ),
      body:
          // If no completed goals, show this

          // Completed goals exist? show this
          ListView(
        shrinkWrap: true,
        children: [completeGoalCard()],
      ),
    );
  }
}

Column completeGoalCard() {
  List<Widget> cards = [];

  achievedGoalBox.toMap().forEach((key, value) {
    cards.add(Padding(
      padding: const EdgeInsets.all(10.0),
      child: AnimatedSize(
        duration: Duration(seconds: 1),
        child: Card(
          child: InkWell(
            onLongPress: (() {
              
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
