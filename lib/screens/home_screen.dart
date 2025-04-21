import 'package:flutter/material.dart';
import 'search_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Profile Button
            Positioned(
              top: 67,
              left: 33,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
                child: Container(
                  width: 41,
                  height: 41,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(27),
                    color: const Color(0xFF1D75B1),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/user.png',
                      width: 21,
                      height: 21,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            // Search Button
            Positioned(
              top: 67,
              left: 84,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchScreen(),
                    ),
                  );
                },
                child: Container(
                  width: 41,
                  height: 41,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0x451D75B1),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(27),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/search-normal_broken.png',
                      width: 21,
                      height: 21,
                      color: const Color(0xFF1D75B1),
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Navigation Bar Container
            Positioned(
              bottom: 0,
              left: -1,
              child: Container(
                width: 460,
                height: 107,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(17),
                    topRight: Radius.circular(17),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x0F000000),
                      blurRadius: 60,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Center(
                    child: SizedBox(
                      width: 320,
                      height: 80,
                      child: Stack(
                        children: [
                          // Add bottom nav icons here
                          // Example:
                          // Positioned(...),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
