import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goal_quest/styles.dart';

class GoalCardModel extends HookWidget {
  final String title;
  final dynamic timeSpan;
  final String creationDate;
  final String dueBeforeDate;
  final VoidCallback onDelete;
  final VoidCallback? onMarked;

  const GoalCardModel({
    Key? key,
    required this.title,
    required this.timeSpan,
    required this.creationDate,
    required this.dueBeforeDate,
    this.onMarked,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isSelected = useState(false);
    var isCelebrating = useState(false);
    var timeMonths = (timeSpan / 30).floor();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: InkWell(
        onTap: () => isSelected.value
            ? isSelected.value = false
            : Navigator.pushNamed(context, '/goal_screen', arguments: title),
        onLongPress: () => isSelected.value = true,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: AppTextStyles.headline2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Divider(
                  height: 10,
                ),
                // show set time in months
                Text(
                    'Allocated time: $timeSpan days  [ ${timeMonths < 1 ? "Less than a month" : "about $timeMonths months"} ]',
                    style: AppTextStyles.bodyText1),
                const SizedBox(
                  height: 10,
                ),
                FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Created on: $creationDate', style: AppTextStyles.captionText),
                      const SizedBox(width: 10),
                      Text(
                        'Target date: $dueBeforeDate',
                        style: AppTextStyles.captionText,
                      )
                    ],
                  ),
                ),
                Visibility(
                  visible: isSelected.value,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                          icon: const Icon(Icons.check_box_outlined),
                          label: const Text(
                            'Mark as done',
                            style: AppTextStyles.bodyText1,
                          ),
                          onPressed: (() {
                            onMarked!();
                            isSelected.value = false;

                            isCelebrating.value = !isCelebrating.value;
                          })),
                      const SizedBox(
                        width: 10,
                      ),
                      TextButton(
                          onPressed: () {
                            onDelete();
                            isSelected.value = false;
                          },
                          child: Text(
                            'Remove',
                            style: AppTextStyles.bodyText1.copyWith(color: Colors.red),
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
