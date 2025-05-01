import 'package:flutter/material.dart';

// Import all screens from the same directory
import 'home_screen.dart';
import 'cart_screen.dart';
import 'projects_screen.dart';
import 'works_screen.dart';
import 'more_screen.dart';
import '../../widgets/custom_navbar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 4; // Default to home (index 4)

  // List of all screens
  final List<Widget> _screens = [
    const MoreScreen(), // 0
    const WorksScreen(), // 1
    const ProjectsScreen(), // 2
    const CartScreen(), // 3
    const HomeScreen(), // 4
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: NotificationListener<NavbarTapNotification>(
          onNotification: (notification) {
            setState(() {
              _selectedIndex = notification.index;
            });
            return true; // Stop notification propagation
          },
          child: Stack(
            children: [
              // Main content area
              IndexedStack(index: _selectedIndex, children: _screens),

              // Custom navbar at the bottom
              const CustomNavbar(),
            ],
          ),
        ),
      ),
    );
  }
}
