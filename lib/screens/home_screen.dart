import 'package:flutter/material.dart';
import 'search_screen.dart';
import 'profile_screen.dart';
import '../services/user_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserService _userService = UserService();
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    try {
      var response = await _userService.getProfile();
      if (response.statusCode == 200) {
        setState(() {
          _userName = response.data['data']['f_name'] ?? '';
        });
      }
    } catch (e) {
      print('Error loading profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 60),
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: 33),
                  GestureDetector(
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
                  const SizedBox(width: 10),
                  GestureDetector(
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
                  const Spacer(),
                  SizedBox(
                    width: 162,
                    height: 25,
                    child: Text(
                      "مرحبا، $_userName",
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        height: 1.0,
                        letterSpacing: 0,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(width: 33),
                ],
              ),
              const SizedBox(height: 100),
              // 3x3 grid of rectangles
              GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.only(left: 219, top: 358),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Container(
                    width: 177,
                    height: 144,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Rectangle ${index + 1}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
