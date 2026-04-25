import 'package:dakerni/models/notification_model.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

late final Isar isar;

Future<Isar> initializeIsar() async {
  final dir = await getApplicationDocumentsDirectory();
  isar = await Isar.open([NotificationModelSchema], directory: dir.path);
  return isar;
}
