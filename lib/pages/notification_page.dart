import 'dart:developer';

import 'package:dakerni/cubits/notification/notification_cubit.dart';
import 'package:dakerni/models/notification_model.dart';
import 'package:dakerni/widgets/day_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.errorMessage != null) {
          return Center(child: Text('Error: ${state.errorMessage}'));
        }
        if (state.notifications.isEmpty) {
          return const Center(child: Text('No notifications yet.'));
        }
        final Map<DateTime, List<NotificationModel>> groupedNotifs = {};

        for (var notif in state.notifications) {
          if (groupedNotifs.containsKey(
            DateTime(
              notif.scheduledDate.year,
              notif.scheduledDate.month,
              notif.scheduledDate.day,
            ),
          )) {
            groupedNotifs[DateTime(
                  notif.scheduledDate.year,
                  notif.scheduledDate.month,
                  notif.scheduledDate.day,
                )]!
                .add(notif);
          } else {
            groupedNotifs[DateTime(
              notif.scheduledDate.year,
              notif.scheduledDate.month,
              notif.scheduledDate.day,
            )] = [
              notif,
            ];
          }
        }
        log(" Grouped notifications: $groupedNotifs groups");
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: ListView(
            children: groupedNotifs.entries.map((entry) {
              final sorted = entry.value
                ..sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: DayList(notifications: sorted),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
