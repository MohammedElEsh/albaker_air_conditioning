/// The home screen of the application that serves as the main dashboard.
///
/// Features:
/// - User profile information display
/// - Image slider with promotional content
/// - Category grid for product navigation
/// - Search functionality
/// - Profile access
/// - Arabic language support
///
/// The screen includes:
/// - Welcome message with user's name
/// - Image slider with overlay text
/// - Category grid with icons and labels
/// - Search and profile buttons
/// - Loading states and error handling
// Flutter imports
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

// App-specific imports
import 'search_screen.dart';
import 'profile_screen.dart';
import '../../services/user_service.dart';
import '../../services/home_service.dart';

/// Home screen widget that serves as the main dashboard of the application.
///
/// This screen implements:
/// - User profile integration
/// - Dynamic content loading
/// - Image slider with caching
/// - Category navigation
/// - Search and profile access
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Service for user-related operations
  final UserService _userService = UserService();

  /// Service for home screen data
  final HomeService _homeService = HomeService();

  /// State variables
  String _userName = ''; // Stores the user name
  List<dynamic> _categories = []; // Stores category data
  List<dynamic> _sliderImages = []; // Stores slider image data
  bool _isLoading = true; // Loading flag
  int _currentSliderPage = 0; // Tracks current slider index
  final PageController _sliderController =
      PageController(); // Page controller for slider

  @override
  void initState() {
    super.initState();
    _loadUserName(); // Load user data
    _loadCategories(); // Load category data
    _loadSliderImages(); // Load image slider data
  }

  @override
  void dispose() {
    _sliderController.dispose(); // Dispose slider controller
    super.dispose();
  }

  /// Loads the user's name from their profile.
  ///
  /// If the user is not logged in or the API call fails,
  /// sets the name to 'زائر' (Guest).
  Future<void> _loadUserName() async {
    try {
      final token = await _userService.getToken();
      if (token == null || token.isEmpty) {
        setState(() {
          _userName = 'زائر';
        });
        return;
      }

      final response = await _userService.getProfile();
      if (response.statusCode == 200) {
        setState(() {
          _userName = response.data['data']['f_name'] ?? 'زائر';
        });
      }
    } catch (e) {
      setState(() {
        _userName = 'زائر';
      });
      // Handle error
    }
  }

  /// Loads slider images from the home API.
  ///
  /// Requires a valid authentication token.
  /// Updates the slider images state with the API response data.
  Future<void> _loadSliderImages() async {
    try {
      final token = await _userService.getToken();
      if (token == null || token.isEmpty) {
        return; // Cannot load data without token
      }

      final response = await _homeService.getHomeSlider();
      if (response.statusCode == 200) {
        setState(() {
          _sliderImages = response.data['data'] ?? [];
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  /// Loads category data from the home API.
  ///
  /// Requires a valid authentication token.
  /// Updates the categories state and loading flag.
  /// Handles loading states and error cases.
  Future<void> _loadCategories() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final token = await _userService.getToken();
      if (token == null || token.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        // Show error message to user if needed
        return;
      }

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
      // Handle error
    }
  }

  /// Builds the image slider widget with overlay text.
  ///
  /// Returns:
  /// - A placeholder container if no images are loaded
  /// - A PageView with cached images, gradient overlay, and text if images are available
  Widget _buildImageSlider() {
    if (_sliderImages.isEmpty) {
      // Placeholder while loading
      return Container(
        width: 400,
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(38),
          color: Colors.grey[300],
        ),
        child: const Center(
          child: Text(
            'جاري تحميل الصور',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    // Slider widget
    return SizedBox(
      width: 400,
      height: 250,
      child: Stack(
        children: [
          // PageView for image swiping
          PageView.builder(
            controller: _sliderController,
            itemCount: _sliderImages.length,
            onPageChanged: (index) {
              setState(() {
                _currentSliderPage = index;
              });
            },
            itemBuilder: (context, index) {
              final imageUrl = _sliderImages[index]['image'] ?? '';
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(38),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Cached image from network
                    CachedNetworkImage(
                      imageUrl: 'https://albakr-ac.com/${imageUrl}',
                      fit: BoxFit.cover,
                      errorWidget:
                          (context, url, error) => Container(
                            color: const Color(0xFF1D75B1).withOpacity(0.2),
                            child: const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      placeholder:
                          (context, url) => const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF1D75B1),
                            ),
                          ),
                    ),

                    // Gradient overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(0.6),
                          ],
                        ),
                      ),
                    ),

                    // Overlay text
                    Positioned(
                      bottom: 50,
                      right: 20,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'كل ما تحتاجه من مكيفات',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                              height: 1.2,
                              shadows: [
                                Shadow(
                                  blurRadius: 3.0,
                                  color: Colors.black54,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          const SizedBox(
                            width: 220,
                            child: Text(
                              'أصبح سهلا الآن وبين يديك فقط أطلب ما تحتاجه ونصله إليك',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                height: 1.2,
                                shadows: [
                                  Shadow(
                                    blurRadius: 3.0,
                                    color: Colors.black54,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Page indicator dots
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _sliderImages.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        _currentSliderPage == index
                            ? const Color(0xFF1D75B1)
                            : Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Pull to refresh data
  Future<void> _refreshData() async {
    await Future.wait([
      _loadUserName(),
      _loadSliderImages(),
      _loadCategories(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 60),
              // Header: profile button, search, user greeting
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 33),
                child: Row(
                  children: [
                    // Profile icon button
                    GestureDetector(
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen(),
                            ),
                          ),
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
                    // Search icon button
                    GestureDetector(
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SearchScreen(),
                            ),
                          ),
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
                    // Greeting text
                    Text(
                      "مرحبا، $_userName",
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Slider Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 33),
                child: _buildImageSlider(),
              ),

              const SizedBox(height: 20),

              // Categories Grid or Loading/Empty message
              _isLoading
                  ? const SizedBox(
                    height: 400,
                    child: Center(child: CircularProgressIndicator()),
                  )
                  : _categories.length < 9
                  ? const SizedBox(
                    height: 400,
                    child: Center(
                      child: Text(
                        'غير كافٍ لعرض البيانات',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )
                  : Padding(
                    padding: const EdgeInsets.all(20),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.0,
                          ),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        if (index >= _categories.length) {
                          return const SizedBox.shrink();
                          // Gracefully handle index out of bounds
                        }

                        final category = _categories[index];
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    category['image'] != null
                                        ? CachedNetworkImage(
                                          imageUrl:
                                              'https://albakr-ac.com/'
                                              '${category['image']}',
                                          height: 120,
                                          width: 200,
                                          fit: BoxFit.contain,
                                          errorWidget:
                                              (context, url, error) =>
                                                  const Icon(
                                                    Icons.image_not_supported,
                                                    size: 80,
                                                    color: Colors.white,
                                                  ),
                                          placeholder:
                                              (context, url) => const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                        )
                                        : const Icon(
                                          Icons.category,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  category['name'] ?? 'غير معروف',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

              // Add space at the bottom for the navbar
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
