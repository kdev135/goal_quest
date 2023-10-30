import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goal_quest/constants.dart';
import 'package:goal_quest/models/ui_models/editable_text_model.dart';
import 'package:goal_quest/models/ui_models/text_field_model.dart';
import 'package:goal_quest/operations/date_format.dart';
import 'package:goal_quest/operations/date_picker_fn.dart';
import 'package:goal_quest/styles.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../models/ui_models/animated_page_title_model.dart';

class GoalScreen extends HookWidget {
  GoalScreen({super.key});
  final _goalBox = Hive.box('myGoalBox');

  final sizedBox = const SizedBox(
    height: 10,
  );

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    var goalObject = _goalBox.get(args.toString());
    final TextEditingController titleController = TextEditingController(text: goalObject['title']);
    final TextEditingController descriptionController = TextEditingController(text: goalObject['description']);
    final TextEditingController actionPlanController = TextEditingController(text: goalObject['actionPlan']);
    final TextEditingController dueDateController = TextEditingController(text: goalObject['dueDate']);
    final TextEditingController newReportController = TextEditingController();
    var dueDate = useState(dueDateController.text);
    var reportList = goalObject['reports'];

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
        title: const AnimatedPageTitleModel(
          titleText: 'U P D A T E  M Y  G O A L',
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            Text(
              'Tap to start editting where necessary',
              textAlign: TextAlign.center,
              style: subtextTextStyle.copyWith(fontSize: 14),
            ),
            sizedBox,
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '${goalObject['title']}',
                      style: titleFont2.copyWith(fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                    sizedBox,
                    sizedBox,
                    Text(
                      'Goal description',
                      style: titleFont2,
                      textAlign: TextAlign.start,
                    ),
                    EditableTextModel(
                      sampleTextController: descriptionController,
                      maxLines: 8,
                    ),
                    sizedBox,
                    Text(
                      'Action plan',
                      style: titleFont2,
                      textAlign: TextAlign.start,
                    ),
                    EditableTextModel(
                      sampleTextController: actionPlanController,
                      maxLines: 8,
                    ),
                    sizedBox,
                    FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Created on: ${goalObject['creationDate']}', style: subtextTextStyle),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              // split target date for picker
                              List<String> targetDate = dueDate.value.split('-');
                              int day = int.parse(targetDate[0]);
                              int year = int.parse(targetDate[2]);
                              int month = int.parse(targetDate[1]);

                              //jump to target date in date picker
                              datePicker(context, year, month, day).then((value) {
                                value != null
                                    ? dueDate.value =
                                        '${value.day.toString().padLeft(2, '0')}-${value.month.toString().padLeft(2, '0')}-${value.year}'
                                    : dueDateController.value = dueDateController.value;
                              });
                            },
                            child: Text(
                              'Target date: ${dueDate.value}',
                              style: subtextTextStyle,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            sizedBox,
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My progress report',
                      style: titleFont2,
                    ),
                    Text(
                      'Did you make some progress towards achieving this goal? Record it here. [Latest report appears first]',
                      style: subtextTextStyle,
                    ),
                    TextFieldModel(
                      textController: newReportController,
                      label: '',
                      hintText: 'eg. Today, I read 3 chapters of Atomic Habits and learnt that habits are the compound interest of self-improvement. Small changes can lead to remarkable results over time',
                      maxlines: 3,
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      reverse: true,
                      physics: const BouncingScrollPhysics(),
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                        child: VerticalDivider(color: kCAccentOrange),
                      ),
                      itemCount: reportList.length,
                      itemBuilder: (context, index) => ReportContainerModel(
                        reportList: reportList,
                        index: index,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: UpdateButton(
            oldTitle: args.toString(),
            dueDate: dueDate,
            newReportController: newReportController,
            reportList: reportList,
            creationDate: goalObject["creationDate"],
            titleController: titleController,
            descriptionController: descriptionController,
            actionPlanController: actionPlanController,
            goalObject: goalObject,
            goalBox: _goalBox),
      )),
    );
  }
}

class ReportContainerModel extends StatelessWidget {
  const ReportContainerModel({Key? key, required this.reportList, required this.index}) : super(key: key);

  final List reportList;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: interactiveFieldGrey)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '${reportList[index]['report']}',
                  textAlign: TextAlign.justify,
                  style: bodyTextStyle,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Report date: ${reportList[index]['record_date']}',
                  textAlign: TextAlign.start,
                  style: subtextTextStyle,
                )
              ],
            ),
          )),
    );
  }
}
class UpdateButton extends StatelessWidget {
  const UpdateButton({
    Key? key,
    required this.dueDate,
    required this.newReportController,
    required this.reportList,
    required this.creationDate,
    required this.titleController,
    required this.descriptionController,
    required this.actionPlanController,
    required this.goalObject,
    required Box goalBox,
    this.oldTitle = '',
  })  : _goalBox = goalBox,
        super(key: key);

  final ValueNotifier<String> dueDate;
  final TextEditingController newReportController;
  final dynamic reportList;
  final String creationDate;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController actionPlanController;
  final dynamic goalObject;
  final Box _goalBox;
  final String oldTitle;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _updateGoal(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: kCPrimaryCTAColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10))
      ),
      child: Text(
        'update',
        style: titleFont2,
      ),
    );
  }

  void _updateGoal(BuildContext context) {
    DateTime formattedDueDate = dateToDateTimeObject(dueDate.value);
    DateTime formattedCreationDate = dateToDateTimeObject(creationDate);

    if (newReportController.text.trim().isNotEmpty) {
      reportList.add({
        'record_date': customDateFormat(DateTime.now()),
        'report': newReportController.text
      });
    }

    var updates = {
      'title': titleController.text,
      'description': descriptionController.text,
      'actionPlan': actionPlanController.text,
      'creationDate': goalObject['creationDate'],
      'dueDate': dueDate.value,
      'timeSpan': formattedDueDate.difference(formattedCreationDate).inDays,
      'reports': reportList
    };

    _goalBox.delete(oldTitle);
    _goalBox.put(titleController.text, updates);

    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }
}
