import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void sendNotification({String? title, String? body}) {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true);
  const LinuxInitializationSettings initializationSettingsLinux =
      LinuxInitializationSettings(defaultActionName: 'Open notification');
  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux);
  flutterLocalNotificationsPlugin.initialize(initializationSettings);

  AndroidNotificationChannel androidNotificationChannel =
      const AndroidNotificationChannel("battery_nots", "Battery_Nots",
          importance: Importance.max);

  flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      NotificationDetails(
          android: AndroidNotificationDetails(
              androidNotificationChannel.id, androidNotificationChannel.name)));
}
