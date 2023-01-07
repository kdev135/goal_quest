import 'package:flutter/material.dart';
import 'package:goal_quest/home_screen.dart';
import 'package:goal_quest/screens/goal_screen.dart';
import 'package:goal_quest/screens/new_goal_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async{
 
   await Hive.initFlutter();
   await Hive.openBox('myGoalBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme:ThemeData.dark(),
    initialRoute: '/',
      routes: {
        '/': ((context) =>  HomeScreen()),
        '/goal_screen':(context) => GoalScreen(),
        '/new_goal_screen':(context) => NewGoalScreen()
      },
    );
  }
}

