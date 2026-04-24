import 'package:dakerni/models/schedule_model.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart';

class ScheduleService extends ValueNotifier<ScheduleModel> {
  ScheduleService(super.schedule);

  void updateTime(TimeOfDay time) {
    value = value.copyWith(timeOfDay: time);
  }

  void updateDate(DateTime date) {
    value = value.copyWith(dateTime: date);
  }

  TZDateTime get scheduledDate => value.scheduledDate;

  DateTime? get selectedDate => value.dateTime;
  TimeOfDay? get selectedTime => value.timeOfDay;
}
