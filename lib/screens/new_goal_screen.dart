import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goal_quest/constants.dart';
import 'package:goal_quest/models/ui_models/animated_page_title_model.dart';
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
        useState(DateTime.now().add(const Duration(days: 187))); // Default of 6 months from now.
    String formattedDate =
        '${targetDate.value.day.toString().padLeft(2, '0')}-${targetDate.value.month.toString().padLeft(2, '0')}-${targetDate.value.year}';
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
        title: const AnimatedPageTitleModel(
          titleText: 'C R E A T E  A  N E W  G O A L',
        ),
        // backgroundColor: Colors.transparent,
        // shadowColor: Colors.transparent,
        centerTitle: true,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                      description:
                          'The name of your goal. Keep it as short as possible but accurately descriptive. Remember to be realistic.',
                      hintText: 'eg. Get my body weight to 60 Kgs, Learn to code in Python',
                    ),
                    GoalPropCardModel(
                      textController: descriptionController,
                      title: 'My goal description',
                      description:
                          'Provide a comprehensive description of your goal, including as much detail as possible while also avoiding going out of scope. Use positive and decisive language. You can make changes later.',
                      hintText:
                          'eg.\nI want to get and maintain my weight at around 60 kgs from the current 78 kgs before June. I want to be fit enough to finish the August Half marathon while maintaining a steady pace.',
                      fieldMaxlines: 5,
                    ),
                    GoalPropCardModel(
                      textController: actionPlanController,
                      title: 'My action plan',
                      label: 'Action plan',
                      description:
                          'What exact actions will you take to reach your goal? Please describe in detail what you plan to do. If your plan is not quite clear now, you can update it later.',
                      hintText:
                          'eg.\n- I will change my diet immediately with the help of a professional in that area.\n- I will join a gym and spend at least 2 hours working-out every day.',
                      fieldMaxlines: 5,
                    ),
                  ],
                )),

            // Date selection for new goal

            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                        'What is the latest date you plan to have achieve this goal before? [default: 6 months]\n',
                        style: defaultFont,
                      ),
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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

// End of date selection
          ],
        ),
      )),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SizedBox(
            width: 20,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: interactiveColor,
                  
                ),
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
                      'reports': [
                        {'record_date': creationDate, 'report': ' I created this goal!'}
                      ],
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
                                    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
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
                  style: titleFont2,
                )),
          ),
        ),
      ),
    );
  }
}
