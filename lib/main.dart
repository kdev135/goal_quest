import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_quest/screens/blog_content_screen.dart';

import 'package:goal_quest/screens/completed_goals_screen.dart';
import 'package:goal_quest/screens/home_screen.dart';
import 'package:goal_quest/screens/goal_screen.dart';
import 'package:goal_quest/screens/new_goal_screen.dart';
import 'package:goal_quest/screens/resource_screen.dart';
import 'package:goal_quest/screens/sample_content_screen.dart';
import 'package:goal_quest/screens/settings_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'utils/operations/check_platform.dart';
import 'utils/operations/notification_handler.dart';
import 'utils/operations/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeApp();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Goal Quest',
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: ThemeMode.dark,
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (_) => const HomeScreen(),
        GoalScreen.routeName: (_) => GoalScreen(),
        NewGoalScreen.routeName: (_) => NewGoalScreen(),
        CompletedGoalsScreen.routeName: (_) => const CompletedGoalsScreen(),
        SettingsScreen.routeName: (_) => const SettingsScreen(),
        SampleContentScreen.routeName: (_) => const SampleContentScreen(),
        ResourceScreen.routeName: (_) => const ResourceScreen(),
        BlogContentScreen.routeName: (_) => const BlogContentScreen()
      },
    );
  }
}

// initialize the flutter app
Future<void> _initializeApp() async {
  await dotenv.load(fileName: ".env");

  final supabaseUrl = dotenv.env['SUPABASE_URL']!;
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY']!;

  Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
  await Hive.openBox('myGoalBox');
  await Hive.openBox('achievedGoalBox');

  final currentPlatform = checkPlatform();

  if (currentPlatform != RunningPlatform.web) {
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
}

ThemeData _buildTheme(Brightness brightness) {
  var baseTheme = ThemeData(brightness: brightness);

  // Define your color scheme
  var primaryColor = Colors.cyan;
  var colorScheme = ColorScheme.fromSeed(
    seedColor: primaryColor,
    brightness: brightness,
  );

  // Use DM Sans as the default font
  var textTheme = GoogleFonts.dmSansTextTheme(baseTheme.textTheme);

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      // color: colorScheme.surface,
      elevation: 3,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          foregroundColor: colorScheme.onPrimary,
          backgroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      filled: true,
      fillColor: colorScheme.surface,
    ),
  );
}
