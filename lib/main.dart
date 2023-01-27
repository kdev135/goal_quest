import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:goal_quest/constants.dart';
import 'package:goal_quest/screens/completed_goals_screen.dart';
import 'package:goal_quest/screens/home_screen.dart';
import 'package:goal_quest/screens/goal_screen.dart';
import 'package:goal_quest/screens/new_goal_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'operations/notification_handler.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('myGoalBox');
  await Hive.openBox('achievedGoalBox');

  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();

  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelGroupKey: 'goal_channel_group',
            channelKey: 'key1',
            channelName: 'goal notifications',
            channelDescription: 'goal notifications channel',
            defaultColor: primaryColor,
            ledColor: Colors.white)
      ],
      debug: true);

// Schedule the morning alarm
  scheduleMorningNotification();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': ((context) => HomeScreen()),
        '/goal_screen': (context) => GoalScreen(),
        '/new_goal_screen': (context) => NewGoalScreen(),
        '/completed_goals_screen': (context) => CompletedGoalsScreen()
      },
    );
  }
}
