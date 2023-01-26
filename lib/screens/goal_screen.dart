import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goal_quest/constants.dart';
import 'package:goal_quest/models/ui_models/editable_text_model.dart';
import 'package:goal_quest/models/ui_models/text_field_model.dart';
import 'package:goal_quest/operations/date_picker_fn.dart';
import 'package:goal_quest/styles.dart';
import 'package:hive/hive.dart';


// The screen allows modification of an existing goal. changes like description, target date and action plan.
// New achieved milestones about the goal can be recorded on this page.
class GoalScreen extends HookWidget {
  GoalScreen({super.key});
  final _goalBox = Hive.box('myGoalBox');

  final sizedBox = const SizedBox(
    height: 10,
  );
  final creationDate =
      '${DateTime.now().day.toString().padLeft(2, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().year}';

  @override
  Widget build(BuildContext context) {
    var newReport = useState({});
    final args = ModalRoute.of(context)!.settings.arguments;
    var goal = _goalBox.get(args.toString());
    final TextEditingController titleController = TextEditingController(text: goal['title']);
    final TextEditingController descriptionController = TextEditingController(text: goal['description']);
    final TextEditingController actionPlanController = TextEditingController(text: goal['actionPlan']);
    final TextEditingController dueDateController = TextEditingController(text: goal['dueDate']);
    final TextEditingController newReportController = TextEditingController();
    var dueDate = useState(dueDateController.text);
    var reportList = goal['reports'];

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
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            Text(
              'Tap to start editting where possible',
              textAlign: TextAlign.center,
              style: subtextFont.copyWith(fontSize: 14),
            ),
            sizedBox,
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    
                    Text(
                      '[${goal['title']}]',
                      style: titleFont2,
                      textAlign: TextAlign.center,
                    ),
                   
                    sizedBox,
                    Text(
                      'Description',
                      style: titleFont2,
                      textAlign: TextAlign.start,
                    ),
                    EditableTextModel(
                      sampleTextController: descriptionController,
                      maxLines: 5,
                    ),
                    sizedBox,
                    Text(
                      'Action plan',
                      style: titleFont2,
                      textAlign: TextAlign.start,
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
            sizedBox,
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My progress',
                      style: titleFont2,
                    ),
                    Text(
                      '\nDid you make some progress towards achieving this goal? Write about it here.',
                      style: subtextFont,
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 20,
                        child: VerticalDivider(color: primaryColor),
                      ),
                      itemCount: reportList.length,
                      itemBuilder: (context, index) => ReportContainerModel(
                        reportList: reportList,
                        index: index,
                      ),
                    ),
                    TextFieldModel(
                      textController: newReportController,
                      label: '',
                      hintText: 'Tap here to write a report.\n\n eg. Today, I bought a new motherboard from...',
                      maxlines: 3,
                    )
                  ],
                ),
              ),
            ),
            // Todo : move button navbar
            UpdateButton(
                  oldTitle: args.toString(),
                  dueDate: dueDate,
                  newReportController: newReportController,
                  reportList: reportList,
                  creationDate: creationDate,
                  titleController: titleController,
                  descriptionController: descriptionController,
                  actionPlanController: actionPlanController,
                  goal: goal,
                  goalBox: _goalBox),
          ],
        ),
      ),
      
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
                  style: defaultFont,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Report date: ${reportList[index]['record_date']}',
                  textAlign: TextAlign.start,
                  style: subtextFont,
                )
              ],
            ),
          )),
    );
  }
}

class UpdateButton extends StatelessWidget {
  const UpdateButton(
      {Key? key,
      required this.dueDate,
      required this.newReportController,
      required this.reportList,
      required this.creationDate,
      required this.titleController,
      required this.descriptionController,
      required this.actionPlanController,
      required this.goal,
      required Box goalBox,
      this.oldTitle = ''})
      : _goalBox = goalBox,
        super(key: key);

  final ValueNotifier<String> dueDate;
  final TextEditingController newReportController;
  final reportList;
  final String creationDate;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController actionPlanController;
  final goal;
  final Box _goalBox;
  final String oldTitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OutlinedButton(
        onPressed: () {
          var day = dueDate.value.substring(0, 2);
          var month = dueDate.value.substring(3, 5);
          var year = dueDate.value.substring(6);

          newReportController.text.isNotEmpty
              ? reportList.add({'record_date': creationDate, 'report': newReportController.text})
              : null;
          var updates = {
            'title': titleController.text,
            'description': descriptionController.text,
            'actionPlan': actionPlanController.text,
            'creationDate': goal['creationDate'],
            'dueDate': dueDate.value,
            'timeSpan': DateTime.parse('$year-$month-$day').difference(DateTime.now()).inDays,
            'reports': reportList
          };
           _goalBox.delete(oldTitle);
        
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
    );
  }
}
