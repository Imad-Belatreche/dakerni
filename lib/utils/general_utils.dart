import 'package:flutter/material.dart';

bool isFutureDateTime(DateTime selectedDate, TimeOfDay selectedTime) {
  final now = DateTime.now();

  final finalDateTime = DateTime(
    selectedDate.year,
    selectedDate.month,
    selectedDate.day,
    selectedTime.hour,
    selectedTime.minute,
  );

  return finalDateTime.isAfter(now);
}
