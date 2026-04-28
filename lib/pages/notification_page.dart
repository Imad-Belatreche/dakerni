import 'package:dakerni/cubits/notification/notification_cubit.dart';
import 'package:dakerni/models/notification_model.dart';
import 'package:dakerni/pages/create_task_page.dart';
import 'package:dakerni/utils/constants.dart';
import 'package:dakerni/widgets/daily_card.dart';
import 'package:dakerni/widgets/day_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int threshold = -3;
  int _selectedIndex = 0;
  DateTime now = DateTime.now();
  DateTime get selectedDate => now.copyWith(day: now.day + _selectedIndex);

  late final NotificationCubit _notificationCubit;

  @override
  void initState() {
    super.initState();
    _notificationCubit = context.read<NotificationCubit>();
    _notificationCubit.loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(thickness: 0.5, color: Colors.white10, height: 10),
        ),

        title: Text.rich(
          style: GoogleFonts.orbitron(fontSize: 25, letterSpacing: 2.5),
          TextSpan(
            text: 'N',
            children: [
              TextSpan(text: "eur", style: TextStyle(fontSize: 18)),
              TextSpan(
                text: 'T',
                style: TextStyle(color: colorScheme.primary, fontSize: 25),
              ),
              TextSpan(
                text: 'isk',
                style: TextStyle(color: colorScheme.primary, fontSize: 20),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              //TODO: Add Theme color change functionality
            },
            icon: Icon(
              Icons.color_lens_outlined,
              size: 25,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 80,

              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (context, index) {
                  index += threshold;
                  return DailyCalendarCard(
                    isSelected: index == _selectedIndex,
                    dateTime: now.copyWith(day: now.day + index),
                    index: index,
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                  );
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<NotificationCubit, NotificationState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return CircularProgressIndicator();
                  }
                  if (state.errorMessage != null) {
                    return Text('Error: ${state.errorMessage}');
                  }
                  if (state.notifications.isEmpty) {
                    return Text('No notifications yet.');
                  }

                  final groupedNotifs = <DateTime, List<NotificationModel>>{};
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

                  List<NotificationModel> notificationsForSelectedDate =
                      groupedNotifs[DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                      )] ??
                      [];

                  List<NotificationModel> activeNotifications =
                      notificationsForSelectedDate
                          .where((n) => n.isActive)
                          .toList();

                  List<NotificationModel> pastNotifications =
                      notificationsForSelectedDate
                          .where((n) => !n.isActive)
                          .toList();

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'NEURAL TASKS',
                                style: GoogleFonts.bungee(
                                  fontSize: 12,
                                  letterSpacing: 1.2,
                                  color: Colors.white24,
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  thickness: 0.5,
                                  color: Colors.white10,
                                  indent: 12,
                                  endIndent: 12,
                                ),
                              ),
                              Text(
                                notificationsForSelectedDate.isNotEmpty
                                    ? "Active (${notificationsForSelectedDate.where((element) => element.scheduledDate.isAfter(DateTime.now())).length})"
                                    : "",
                                style: GoogleFonts.bungee(
                                  fontSize: 12,
                                  letterSpacing: 1.2,
                                  color: Colors.white24,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          DayList(notifications: activeNotifications),
                          SizedBox(height: 12),
                          DayList(
                            notifications: pastNotifications,
                            isPast: true,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Spacer(),
            Divider(thickness: 0.5, color: Colors.white10),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 12.0,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.inverseSurface,
                  foregroundColor: colorScheme.onInverseSurface,
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  final parentCubit = context.read<NotificationCubit>();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: parentCubit,
                        child: CreateTaskPage(),
                      ),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 20, fontWeight: FontWeight.bold),
                    SizedBox(width: 8),
                    Text(
                      'NEW TASKING',
                      style: GoogleFonts.bungee(
                        fontSize: 15,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
