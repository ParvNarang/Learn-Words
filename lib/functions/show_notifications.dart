import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

// pragma('vm:entry-point')
void showNotification() {
  AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 12345,
          channelKey: 'image',
          title: "Learn New Words",
          body: 'Reminder to learn new words!',
          bigPicture: "https://www.collinsdictionary.com/images/full/dictionary_168552845.jpg",
          notificationLayout: NotificationLayout.BigPicture,
          payload: {"id":"12345"}
      )
  );
}

void initializeNotifications(){
  AwesomeNotifications().initialize(
      // 'resource://drawable/img',
      null,
      [ // notification icon
        NotificationChannel(
          channelGroupKey: 'basic_test',
          channelKey: 'basic',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          channelShowBadge: true,
          importance: NotificationImportance.High,
          enableVibration: true,
        ),
        NotificationChannel(
            channelGroupKey: 'image_test',
            channelKey: 'image',
            channelName: 'image notifications',
            channelDescription: 'Notification channel for image tests',
            defaultColor: Colors.blue,
            ledColor: Colors.blue,
            channelShowBadge: true,
            importance: NotificationImportance.High
        )
      ]
  );
}