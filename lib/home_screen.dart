import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:goal_quest/constants.dart';
import 'package:goal_quest/records.dart';
import 'package:goal_quest/styles.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final _goalBox = Hive.box('myGoalBox');

// read box

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Create a new goal',
        onPressed: () {
          Navigator.pushNamed(context, '/new_goal_screen');
        },
        child: const Icon(Icons.add),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // physics: const BouncingScrollPhysics(),
            children: [
              ClipPath(
                clipper: CustomClipperPath(),
                child: Container(
                  color: primaryColor,
                  height: height / 3,
                  width: width,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Hello there, Friend!',
                          style: titleFont1,
                        ),
                        Text(
                          '“Live as if you were to die tomorrow. Learn as if you were to live forever.”\n\n- Mahatma Gandhi',
                          style: quoteFont,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          '',
                          style: quoteFont,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Body with goal cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'M Y  G O A L S',
                      style: titleFont1,
                    ),
                    _goalBox.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 100.0),
                              child: Text(
                                'No goals here yet',
                                style: defaultFont.copyWith(fontStyle: FontStyle.italic),
                              ),
                            ),
                          )
                        : GoalListView(
                            key: const Key('list'),
                          )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      // Bottom navigation buttons here
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                 
                },
              ),
              Icon(Icons.settings)
            ],
          ),
        ),
      ),
    );
  }
}

class GoalListView extends StatelessWidget {
  GoalListView({
    Key? key,
  }) : super(key: key);
  final List<ReusableGoalCard> goalList = [];
  final _goalBox = Hive.box('myGoalBox');
  @override
  Widget build(BuildContext context) {
    _goalBox.toMap().forEach((key, value) {
      goalList.add(ReusableGoalCard(
        title: value['title'],
        category: 'None',
        creationDate: value['creationDate'],
        dueBeforeDate: value['dueDate'],
      ));
    });
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: goalList,
    );
  }
}

class CustomClipperPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double width = size.width;
    double height = size.height;
    final path = Path();

    path.lineTo(0, height / 1.5);
    path.quadraticBezierTo(width * 0.5, height, width, height / 1.5);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class ReusableGoalCard extends HookWidget {
  final String title;
  final String category;
  final String creationDate;
  final String dueBeforeDate;
  ReusableGoalCard(
      {Key? key, required this.title, required this.category, required this.creationDate, required this.dueBeforeDate})
      : super(key: key);
  final _goalBox = Hive.box('myGoalBox');

  @override
  Widget build(BuildContext context) {
    var isSelected = useState(false);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: GestureDetector(
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
                const SizedBox(
                  height: 5,
                ),
                Text('Category: $category', style: GoogleFonts.dmSans(fontSize: 16)),
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
                        icon: Icon(Icons.check_box_outlined),
                        label: Text('Mark as done'),
                        onPressed: (() {}),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      OutlinedButton(
                        child: Text('Remove'),
                        onPressed: () => _goalBox.delete(title),
                      ),
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