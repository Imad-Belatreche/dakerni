import 'package:dakerni/cubits/notification/notification_cubit.dart';
import 'package:dakerni/models/notification_model.dart';
import 'package:dakerni/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DayList extends StatelessWidget {
  final List<NotificationModel> notifications;

  const DayList({super.key, required this.notifications});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formateDate(notifications[0].scheduledDate),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Divider(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  notifications[index].content,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withAlpha(190),
                  ),
                ),
                subtitle: Text(
                  formateTime(notifications[index].scheduledDate),
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withAlpha(150),
                  ),
                ),
                leading: Icon(
                  Icons.notifications,
                  color:
                      notifications[index].scheduledDate.isBefore(
                        DateTime.now(),
                      )
                      ? Theme.of(context).colorScheme.onSurface.withAlpha(150)
                      : Theme.of(context).colorScheme.primary,
                ),
                trailing: IconButton(
                  onPressed: () async {
                    final deleted = await context
                        .read<NotificationCubit>()
                        .deleteNotification(notifications[index].id);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.surfaceContainer,
                        content: Text(
                          "Reminder deleted successfully!",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        action: SnackBarAction(
                          label: "Undo",
                          onPressed: () {
                            context.read<NotificationCubit>().addNotification(
                              deleted,
                            );
                          },
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.delete_outlined),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
