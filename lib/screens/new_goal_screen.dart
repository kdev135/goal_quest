import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goal_quest/constants.dart';
import 'package:goal_quest/models/ui_models/animated_page_title_model.dart';
import 'package:goal_quest/models/ui_models/goal_prop_card_model.dart';
import 'package:goal_quest/styles.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../models/data_models/goal.dart';
import '../operations/date_picker_fn.dart';

class NewGoalScreen extends HookWidget {
  NewGoalScreen({Key? key}) : super(key: key);
  static String routeName = 'new_goal_screen';

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController actionPlanController = TextEditingController();
  final formKey = GlobalKey<FormState>();

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
          centerTitle: true,
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          child: Center(
            child: SizedBox(
              width: 800,
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
                            title: 'Goal name',
                            description:
                                'The title of your goal. Keep it short but accurately descriptive. Keep it realistic and attainable.',
                            hintText: 'eg. Plan a wedding for 50 guests, Learn to ride a motorbike',
                          ),
                          GoalPropCardModel(
                            textController: descriptionController,
                            title: 'My goal description',
                            description:
                                'Provide a comprehensive description of your goal. Mention aspects such as the project timeline, a budget and the specific target you intend to hit with this goal. You can update the description later after creating this goal.',
                            hintText:
                                'eg.\nBudget: \$30,000. Timeline: 9 months. The goal is to create a memorable and stress-free wedding experience for the bride and groom and their guests. The budget includes venue rental, catering, decorations, transportation, and accommodations...',
                            fieldMaxlines: 5,
                          ),
                          GoalPropCardModel(
                            textController: actionPlanController,
                            title: 'My action plan',
                            label: 'Action plan',
                            description:
                                'What exact steps will you take to reach your goal? Please describe in detail what you plan to do. Your plan details can always be modified later.',
                            hintText:
                                "eg.\n- Determine the wedding location and date based on the preference of the couple.\n- Create a guest list and send out save-the-date invitations to the guests ...",
                            fieldMaxlines: 5,
                          ),
                        ],
                      )),

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
                            const Text(
                              'My target date',
                              style: AppTextStyles.headline2,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'What is the latest date you plan to have achieved this goal? [default timeline: 6 months from now]\n',
                              style: AppTextStyles.bodyText1,
                            ),
                            Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              color: interactiveFieldGrey,
                              child: ListTile(
                                dense: true,
                                leading: const Text(
                                  'Tap to set target date:',
                                  style: AppTextStyles.bodyText1,
                                ),
                                title: Text(
                                  formattedDate,
                                  style: AppTextStyles.bodyText1.copyWith(color: Colors.orange[200]),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )),
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  final formIsValid = formKey.currentState!.validate();
                  var creationDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
                  if (formIsValid) {
                    var newGoal = Goal(
                      title: titleController.text,
                      description: descriptionController.text,
                      actionPlan: actionPlanController.text,
                      creationDate: creationDate,
                      dueDate: formattedDate,
                      timeSpan: targetDate.value.difference(DateTime.now()).inDays,
                      reports: [
                        {'record_date': creationDate, 'report': 'I created this goal!'}
                      ],
                    );

                    saveNewGoal(goalTitle: newGoal.title, goalMap: newGoal.toMap());
                    formKey.currentState!.reset();
                    _showSuccessDialog(context);
                  }
                },
                child: const Text(
                  'Create goal',
                  style: AppTextStyles.headline2,
                ),
              ),
            ),
          ),
        ));
  }
}

// Function to show success dialog
void _showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'New goal created',
          textAlign: TextAlign.center,
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: Colors.green,
              size: 50,
            ),
            SizedBox(height: 10),
            Text(
              'Congratulations! Your new goal has been created successfully. You can make it!',
              style: AppTextStyles.bodyText1,
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
            },
            child: const Text(
              'Ok',
              style: AppTextStyles.bodyText1,
            ),
          )
        ],
      );
    },
  );
}

saveNewGoal({required goalTitle, required Map goalMap}) {
  final goalBox = Hive.box('myGoalBox');
  goalBox.put(goalTitle, goalMap);
}
