import 'package:flutter/material.dart';

class DateTimePicker extends StatefulWidget {
  const DateTimePicker({super.key});

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  DateTime? pickedDate = DateTime.now();
  TimeOfDay? pickedTime;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            SizedBox(
              width: 110,
              child: Card(
                shadowColor: Theme.of(context).colorScheme.surface,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  splashFactory: NoSplash.splashFactory,
                  highlightColor: Theme.of(
                    context,
                  ).colorScheme.primary.withAlpha(150),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) {
                      pickedTime = picked;
                      setState(() {});
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: Text(
                        pickedTime != null
                            ? pickedTime!.format(context)
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
                color: Theme.of(context).colorScheme.onSurface.withAlpha(190),
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
                shadowColor: Theme.of(context).colorScheme.surface,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  splashFactory: NoSplash.splashFactory,
                  highlightColor: Theme.of(
                    context,
                  ).colorScheme.primary.withAlpha(150),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                    );
                    if (picked != null) {
                      pickedDate = picked;
                      setState(() {});
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: Text(
                        pickedDate != null
                            ? pickedDate!.toString().split(' ')[0]
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
                color: Theme.of(context).colorScheme.onSurface.withAlpha(190),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
