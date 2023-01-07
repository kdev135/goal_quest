import 'package:flutter/material.dart';
import 'package:goal_quest/constants.dart';
import 'package:goal_quest/styles.dart';
import 'package:hive/hive.dart';

class GoalScreen extends StatelessWidget {
  GoalScreen({super.key});
  final _goalBox = Hive.box('myGoalBox');

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    var goal = _goalBox.get(args.toString());
    final TextEditingController titleController = TextEditingController(text: goal['title']);
    final TextEditingController descriptionController = TextEditingController(text: goal['description']);
    final TextEditingController actionPlanController = TextEditingController(text: goal['actionPlan']);
    final TextEditingController dueDateController = TextEditingController(text: goal['dueDate']);

    var sizedBox = const SizedBox(
      height: 10,
    );
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'E D I T  MY  G O A L',
          style: titleFont1,
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: [
            Text(
              'Tap on text to start editting',
              textAlign: TextAlign.center,
              style: subtextFont.copyWith(fontSize: 14),
            ),
            sizedBox,
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sizedBox,
                    Text(
                      'Title',
                      style: titleFont2,
                    ),
                    ReusableEditableText(
                      sampleTextController: titleController,
                    ),
                    sizedBox,
                    Text(
                      'Description',
                      style: titleFont2,
                    ),
                    ReusableEditableText(sampleTextController: descriptionController, maxLines: 5,),
                    sizedBox,
                    Text(
                      'Action plan',
                      style: titleFont2,
                    ),
                    ReusableEditableText(
                      sampleTextController: actionPlanController,
                      maxLines: 5,
                    ),
                    sizedBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Created on: ${goal['creationDate']}', style: subtextFont),
                        GestureDetector(
                          onTap: () {
                          int todayDate = DateTime.now().day;
                    int thisYear = DateTime.now().year;
                    int thisMonth = DateTime.now().month;
                    datePicker(context, thisYear, thisMonth, todayDate).then((value) {
                      value != null ? goal['dueDate'] = value : dueDateController.value = dueDateController.value;
                    });
                          },
                          child: Text(
                            'Target date: ${dueDateController.text}',
                            style: subtextFont,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Center(
              child: OutlinedButton(
                onPressed: () {
                  var updates = {
                    'title': titleController.text,
                    'description': descriptionController.text,
                    'actionPlan': actionPlanController.text,
                    'creationDate': goal['creationDate'],
                    'dueDate': dueDateController.text
                  };
                  _goalBox.put(titleController.text, updates);
                  Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                },
                child: Text(
                  'update',
                  style: defaultFont.copyWith(color: primaryColor),
                ),
                style: OutlinedButton.styleFrom(
                  // backgroundColor: primaryColor,
                 

                ),
              
              ),
            )
          ],
        ),
      ),
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

class ReusableEditableText extends StatelessWidget {
  const ReusableEditableText({Key? key, required this.sampleTextController, this.fontStyle, this.maxLines = 1})
      : super(key: key);

  final TextEditingController sampleTextController;
  final TextStyle? fontStyle;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: interactiveFieldGrey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: EditableText(
            maxLines: maxLines,
            controller: sampleTextController,
            focusNode: FocusNode(canRequestFocus: true),
            style: fontStyle ?? defaultFont,
            cursorColor: Colors.orange,
            backgroundCursorColor: Colors.green),
      ),
    );
  }
}
