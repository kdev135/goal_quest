import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goal_quest/styles.dart';
import 'package:hive_flutter/hive_flutter.dart';

// The card to show pending goals on home_screen
class GoalCardModel extends HookWidget {
  final String title;
  final dynamic timeSpan;
  final String creationDate;
  final String dueBeforeDate;
  final VoidCallback onDelete;
  final VoidCallback? onMarked;

  GoalCardModel(
      {Key? key,
      required this.title,
      required this.timeSpan,
      required this.creationDate,
      required this.dueBeforeDate,
      this.onMarked,
      required this.onDelete})
      : super(key: key);
  final _goalBox = Hive.box('myGoalBox');

  @override
  Widget build(BuildContext context) {
    var isSelected = useState(false);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: InkWell(
        onTap: () => isSelected.value
            ? isSelected.value = false
            : Navigator.pushNamed(context, '/goal_screen', arguments: title),
        onLongPress: () => isSelected.value = true,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: titleFont2,
                  overflow: TextOverflow.ellipsis,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child:
                      Text('Time span: $timeSpan days [about ${(timeSpan / 31).round()} months]', style: defaultFont),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Created on: $creationDate', style: subtextFont),
                    Text(
                      'Target date: $dueBeforeDate',
                      style: subtextFont,
                    )
                  ],
                ),
                Visibility(
                  visible: isSelected.value,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                          icon: const Icon(Icons.check_box_outlined),
                          label: const Text('Mark as done'),
                          onPressed: onMarked),
                      const SizedBox(
                        width: 10,
                      ),
                      OutlinedButton(onPressed: onDelete, child: const Text('Remove')),
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
