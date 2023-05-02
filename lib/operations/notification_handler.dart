import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

import 'package:goal_quest/operations/fetch_quote_data.dart';
import 'package:goal_quest/operations/notification_service.dart';

// The notification handler
@pragma('vm:entry-point')
void showMorningNotification() async {
  final quoteData = await fetchQuoteData();
  String morningNotificationBody = quoteData.split('\n').first;
  await NotificationService().showNotification(
    id: 0,
    title: "You are awesome!",
    body: morningNotificationBody,
    payload: "what is it",
  );

}


@pragma('vm:entry-point')
showEveningNotification() async {
  await NotificationService().showNotification(
    id: 1,
    title: "How was your day?",
    body: "Don't forget to record your progress",
  );
}

// setup the daily 8am notification

/// Trigger morning notification
void scheduleMorningNotification() async {
  const int morningAlarmId = 0;
  DateTime now = DateTime.now();
  DateTime scheduledTime = DateTime(now.year, now.month, now.day, 07, 30, 0);
  if (scheduledTime.isBefore(now)) {
    scheduledTime = scheduledTime.add(Duration(days: 1));
  }
  await AndroidAlarmManager.periodic(
    const Duration(days: 1),
    morningAlarmId,
    showMorningNotification,
    startAt: scheduledTime,
    allowWhileIdle: true,
    exact: true,
    wakeup: true,
    rescheduleOnReboot: true,
  );
  print('Morning notification scheduled for ${scheduledTime.toString()}');
}

/// Schedule the evening alarm
void scheduleEveningNotifications() async {
  const int eveAlarmId = 1;

  DateTime now = DateTime.now();
  DateTime time = DateTime(now.year, now.month, now.day, 19, 00, 00);

  // Check if the time is already past. If true schedule for the new time
  if (time.isBefore(now)) {
    time = time.add(const Duration(hours: 24));
  }

  await AndroidAlarmManager.periodic(
    const Duration(days: 1),
    eveAlarmId,
    showEveningNotification,
    startAt: time,
    exact: true,
    wakeup: true,
  );
  print('Evening notification scheduled for ${time.toString()}');
}
