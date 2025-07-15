import 'package:flutter/material.dart';
import 'package:frontend/features/scan_code/presentation/scan_page.dart';
import 'package:frontend/pages/home_page.dart';
import 'package:frontend/pages/notif_page.dart';
import 'package:frontend/pages/profile_page.dart';
import 'package:frontend/pages/projects_page.dart';
import 'package:frontend/widgets/navbar/navbar.dart';

class NavController extends StatefulWidget {
  const NavController({Key? key}) : super(key: key);

  @override
  State<NavController> createState() => _NavControllerState();
}

class _NavControllerState extends State<NavController> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    const MainPage(key: PageStorageKey('home')),
    const NotifPage(key: PageStorageKey('notif')),
    const ScanPage(key: PageStorageKey('scan')),
    const ProjectsPage(key: PageStorageKey('projects')),
    const ProfilePage(key: PageStorageKey('profile')),
  ];

  @override
  Widget build(BuildContext context) {
    debugPrint("Rendering page: $_currentIndex");
    return Stack(
      children: [
        _pages[_currentIndex],
        if (_currentIndex != 2) // these already have their own Scaffold
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomBottomNavBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
      ],
    );
  }
}
