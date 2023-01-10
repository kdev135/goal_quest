import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goal_quest/constants.dart';
import 'package:goal_quest/styles.dart';
import 'package:hive/hive.dart';

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
            Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  children: [
                    ReusableGoalPropCard(
                      textController: titleController,
                      title: 'My Goal',
                      description: '* The name of your goal. Keep it as short as possible but accurately descriptive.',
                      hintText: 'eg. Build a PC, write book',
                    ),
                    ReusableGoalPropCard(
                      textController: descriptionController,
                      title: 'My goal description',
                      description:
                          '* Type a description of your goal. Be as detailed as possible without going off-topic. Declare it.',
                      hintText:
                          'I will acquire the parts for my PC before  the end of July this year. The total budget is capped at \$ 1,000',
                      fieldMaxlines: 5,
                    ),
                    ReusableGoalPropCard(
                      textController: actionPlanController,
                      title: 'My action plan',
                      label: 'Action plan',
                      description:
                          '* How will you attain this goal? Mention the things you will do to ensure you attain your goal.',
                      hintText:
                          'eg. I will set aside 8% of my monthly income to fund this goal. I will actively liase with my real estate agent to stay update on the available deals.',
                      fieldMaxlines: 5,
                    ),
                  ],
                )),
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
                        'Target date',
                        style: titleFont2,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'What is the target date you plan to achieve this goal before? [default: 6 months]',
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
            Center(
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                   
                  ),
                  onPressed: () {
                    final formIsValid = formKey.currentState!.validate();
                    var creationDate =
                        '${DateTime.now().day.toString().padLeft(2, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().year}';

                    if (formIsValid) {
                    
                      var newGoal = {
                        'title': titleController.text,
                        'description': descriptionController.text,
                        'actionPlan': actionPlanController.text,
                        'creationDate': creationDate,
                        'dueDate': formattedDate,
                        'timeSpan' : targetDate.value.difference(DateTime.now()).inDays
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

  Future<DateTime?> datePicker(BuildContext context, int thisYear, int thisMonth, int todayDate) {
    return showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(thisYear, thisMonth, todayDate),
        lastDate: DateTime(2033));
  }
}

class ReusableGoalPropCard extends StatelessWidget {
  const ReusableGoalPropCard(
      {Key? key,
      required this.textController,
      required this.title,
      this.label,
      required this.description,
      required this.hintText,
      this.fieldMaxlines = 1})
      : super(key: key);

  final TextEditingController textController;
  final String title;
  final String? label;
  final String description;
  final String hintText;
  final int fieldMaxlines;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                title,
                style: titleFont2,
              ),
            ),
            Text(
              description,
              style: defaultFont,
            ),
            ReusableTextField(
              textController: textController,
              label: label ?? title,
              hintText: hintText,
              maxlines: fieldMaxlines,
            ),
          ],
        ),
      ),
    );
  }
}

class ReusableTextField extends StatelessWidget {
  const ReusableTextField(
      {Key? key, required this.textController, required this.label, required this.hintText, this.maxlines = 1})
      : super(key: key);

  final TextEditingController textController;
  final String label;
  final String hintText;
  final int maxlines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20.0),
      child: TextFormField(
        controller: textController,
        maxLines: maxlines,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.next,
       
        decoration: InputDecoration(
            label: Text(label),
            filled: true,
            fillColor: interactiveFieldGrey,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            floatingLabelStyle: textFieldLabelFont,
            hintText: hintText,
             border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
            ),
        validator: (value) {
          if (value == null || value.length < 5) {
            return 'Please be more detailed';
          } else {
            return null;
          }
        },
      ),
    );
  }
}
