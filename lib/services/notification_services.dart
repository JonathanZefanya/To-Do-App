import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:todo/models/task.dart';
import 'package:todo/ui/pages/notification_screen.dart';

class NotifyHelper {
  NotifyHelper();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  initializationNotifications() async {
    tz.initializeTimeZones();
// tz.setLocalLocation(tz.getLocation(timeZoneName));
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('appicon');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    await requestIOSPermissions();
  }

  Future requestIOSPermissions() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
    Get.to(NotificationScreen(payload: payload!));
  }

  tz.TZDateTime _nextInstanceOfTenAM(int hour, int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  displayNotification({required String title, required String body}) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
            sound: RawResourceAndroidNotificationSound('notification_sound'),
            playSound: true,);
    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
          presentSound: true,
          sound: 'notification_sound.caf',
        );
    const NotificationDetails androidnotificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
        0, title, body, androidnotificationDetails,
        payload: "$title|$body|${tz.TZDateTime.now(tz.local)}");
  }

  scheduledNotification(int hour, int minutes, Task task) async {
    await Permission.scheduleExactAlarm.request();

    await flutterLocalNotificationsPlugin.zonedSchedule(
        task.id!,
        task.title,
        task.note,
        //tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        _nextInstanceOfTenAM(hour, minutes),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime);
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    Get.dialog(Text(body!));
  }

  @pragma('vm:entry-point')
  void notificationTapBackground(NotificationResponse notificationResponse) {
    // handle action

    Get.to(NotificationScreen(payload: notificationResponse.payload!));
  }
  // flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>().requestNotificationsPermission();
  // // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project

  // final AndroidInitializationSettings initializationSettingsAndroid =
  //     AndroidInitializationSettings('appicon');
  // final DarwinInitializationSettings initializationSettingsDarwin =
  //     DarwinInitializationSettings(
  //         onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  // final LinuxInitializationSettings initializationSettingsLinux =
  //     LinuxInitializationSettings(
  //         defaultActionName: 'Open notification');
  // final InitializationSettings initializationSettings = InitializationSettings(
  //     android: initializationSettingsAndroid,
  //     iOS: initializationSettingsDarwin,
  //     linux: initializationSettingsLinux);
  // flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //     onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

  // ...

  // await flutterLocalNotificationsPlugin.initialize(
  //     initializationSettings,
  //     onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
  //         // ...
  //     },
  //     onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  // );

  // Future<void> _showNotificationWithActions() async {
  //   const AndroidNotificationDetails androidNotificationDetails =
  //       AndroidNotificationDetails(
  //     '...',
  //     '...',

  //     actions: <AndroidNotificationAction>[
  //       AndroidNotificationAction('id_1', 'Action 1'),
  //       AndroidNotificationAction('id_2', 'Action 2'),
  //       AndroidNotificationAction('id_3', 'Action 3'),
  //     ],
  //   );
  //   const NotificationDetails notificationDetails =
  //       NotificationDetails(android: androidNotificationDetails);
  //   await flutterLocalNotificationsPlugin.show(
  //       0, '...', '...', notificationDetails);
  // }

  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  // // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  // const AndroidInitializationSettings initializationSettingsAndroid =
  //     AndroidInitializationSettings('app_icon');
  // final DarwinInitializationSettings initializationSettingsDarwin =
  //     DarwinInitializationSettings(
  //         onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  // final LinuxInitializationSettings initializationSettingsLinux =
  //     LinuxInitializationSettings(
  //         defaultActionName: 'Open notification');

  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //       FlutterLocalNotificationsPlugin();

  //   final MacOSInitializationSettings initializationSettingsMacOS =
  //       MacOSInitializationSettings(
  //           requestAlertPermission: false,
  //           requestBadgePermission: false,
  //           requestSoundPermission: false);
  //   final LinuxInitializationSettings initializationSettingsLinux =
  //     LinuxInitializationSettings(
  //         defaultActionName: 'Open notification');
  //   final InitializationSettings initializationSettings = InitializationSettings(
  //       android: initializationSettingsAndroid,
  //       iOS: initializationSettingsDarwin,
  //       macOS: initializationSettingsDarwin,
  //       linux: initializationSettingsLinux);
  //   await flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //       onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
}
