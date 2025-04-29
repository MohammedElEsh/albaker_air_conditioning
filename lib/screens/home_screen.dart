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

  /// Loads the user's name from the profile API
  Future<void> _loadUserName() async {
    try {
      final response = await _userService.getProfile();
      if (response.statusCode == 200) {
        setState(() {
          _userName = response.data['data']['f_name'] ?? 'Guest';
        });
      }
    } catch (e) {
      // Log error silently or handle as needed
      // Consider showing a snackbar for user feedback in production
    }
  }

  /// Loads categories from the home API
  Future<void> _loadCategories() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final response = await _homeService.getHomeData();
      if (response.statusCode == 200) {
        setState(() {
          _categories = response.data['data']['categories'] ?? [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Log error or show user feedback
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
              // Header with profile, search, and greeting
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
              const SizedBox(height: 40),

              // GridView for displaying categories (indices 2, 3, 4, 5, 6, 8)
              Expanded(
                child:
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _categories.length < 9
                        ? const Center(
                          child: Text(
                            'غير كافٍ لعرض البيانات',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                        )
                        : GridView.builder(
                          padding: const EdgeInsets.all(20),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.0,
                              ),
                          itemCount: 6, // Display exactly 6 items
                          itemBuilder: (context, index) {
                            // Map display index to desired category indices
                            final categoryIndices = [2, 4, 5, 7, 9, 11];
                            final categoryIndex = categoryIndices[index];

                            // Ensure the index is valid (though already checked)
                            if (categoryIndex >= _categories.length) {
                              return const SizedBox.shrink();
                            }

                            final category = _categories[categoryIndex];

                            // Convert background color from string to Color
                            final colorString =
                                category['color'] as String? ?? '#1D75B1';
                            final color = Color(
                              int.parse(colorString.replaceFirst('#', '0xFF')),
                            );

                            return Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: color,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Display category image
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:
                                        category['image'] != null
                                            ? Image.network(
                                              'https://albakr-ac.com/${category['image']}',
                                              height: 120,
                                              width: 150,
                                              fit: BoxFit.contain,
                                              errorBuilder:
                                                  (_, __, ___) => const Icon(
                                                    Icons.image_not_supported,
                                                    size: 80,
                                                    color: Colors.white,
                                                  ),
                                            )
                                            : const Icon(
                                              Icons.category,
                                              size: 40,
                                              color: Colors.white,
                                            ),
                                  ),
                                  // Display category name
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      category['name'] ?? 'غير معروف',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
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
