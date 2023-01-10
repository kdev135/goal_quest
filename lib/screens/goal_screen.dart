import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goal_quest/constants.dart';
import 'package:goal_quest/models/ui_models/editable_text_model.dart';
import 'package:goal_quest/operations/date_picker_fn.dart';
import 'package:goal_quest/styles.dart';
import 'package:hive/hive.dart';

class GoalScreen extends HookWidget {
  GoalScreen({super.key});
  final _goalBox = Hive.box('myGoalBox');

    final sizedBox = const SizedBox(
      height: 10,
    );
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    var goal = _goalBox.get(args.toString());
    final TextEditingController titleController = TextEditingController(text: goal['title']);
    final TextEditingController descriptionController = TextEditingController(text: goal['description']);
    final TextEditingController actionPlanController = TextEditingController(text: goal['actionPlan']);
    final TextEditingController dueDateController = TextEditingController(text: goal['dueDate']);
    var dueDate = useState(dueDateController.text);

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
                    EditableTextModel(
                      sampleTextController: titleController,
                    ),
                    sizedBox,
                    Text(
                      'Description',
                      style: titleFont2,
                    ),
                    EditableTextModel(
                      sampleTextController: descriptionController,
                      maxLines: 5,
                    ),
                    sizedBox,
                    Text(
                      'Action plan',
                      style: titleFont2,
                    ),
                    EditableTextModel(
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
                              value != null
                                  ? dueDate.value =
                                      '${value.day.toString().padLeft(2, '0')}-${value.month.toString().padLeft(2, '0')}-${value.year}'
                                  : dueDateController.value = dueDateController.value;
                            });
                          },
                          child: Text(
                            'Target date: ${dueDate.value}',
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
                  var day = dueDate.value.substring(0, 2);
                  var month = dueDate.value.substring(3, 5);
                  var year =dueDate.value.substring(6);
                  var updates = {
                    'title': titleController.text,
                    'description': descriptionController.text,
                    'actionPlan': actionPlanController.text,
                    'creationDate': goal['creationDate'],
                    'dueDate': dueDate.value,
                    'timeSpan': DateTime.parse('$year-$month-$day').difference(DateTime.now()).inDays
                  };
                  _goalBox.put(titleController.text, updates);
                  Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                },
                style: OutlinedButton.styleFrom(
                    // backgroundColor: primaryColor,

                    ),
                child: Text(
                  'update',
                  style: defaultFont.copyWith(color: primaryColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


}
