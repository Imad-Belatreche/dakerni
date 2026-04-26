import 'package:dakerni/cubits/notification/notification_cubit.dart';
import 'package:dakerni/pages/main_page.dart';
import 'package:dakerni/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dakerni',
      theme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          centerTitle: true,
          shadowColor: Theme.of(
            context,
          ).colorScheme.surface.withValues(alpha: 0.2),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        cardTheme: CardThemeData(
          shadowColor: colorScheme.surface,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: colorScheme.surface,
        ),
        colorScheme: colorScheme,
      ),
      home: BlocProvider(
        create: (context) => NotificationCubit(),
        child: const MainPage(),
      ),
    );
  }
}
