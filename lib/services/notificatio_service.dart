import 'dart:developer';
import 'dart:math' hide log;

import 'package:dakerni/utils/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    await plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/launcher_icon'),
        iOS: DarwinInitializationSettings(),
      ),
    );
  }

  Future<void> requestExactAlarmPermission() async {
    return plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.requestExactAlarmsPermission() ??
        Future.value();
  }

  Future<bool?> requestNotificationPermission(BuildContext context) async {
    PermissionStatus status = await Permission.notification.status;

    if (status.isPermanentlyDenied || status.isDenied) {
      if (!context.mounted) return null;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Notifications Disabled'),
          content: const Text(
            'Please enable notifications in settings to receive reminders.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                openAppSettings();
                Navigator.pop(context);
              },
              child: const Text('Open Settings'),
            ),
          ],
        ),
      );
    } else if (!status.isGranted) {
      final result = await Permission.notification.request();
      status = result;
    }
    return status.isGranted;
  }

  Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required TZDateTime scheduledDate,
  }) async {
    log(
      "Scheduling notification with id: $id at $scheduledDate with title: $title and body: $body",
    );
    try {
      await plugin.zonedSchedule(
        id: id,
        scheduledDate: scheduledDate,
        title: title,
        body: body,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            'channel_id',
            'channel_name',
            channelDescription: 'channel_description',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e) {
      log(
        "Error scheduling notification with id: $id: $e",
      );
      throw NotificationPluginException(e.toString());
    }
  }

  Future<void> cancelNotification(int id) async {
    try {
      log("Cancelling notification with id: $id");
      await plugin.cancel(id: id);
    } catch (e) {
      log(
        "Error cancelling notification with id: ${id.clamp(-pow(2, 31), pow(2, 31) - 1).toInt()}: $e",
      );
      throw NotificationPluginException(e.toString());
    }
  }
}
