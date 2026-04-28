import 'dart:developer';
import 'package:dakerni/cubits/notification/notification_cubit.dart';
import 'package:dakerni/models/notification_model.dart';
import 'package:dakerni/utils/constants.dart';
import 'package:dakerni/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class DayList extends StatelessWidget {
  final List<NotificationModel> notifications;
  final bool? isPast;

  const DayList({super.key, required this.notifications, this.isPast = false});

  @override
  Widget build(BuildContext context) {
    if (isPast == true) {
      notifications.sort((a, b) => b.scheduledDate.compareTo(a.scheduledDate));
    } else {
      notifications.sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
    }

    if (notifications.isEmpty && isPast == true) {
      return Center(
        child: Text(
          "No reminders for this day!",
          style: GoogleFonts.inter(
            fontSize: 16,
            color: colorScheme.secondary.withValues(alpha: 0.6),
          ),
        ),
      );
    }
    return Column(
      children: [
        ListView.builder(
          itemCount: notifications.length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            if (index >= notifications.length) return SizedBox.shrink();
            final notification = notifications[index];
            log(
              "Noifications: ${notification.content} at ${notification.scheduledDate.toIso8601String()}",
            );
            return Opacity(
              opacity: isPast == true ? 0.6 : 1.0,
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer.withAlpha(30),
                  border: Border(
                    left: BorderSide(color: colorScheme.primary, width: 1),
                  ),
                ),
                child: ListTile(
                  title: Text.rich(
                    TextSpan(
                      text: formateTime(notification.scheduledDate),
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.primary,
                      ),
                      children: [
                        TextSpan(
                          text: " / Daily",
                          style: TextStyle(fontSize: 14, color: Colors.white24),
                        ),
                      ],
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      notification.content,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        color: colorScheme.secondary,
                      ),
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () async {
                      final cubit = context.read<NotificationCubit>();
                      final messenger = ScaffoldMessenger.of(context);
                      try {
                        final deleted = await cubit.deleteNotification(
                          notification.id,
                        );
                        messenger.showSnackBar(
                          SnackBar(
                            backgroundColor: colorScheme.surfaceContainer,
                            content: Text(
                              "Reminder deleted successfully!",
                              style: TextStyle(color: colorScheme.onSurface),
                            ),
                            action: SnackBarAction(
                              label: "Undo",
                              onPressed: () async {
                                try {
                                  await cubit.addNotification(deleted);
                                  messenger.hideCurrentSnackBar();
                                  messenger.showSnackBar(
                                    SnackBar(
                                      backgroundColor:
                                          colorScheme.surfaceContainer,
                                      content: Text(
                                        "Reminder restored successfully!",
                                        style: TextStyle(
                                          color: colorScheme.onSurface,
                                        ),
                                      ),
                                    ),
                                  );
                                  return;
                                } catch (e) {
                                  messenger.hideCurrentSnackBar();
                                  messenger.showSnackBar(
                                    SnackBar(
                                      backgroundColor:
                                          colorScheme.errorContainer,
                                      content: Text(
                                        "Failed to restore reminder: $e",
                                        style: TextStyle(
                                          color: colorScheme.onErrorContainer,
                                        ),
                                      ),
                                      action: SnackBarAction(
                                        label: "Retry",
                                        onPressed: () async {
                                          try {
                                            await cubit.addNotification(
                                              deleted,
                                            );
                                            messenger.showSnackBar(
                                              SnackBar(
                                                backgroundColor: colorScheme
                                                    .surfaceContainer,
                                                content: Text(
                                                  "Reminder restored successfully!",
                                                  style: TextStyle(
                                                    color:
                                                        colorScheme.onSurface,
                                                  ),
                                                ),
                                              ),
                                            );
                                          } catch (e) {
                                            messenger.hideCurrentSnackBar();
                                            messenger.showSnackBar(
                                              SnackBar(
                                                backgroundColor:
                                                    colorScheme.errorContainer,
                                                content: Text(
                                                  "Failed to restore reminder: $e",
                                                  style: TextStyle(
                                                    color: colorScheme
                                                        .onErrorContainer,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      } catch (e) {
                        messenger.showSnackBar(
                          SnackBar(
                            backgroundColor: colorScheme.errorContainer,
                            content: Text(
                              "Failed to delete reminder: $e",
                              style: TextStyle(
                                color: colorScheme.onErrorContainer,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    icon: Icon(Icons.delete_outlined),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
