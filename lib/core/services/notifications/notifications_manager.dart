import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../configrations/general_configrations.dart';


class NotificationManager {

  final _localNotificationService = FlutterLocalNotificationsPlugin();

  Future<void> initlize() async {
    tz.initializeTimeZones();

    await _localNotificationService
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!.requestNotificationsPermission();
        
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("mipmap/ic_launcher");
    DarwinInitializationSettings darwinInitializationSettings =
        const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: darwinInitializationSettings,
    );
     _localNotificationService.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        if(details.input==null){
          return;
        }
      },
    );
  }

  Future<NotificationDetails> _notificationDetails(String id) async {

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(id, "channelName",
            enableVibration: true,
            fullScreenIntent: false,
            importance: Importance.max,
            playSound: true,
            priority: Priority.max,
           // styleInformation: styleInformation,
            channelDescription: "descreption",
           );
    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails();
    return NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);
  }

  Future<void> cancellAll() async {
    await _localNotificationService.cancelAll();
  }

  Future<void> showNotification(
      {required int id,
      required String title,
      required String body, 
      required DateTime date,
     }) async {
    try {
      if (date.isBefore(DateTime.now())) {
        return;
      }
      NotificationDetails? details;
 
        details = await _notificationDetails(id.toString(),);
      
      await _localNotificationService.zonedSchedule(
          id, title, body, tz.TZDateTime.from(date, tz.local), details,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,payload: title);
    
    } catch (e) {
       if(GeneralConfigurations().isDebug){
      log(e.toString());
       }
    }
  }


 
}



