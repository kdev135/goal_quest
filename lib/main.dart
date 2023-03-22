import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:goal_quest/constants.dart';
import 'package:goal_quest/screens/completed_goals_screen.dart';
import 'package:goal_quest/screens/home_screen.dart';
import 'package:goal_quest/screens/goal_screen.dart';
import 'package:goal_quest/screens/new_goal_screen.dart';
import 'package:goal_quest/screens/settings_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'operations/notification_handler.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('myGoalBox');
  await Hive.openBox('achievedGoalBox');

// Initialize notifications
  await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'goal_channel_group',
          channelKey: notificationKey,
          channelName: 'goal notifications',
          channelDescription: 'goal notifications channel',
          defaultColor: primaryColor,
          importance: NotificationImportance.High
        )
      ],
      debug: true);

  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();

// check notification permission
  AwesomeNotifications().isNotificationAllowed().then((isAllowed) async {
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    } else {
      // Schedule the morning & evening notifications
      scheduleMorningNotification();
      scheduleEveningNotifications();
    }
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Goal Quest',
      theme: ThemeData.dark(),
      home: AnimatedSplashScreen(
          splash: Image.asset(
            'assets/round_logo.png',
            scale: 0.1,
          ),
          nextScreen: const HomeScreen(),
          splashTransition: SplashTransition.scaleTransition,
          backgroundColor: primaryColor),
      routes: {
        '/home': ((context) => const HomeScreen()),
        '/goal_screen': (context) => GoalScreen(),
        '/new_goal_screen': (context) => NewGoalScreen(),
        '/completed_goals_screen': (context) => const CompletedGoalsScreen(),
        '/settings_screen': (context) => const SettingsScreen()
      },
    );
  }
}
