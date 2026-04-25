import 'package:dakerni/models/schedule_model.dart';
import 'package:dakerni/services/notificatio_service.dart';
import 'package:dakerni/services/schedule_service.dart';
import 'package:dakerni/widgets/date_time_picker.dart';
import 'package:flutter/material.dart';

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
  int _notificationId = 0;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Welcome to Dakerni!',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'What do you want to remember?',
              style: TextStyle(fontSize: 16),
            ),
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
                //TODO: Show snackbars or toasts later
                final text = _textController.text.trim();
                final isGranted = await NotificationService.instance
                    .requestNotificationPermission(context);
                if (isGranted == null || !isGranted) return;

                await NotificationService.instance
                    .requestExactAlarmPermission();

                await NotificationService.instance.scheduleReminder(
                  id: _notificationId++,
                  title: "Remember",
                  body: text.isEmpty
                      ? "You didn't type anything, but I will still remind you."
                      : text,
                  scheduledDate: _scheduleService.scheduledDate,
                );
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
      ),
    );
  }
}
