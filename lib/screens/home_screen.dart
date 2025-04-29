import 'package:flutter/material.dart';
import 'search_screen.dart';
import 'profile_screen.dart';
import '../services/user_service.dart';
import '../services/home_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserService _userService = UserService();
  final HomeService _homeService = HomeService();
  String _userName = '';
  List<dynamic> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadCategories();
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

  Future<void> _loadCategories() async {
    try {
      setState(() {
        _isLoading = true;
      });
      var response = await _homeService.getHomeData();
      if (response.statusCode == 200) {
        setState(() {
          _categories = response.data['data']['categories'] ?? [];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading categories: $e');
    }
  }

  // Function to convert hex color string to Color
  Color getColorFromHex(String? hexColor) {
    if (hexColor == null) return const Color(0xFF1D75B1);

    // Remove '#' if present
    hexColor = hexColor.replaceAll('#', '');

    // Add FF for opacity if the string length is 6
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }

    // Parse hex to int and return Color
    return Color(int.parse('0x$hexColor'));
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

              // Grid of categories from API
              Padding(
                padding: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                  top: 358 - 160,
                ),
                child:
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 177 / 144,
                              ),
                          itemCount:
                              _categories.length > 6 ? 6 : _categories.length,
                          itemBuilder: (context, index) {
                            final category = _categories[index];
                            return Container(
                              width: 177,
                              height: 144,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: getColorFromHex(category['color']),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (category['image'] != null)
                                    Image.network(
                                      category['image'],
                                      width: 60,
                                      height: 60,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return const Icon(
                                          Icons.image_not_supported,
                                          size: 60,
                                          color: Colors.white,
                                        );
                                      },
                                    ),
                                  const SizedBox(height: 10),
                                  Text(
                                    category['name'] ?? '',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
