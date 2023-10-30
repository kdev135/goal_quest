import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:goal_quest/constants.dart';
import 'package:goal_quest/operations/notification_service.dart';
import 'package:goal_quest/screens/completed_goals_screen.dart';
import 'package:goal_quest/screens/home_screen.dart';
import 'package:goal_quest/screens/goal_screen.dart';
import 'package:goal_quest/screens/new_goal_screen.dart';
import 'package:goal_quest/screens/settings_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'operations/notification_handler.dart';

void main() async {
  await _initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Goal Quest',
      theme: ThemeData.dark(useMaterial3: true),
      home: AnimatedSplashScreen(
        splash: Image.asset(
          'assets/round_logo.png',
          scale: 0.1,
        ),
        nextScreen: const HomeScreen(),
        splashTransition: SplashTransition.scaleTransition,
        duration: 500,
        backgroundColor: kCAccentOrange,
      ),
      routes: {
        '/home': (_) => const HomeScreen(),
        '/goal_screen': (_) => GoalScreen(),
        '/new_goal_screen': (_) => NewGoalScreen(),
        '/completed_goals_screen': (_) => const CompletedGoalsScreen(),
        '/settings_screen': (_) => const SettingsScreen(),
      },
    );
  }
}

// initialize the flutter app
Future<void> _initializeApp() async {
  await Hive.initFlutter();
  await Hive.openBox('myGoalBox');
  await Hive.openBox('achievedGoalBox');
  WidgetsFlutterBinding.ensureInitialized();
  scheduleMorningNotification();
  scheduleEveningNotifications();
  await NotificationService().initNotification();

  await AndroidAlarmManager.initialize();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = NotificationService.notificationsPlugin;
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!
      .requestPermission();
}
