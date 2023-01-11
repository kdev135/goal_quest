import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goal_quest/constants.dart';
import 'package:goal_quest/models/ui_models/editable_text_model.dart';
import 'package:goal_quest/models/ui_models/text_field_model.dart';
import 'package:goal_quest/operations/date_picker_fn.dart';
import 'package:goal_quest/styles.dart';
import 'package:hive/hive.dart';

class GoalScreen extends HookWidget {
  GoalScreen({super.key});
  final _goalBox = Hive.box('myGoalBox');

  final sizedBox = const SizedBox(
    height: 10,
  );
  var creationDate =
      '${DateTime.now().day.toString().padLeft(2, '0')}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().year}';
  List<Map> myReports = [
    {
      'date': '1',
      'details': 'Your separator can be any widget',
    },
    {
      'date': '2',
      'details': 'Yes It can be Text, Image, Container, FlutterLogo or any other widgets. 😄 😉 🍷',
    },
    {'date': '3', 'details': 'Hope this Quick Tip helps you.'}
  ];

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
                      physics: const ClampingScrollPhysics(),
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 20,
                        child: VerticalDivider(color: primaryColor),
                      ),
                      itemCount: reportList.length,
                      itemBuilder: (context, index) => ReportContainerModel(reportList: reportList, index: index,),
                    ),
                    TextFieldModel(
                      textController: newReportController,
                      label: '',
                      hintText: 'Tap here to enter new report.\n\n eg. I bought a new motherboard',
                      maxlines: 3,
                    )
                  ],
                ),
              ),
            ),
            UpdateButton(
                dueDate: dueDate,
                newReportController: newReportController,
                reportList: reportList,
                creationDate: creationDate,
                titleController: titleController,
                descriptionController: descriptionController,
                actionPlanController: actionPlanController,
                goal: goal,
                goalBox: _goalBox)
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
                  'Recorder on: ${reportList[index]['record_date']}',
                  textAlign: TextAlign.end,
                  style: subtextFont,
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
    required this.goal,
    required Box goalBox,
  })  : _goalBox = goalBox,
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
