import 'package:dakerni/isar_setup.dart';
import 'package:dakerni/models/notification_model.dart';
import 'package:isar/isar.dart';

class NotificationsReposiory {
  Future<void> addNotification(NotificationModel notification) async {
    await isar.writeTxn(() async {
      await isar.notificationModels.put(notification);
    });
  }

  Future<void> updateNotification(NotificationModel notification) async {
    await isar.writeTxn(() async {
      await isar.notificationModels.put(notification);
    });
  }

  Future<void> deleteNotification(int id) async {
    await isar.writeTxn(() async {
      await isar.notificationModels.delete(id);
    });
  }

  Future<List<NotificationModel>> getAllNotifications() async {
    return await isar.notificationModels.where().findAll();
  }
}
