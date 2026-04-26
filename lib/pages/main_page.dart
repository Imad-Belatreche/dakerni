import 'package:dakerni/cubits/notification/notification_cubit.dart';
import 'package:dakerni/pages/home_page.dart';
import 'package:dakerni/pages/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final NotificationCubit _notificationCubit;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _notificationCubit = context.read<NotificationCubit>();
    _notificationCubit.loadNotifications();
  }

  Widget _buildPage() {
    if (_selectedIndex == 0) {
      return const HomePage(key: ValueKey('main'));
    }
    return NotificationPage(key: ValueKey('notifications'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 420),
          reverseDuration: const Duration(milliseconds: 320),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -0.5),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: Text(
            _selectedIndex == 0 ? 'Home Page' : 'Notifications',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            key: ValueKey(_selectedIndex),
          ),
        ),
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 420),
          reverseDuration: const Duration(milliseconds: 320),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          layoutBuilder: (currentChild, previousChildren) {
            return Stack(
              alignment: Alignment.center,
              children: <Widget>[...previousChildren, ?currentChild],
            );
          },
          transitionBuilder: (child, animation) {
            final fadeAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            );
            final slideAnimation = Tween<Offset>(
              begin: const Offset(-0.9, 0),
              end: Offset.zero,
            ).animate(animation);

            final scaleAnimation = Tween<double>(
              begin: 0.98,
              end: 1.0,
            ).animate(fadeAnimation);

            return FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: slideAnimation,
                child: ScaleTransition(scale: scaleAnimation, child: child),
              ),
            );
          },
          child: _buildPage(),
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          elevation: 10,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
          ],
        ),
      ),
    );
  }
}
