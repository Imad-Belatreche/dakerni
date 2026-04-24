import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
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
}
