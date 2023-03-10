import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goal_quest/styles.dart';

// The card to show pending goals on home_screen
final confettiController = ConfettiController(duration: const Duration(seconds: 5));

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
    var timeMonths = (timeSpan / 31).floor();
  

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
                  style: titleFont2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Divider(
                  height: 10,
                ),
                Text('Allocated time: $timeSpan days  [ $timeMonths months ]', style: defaultFont),
                const SizedBox(
                  height: 10,
                ),
                FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Created on: $creationDate', style: subtextFont),
                      SizedBox(width: 10),
                      Text(
                        'Target date: $dueBeforeDate',
                        style: subtextFont,
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
                          label: Text(
                            'Mark as done',
                            style: defaultFont,
                          ),
                          onPressed: (() {
                            onMarked!();
                            isSelected.value = false;
                            // confettiController.play(); //!Causing crash
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
                            style: defaultFont.copyWith(color: Colors.red),
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
