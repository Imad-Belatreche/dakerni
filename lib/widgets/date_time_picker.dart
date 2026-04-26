import 'package:dakerni/services/schedule_service.dart';
import 'package:dakerni/utils/constants.dart';
import 'package:flutter/material.dart';

class DateTimePicker extends StatefulWidget {
  final ScheduleService scheduleService;
  const DateTimePicker({super.key, required this.scheduleService});

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.scheduleService,
      builder: (context, value, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(
                  width: 110,
                  child: Card(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      splashFactory: NoSplash.splashFactory,
                      highlightColor: colorScheme.primary.withAlpha(150),
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (picked != null) {
                          widget.scheduleService.updateTime(picked);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Center(
                          child: Text(
                            value.timeOfDay != null
                                ? value.timeOfDay!.format(context)
                                : "Pick a time",
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  "Select time",
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withAlpha(190),
                  ),
                ),
              ],
            ),

            Text(
              "Remind me at",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                SizedBox(
                  width: 110,
                  child: Card(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      splashFactory: NoSplash.splashFactory,
                      highlightColor: colorScheme.primary.withAlpha(150),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 1000)),
                        );
                        if (picked != null) {
                          widget.scheduleService.updateDate(picked);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Center(
                          child: Text(
                            value.dateTime != null
                                ? value.dateTime!.toString().split(' ')[0]
                                : "Pick a date (default: today)",
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  "Select date",
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withAlpha(190),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
