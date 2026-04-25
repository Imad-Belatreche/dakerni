import 'package:isar/isar.dart';

part 'notification_model.g.dart';

@Collection()
class NotificationModel {
  Id id = Isar.autoIncrement;
  late String content;
  late DateTime scheduledDate;
  late bool isRead;
  late DateTime createdAt;

  NotificationModel({
    required this.content,
    required this.scheduledDate,
    this.isRead = false,
  }) : createdAt = DateTime.now();
}
