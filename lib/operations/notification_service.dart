import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:goal_quest/constants.dart';

class NotificationService {
  //create instance of the flutter local notification
 static final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('ic_launcher_monochrome');

    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) {},
    );
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notifcationResponse) async {},
    );
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('goalNotificationId', 'goalNotificationChannel',
            importance: Importance.max, color: primaryColor, icon: 'ic_launcher_monochrome'),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification({int id = 0, String? title, String? body, String? payload}) async {
    print("======shownotifcation called=======");
    return await notificationsPlugin.show(id, title, body, notificationDetails());
  }
}
