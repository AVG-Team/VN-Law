import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:vmoffice/data/model/notifications/notification_data_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../data/models/notifications/notification_data_model.dart';

class NotificationService {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final didReceivedLocalNotificationSubject =
  BehaviorSubject<ReceivedNotification>();
  InitializationSettings? initializationSettings;

  NotificationService._() {
    init();
  }

  init() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      _requestIOSPermission();
    }
    _initializePlatformSpecifies();
  }

  _initializePlatformSpecifies() {
    const initialAndroidSettings = AndroidInitializationSettings('fav_logo');

    const initialIosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: false
    );

    initializationSettings = const InitializationSettings(
        android: initialAndroidSettings, iOS: initialIosSettings);
  }

  _requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: false,
      badge: false,
      sound: true,
    );
  }

  static const AndroidNotificationDetails _androidNotificationDetails =
  AndroidNotificationDetails(
    '0',
    "24Hour",
    channelDescription:
    "This channel is responsible for all the local notifications",
    playSound: true,
    enableVibration: true,
    sound: RawResourceAndroidNotificationSound('alert_tones'),
    priority: Priority.high,
    importance: Importance.high,
  );
  static const DarwinNotificationDetails _iOSNotificationDetails =
  DarwinNotificationDetails();

  final NotificationDetails notificationDetails = const NotificationDetails(
    android: _androidNotificationDetails,
    iOS: _iOSNotificationDetails,
  );

  setListenerForLowerVersion(Function onNotificationForLowerVersion) {
    didReceivedLocalNotificationSubject.listen((receivedNotification) {
      onNotificationForLowerVersion(receivedNotification);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async {
    final details =
    await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (details != null && details.didNotificationLaunchApp) {
      ReceivedNotification receivedNotification = ReceivedNotification(
          id: 0, title: '', body: '', payload: details.notificationResponse?.payload);
      didReceivedLocalNotificationSubject.add(receivedNotification);
    }

    await flutterLocalNotificationsPlugin.initialize(initializationSettings!,
        onDidReceiveNotificationResponse: (payload) {
          onNotificationClick(payload);
          return;
        });
  }

  ///regular notification
  Future<void> showNotification({title, body, payload}) async {
    // const androidChannelSpecifies = AndroidNotificationDetails(
    //   '0',
    //   '24Hour',
    //   importance: Importance.high,
    //   priority: Priority.high,
    //   tag: '24Hour',
    //   playSound: true,
    //   enableVibration: true,
    //   sound: RawResourceAndroidNotificationSound('alert_tones'),
    //   visibility: NotificationVisibility.public,
    //   styleInformation: BigTextStyleInformation(''),
    // );
    await flutterLocalNotificationsPlugin.show(5, '$title', '$body', notificationDetails, payload: payload);
  }

  Future initializeTimeZone() async {
    tz.initializeTimeZones();
  }

  ///scheduled notification
  Future<void> scheduleNotification(int id, String title, String body, int hour,
      int minute, int second) async {
    tz.initializeTimeZones();

    final scheduleTime = DateTime.now();

    Duration offsetTime = DateTime.now().timeZoneOffset;

    if (kDebugMode) {
      print('hour : $hour  min : $minute  sec : $second');
    }

    if (kDebugMode) {
      print('schedule : ${scheduleTime.toString()}');
    }

    if (kDebugMode) {
      print('offsetTime : ${offsetTime.toString()}');
    }

    tz.TZDateTime tzDateTime = tz.TZDateTime.local(scheduleTime.year,
        scheduleTime.month, scheduleTime.day, hour, minute, second, 0, 0)
        .subtract(offsetTime);
    if (tzDateTime.isBefore(scheduleTime)) {
      tzDateTime = tzDateTime.add(const Duration(days: 1));
    }

    NotificationDataModel notificationData = NotificationDataModel(
        id: "0", body: '', title: '', type: 'check-in', image: null, url: '');

    String payload = json.encode(notificationData.toJson());

    await flutterLocalNotificationsPlugin.zonedSchedule(
        id, title, body, tzDateTime, notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exact,
        uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload);
  }

  Future<void> showNotificationWithAttachment(
      {title, body, image, payload = 'payload'}) async {
    final bigPicture = await _downloadAndSaveFile('$image', 'bigPicture');
    final largeIcon = await _downloadAndSaveFile('$image', 'largeIcon');
    final iosPlatformSpecifies = DarwinNotificationDetails(
      attachments: [DarwinNotificationAttachment(bigPicture)],
    );
    final bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicture),
      largeIcon: FilePathAndroidBitmap(largeIcon),
      contentTitle: '<b>$title</b>',
      htmlFormatContentTitle: true,
      summaryText: '<p>$body</p>',
      htmlFormatSummaryText: true,
    );
    final androidChannelSpecifies = AndroidNotificationDetails(
        'sookh1', 'sookh1',
        priority: Priority.high,
        importance: Importance.high,
        channelShowBadge: true,
        styleInformation: bigPictureStyleInformation);
    final notificationDetails = NotificationDetails(
        android: androidChannelSpecifies, iOS: iosPlatformSpecifies);
    await flutterLocalNotificationsPlugin
        .show(0, '$title', '$body', notificationDetails, payload: payload);
  }

  _downloadAndSaveFile(String url, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final response = await http.get(Uri.parse(url));
    File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future<void> repeatNotification() async {
    const androidChannelSpecifies = AndroidNotificationDetails(
        'CHANNEL_ID 3', 'CHANNEL_NAME 3',
        importance: Importance.high, priority: Priority.high);
    const iosChannelSpecifies = DarwinNotificationDetails();
    const platformChannelSpecifies = NotificationDetails(
        android: androidChannelSpecifies, iOS: iosChannelSpecifies);
    flutterLocalNotificationsPlugin.periodicallyShow(0, 'repeat title',
        'repeat body', RepeatInterval.everyMinute, platformChannelSpecifies,
        androidScheduleMode: AndroidScheduleMode.exact,payload: 'payload');
  }
}

NotificationService notificationPlugin = NotificationService._();

class ReceivedNotification {
  final int? id;
  final String? title;
  final String? body;
  final String? payload;

  ReceivedNotification({this.id, this.title, this.body, this.payload});
}
