import 'dart:developer';
import 'dart:math' hide log;

import 'package:dakerni/cubits/notification/notification_cubit.dart';
import 'package:dakerni/models/notification_model.dart';
import 'package:dakerni/models/schedule_model.dart';
import 'package:dakerni/services/notificatio_service.dart';
import 'package:dakerni/services/schedule_service.dart';
import 'package:dakerni/utils/general_utils.dart';
import 'package:dakerni/widgets/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textController = TextEditingController();
  final ScheduleService _scheduleService = ScheduleService(
    ScheduleModel(dateTime: DateTime.now()),
  );
  late final NotificationCubit _notificationCubit;

  @override
  void initState() {
    super.initState();
    _notificationCubit = context.read<NotificationCubit>();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Welcome to Dakerni!',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text('What do you want to remember?', style: TextStyle(fontSize: 16)),
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.multiline,
              controller: _textController,
              maxLines: 3,
              minLines: 1,
              decoration: InputDecoration(
                hintText: 'Type something...',
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                fillColor: Theme.of(
                  context,
                ).colorScheme.surfaceBright.withAlpha(100),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 12,
                ),
              ),
            ),
          ),
          SizedBox(height: 14),
          DateTimePicker(scheduleService: _scheduleService),
          SizedBox(height: 36),
          ElevatedButton(
            onPressed: () async {
              final text = _textController.text.trim();
              try {
                final isGranted = await NotificationService.instance
                    .requestNotificationPermission(context);
                if (isGranted == null || !isGranted) return;

                await NotificationService.instance
                    .requestExactAlarmPermission();
                if (!context.mounted) return;
                if (_scheduleService.selectedTime == null ||
                    _scheduleService.selectedDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 4),
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.surfaceContainer,
                      content: Text(
                        "Please select a date and time for the reminder.",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  );
                  return;
                }
                if (!isFutureDateTime(
                  _scheduleService.selectedDate!,
                  _scheduleService.selectedTime!,
                )) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      duration: Duration(seconds: 4),
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.surfaceContainer,
                      content: Text(
                        "Please select a future date and time for the reminder.",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                  );
                  return;
                }

                final NotificationModel notification = NotificationModel(
                  content: text.isEmpty
                      ? "You didn't type anything, but I will remind you anyway."
                      : text,
                  scheduledDate: _scheduleService.scheduledDate,
                );
                log(
                  "Scheduling notification: ${notification.id.clamp(-pow(2, 31), pow(2, 31) - 1)} at ${notification.scheduledDate} with content: ${notification.content}",
                );

                await NotificationService.instance.scheduleReminder(
                  id: notification.id
                      .clamp(-pow(2, 31), pow(2, 31) - 1)
                      .toInt(),
                  title: "Remember",
                  body: text.isEmpty
                      ? "You didn't type anything, but I will remind you anyway."
                      : text,
                  scheduledDate: _scheduleService.scheduledDate,
                );

                await _notificationCubit.addNotification(notification);

                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: text.length > 20 ? 4 : 2),
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainer,
                    content: Text.rich(
                      TextSpan(
                        text: "Remind me to ",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        children: [
                          TextSpan(
                            text: text.isEmpty ? "type something" : "\"$text\"",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          TextSpan(
                            text:
                                "\n at ${_scheduleService.selectedDate.toString().split(' ')[0]} ${_scheduleService.selectedTime!.format(context)}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                );
              } catch (e) {
                log("Error scheduling notification: $e");
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: text.length > 20 ? 6 : 3),
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainer,
                    content: Text.rich(
                      TextSpan(
                        text: "Failed to schedule notification: ",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        children: [
                          TextSpan(
                            text: e.toString(),
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text('Add notification', style: TextStyle(fontSize: 17)),
          ),
        ],
      ),
    );
  }
}
