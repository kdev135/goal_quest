import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:goal_quest/operations/fetch_quote_data.dart';

// The notification handler

@pragma("vm:entry-point") 
morningNotification() async {
  final quoteData = await fetchQuoteData() ;
  String morningNotificationBody = quoteData.split('\n').first;
  await AwesomeNotifications().createNotification(
    content: NotificationContent(id: 1, channelKey: 'key1', title: "You've got this!", body: morningNotificationBody),
  );
}


@pragma("vm:entry-point")
eveningNotification() async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
        id: 2,
        channelKey: 'key1',
        title: "How was your day?",
        body: 'Did you make progress today? Great! Note it down.'),
  );
}

/// Trigger morning notification
void scheduleMorningNotification() {
  const int mornAlarmId = 0;
// Create a DateTime object for 8:00 AM
  DateTime now = DateTime.now();
  DateTime time = DateTime(now.year, now.month, now.day, 08, 00, 00);
// Check if the time is already past. If schedule for the new time
  if (time.isBefore(now)) {
    time = time.add(const Duration(hours: 24));
  }

  AndroidAlarmManager.periodic(
    const Duration(hours: 24), // Time between notifications (interval)
    mornAlarmId,
    morningNotification,

    startAt: time,
  );
}

/// Schedule the evening alarm
void scheduleEveningNotifications() {
  const int eveAlarmId = 1;

  DateTime now = DateTime.now();
  DateTime time = DateTime(now.year, now.month, now.day, 20, 00, 00);

  // Check if the time is already past. If true schedule for the new time
  if (time.isBefore(now)) {
    time = time.add(const Duration(hours: 24));
  }


  AndroidAlarmManager.periodic(
    const Duration(hours: 24), // Time between notifications (interval)
    eveAlarmId,
    eveningNotification,
    startAt: time,
  );
}
