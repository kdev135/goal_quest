import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';


import 'package:goal_quest/screens/home_screen.dart';

/// Trigger morning notification 
void scheduleMorningNotification() {
  const int alarmId = 0;
  // Create a DateTime object for 8:00 AM
  DateTime now = DateTime.now();
  DateTime time = DateTime(now.year, now.month, now.day, 08, 00, 00);

// Check if the time is already past. If schedule for the new time
  if (time.isBefore(now)) {
    time = time.add(Duration(hours: 24));
 
  }

  AndroidAlarmManager.periodic(
    const Duration(hours: 24), // Time between notifications (interval)
    alarmId,
    notify,
    exact: true,
    startAt: time,
  );
}
