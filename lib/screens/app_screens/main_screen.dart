/// The main screen of the application that manages navigation between different sections.
///
/// Features:
/// - Bottom navigation using custom navbar
/// - Screen state management
/// - IndexedStack for efficient screen switching
/// - SafeArea for proper layout
///
/// The screen manages:
/// - Home screen (index 4)
/// - Cart screen (index 3)
/// - Projects screen (index 2)
/// - Works screen (index 1)
/// - More screen (index 0)
import 'package:flutter/material.dart';

// Import all screens from the same directory
import 'home_screen.dart';
import 'cart_screen.dart';
import 'projects_screen.dart';
import 'works_screen.dart';
import 'more_screen.dart';
import '../../widgets/custom_navbar.dart';

/// Main screen widget that handles navigation between different sections of the app.
///
/// This screen uses a custom bottom navigation bar and IndexedStack
/// to efficiently manage and switch between different screens.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  /// Index of the currently selected screen in the navigation bar
  /// Default is 4 (Home screen)
  int _selectedIndex = 4;

  /// List of all available screens in the app
  /// Ordered from left to right in the navigation bar
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
          // Handle navigation bar tap notifications
          onNotification: (notification) {
            setState(() {
              _selectedIndex = notification.index;
            });
            return true; // Stop notification propagation
          },
          child: Stack(
            children: [
              // Main content area using IndexedStack for efficient screen switching
              IndexedStack(index: _selectedIndex, children: _screens),

              // Custom navigation bar at the bottom
              const CustomNavbar(),
            ],
          ),
        ),
      ),
    );
  }
}
