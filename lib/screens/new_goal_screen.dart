import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goal_quest/constants.dart';
import 'package:goal_quest/models/ui_models/goal_prop_card_model.dart';
import 'package:goal_quest/styles.dart';
import 'package:hive/hive.dart';

import '../operations/date_picker_fn.dart';

class NewGoalScreen extends HookWidget {
  NewGoalScreen({Key? key}) : super(key: key);
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController actionPlanController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final _goalBox = Hive.box('myGoalBox');

  @override
  Widget build(BuildContext context) {
    ValueNotifier<DateTime> targetDate =
        useState(DateTime.now().add(const Duration(days: 180))); // Default of 6 months from now.
    String formattedDate =
        '${targetDate.value.day.toString().padLeft(2, '0')}-${targetDate.value.month.toString().padLeft(2, '0')}-${targetDate.value.year}';
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'C R E A T E  A  G O A L',
          style: titleFont1,
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        centerTitle: true,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            // Form of properties of a new goal
            Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  children: [
                    GoalPropCardModel(
                      textController: titleController,
                      maxLength: 45,
                      title: 'My Goal',
                      description: '* The name of your goal. Keep it as short as possible but accurately descriptive. Remember, be realistic.',
                      hintText: 'eg. Build a high-end PC, Write my motivational book',
                    ),
                    GoalPropCardModel(
                      textController: descriptionController,
                      title: 'My goal description',
                      description:
                          '* Type a description of your goal. Be as detailed as possible without making it too broad. \n*Declare as you write it.',
                      hintText:
                          'eg. I will acquire the parts for my PC before  the end of July this year. The total budget is capped at \$ 2,000. My priorities are 3D rendering performance and high refresh rate gaming.',
                      fieldMaxlines: 5,
                    ),
                    GoalPropCardModel(
                      textController: actionPlanController,
                      title: 'My action plan',
                      label: 'Action plan',
                      description:
                          '* How will you attain this goal? Mention the things you will do to ensure you attain your goal.',
                      hintText:
                          'eg. I will set aside 8% of my monthly income for the next 4 months to fund this project. I will get as much info as I can about pc builds from credible sources before buying parts in order to get as much value as possible from my build.',
                      fieldMaxlines: 5,
                    ),
                  ],
                )),

            // Date selection for new goal

            Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () async {
                    int todayDate = DateTime.now().day;
                    int thisYear = DateTime.now().year;
                    int thisMonth = DateTime.now().month;
                    datePicker(context, thisYear, thisMonth, todayDate).then((value) {
                      value != null ? targetDate.value = value : targetDate = targetDate;
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My target date',
                        style: titleFont2,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        '* What is the latest date you plan to have achieve this goal before? [default: 6 months]',
                        style: defaultFont,
                      ),
                      Card(
                        color: interactiveFieldGrey,
                        child: ListTile(
                          dense: true,
                          leading: Text(
                            'Tap to set target date:',
                            style: defaultFont,
                          ),
                          title: Text(
                            formattedDate,
                            style: defaultFont.copyWith(color: Colors.orange[200]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

// Endof date selection
            Center(
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(),
                  onPressed: () {
                    final formIsValid = formKey.currentState!.validate();
                    var creationDate =
                        '${DateTime.now().day.toString().padLeft(2, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().year}';

                    if (formIsValid) {
                      // Create the new goal and commit to database
                      var newGoal = {
                        'title': titleController.text,
                        'description': descriptionController.text,
                        'actionPlan': actionPlanController.text,
                        'creationDate': creationDate,
                        'dueDate': formattedDate,
                        'timeSpan': targetDate.value.difference(DateTime.now()).inDays,
                        'reports': [{'record_date':creationDate, 'report':' I created this goal!'}]
                      };

                      _goalBox.put(titleController.text, newGoal);

                      formKey.currentState!.reset();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(
                                'New goal created',
                                textAlign: TextAlign.center,
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: Colors.green,
                                    size: 50,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Great! Your new goal has been created successfully',
                                    style: defaultFont,
                                  )
                                ],
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                                    },
                                    child: Text(
                                      'Ok',
                                      style: defaultFont,
                                    ))
                              ],
                            );
                          });
                    }
                  },
                  child: Text(
                    'Create goal',
                    style: defaultFont.copyWith(color: primaryColor),
                  )),
            )
          ],
        ),
      )),
    );
  }
}
