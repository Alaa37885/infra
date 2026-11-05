import 'package:flutter/material.dart';
import 'package:inframind/features/road_issues/domain/entities/road_issue.dart';
import 'package:inframind/features/road_issues/domain/usecases/get_road_issues.dart';
import 'package:inframind/theme/app_theme.dart';
import 'package:inframind/screens/home_screen.dart';
import 'package:inframind/screens/live_detection_screen.dart';
import 'package:inframind/screens/map_screen.dart';
import 'package:inframind/screens/reports_screen.dart';
import 'package:inframind/screens/settings_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key, required this.getRoadIssues});

  final GetRoadIssues getRoadIssues;

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  late final Future<List<RoadIssue>> _roadIssues;

  @override
  void initState() {
    super.initState();
    _roadIssues = widget.getRoadIssues();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(onNavigateTab: _onTabTapped, roadIssues: _roadIssues),
      const LiveDetectionScreen(),
      MapScreen(roadIssues: _roadIssues),
      ReportsScreen(roadIssues: _roadIssues),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.surfaceGlassBorder, width: 1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: AppColors.gold,
          unselectedItemColor: AppColors.textGray,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_rounded),
              label: 'لايف',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_rounded),
              label: 'الخريطة',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_rounded),
              label: 'التقارير',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
              label: 'الإعدادات',
            ),
          ],
        ),
      ),
    );
  }
}
