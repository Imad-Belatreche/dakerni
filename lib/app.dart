import 'package:dakerni/pages/home_page.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const cyberRed = Color.fromARGB(255, 171, 0, 0);
    const deepBlack = Color.fromARGB(255, 20, 0, 0);
    const pureWhite = Colors.white;

    return MaterialApp(
      title: 'Dakerni',
      theme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(
          centerTitle: true,
          shadowColor: Theme.of(
            context,
          ).colorScheme.surface.withValues(alpha: 0.2),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
          primary: cyberRed,
          onPrimary: pureWhite,
          secondary: pureWhite,
          onSecondary: deepBlack,
          surface: deepBlack,
          onSurface: pureWhite,
          seedColor: const Color.fromARGB(255, 61, 0, 1),
          brightness: Brightness.dark,
        ),
      ),
      home: const HomePage(),
    );
  }
}
