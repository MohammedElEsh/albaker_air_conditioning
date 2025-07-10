import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:al_baker_air_conditioning/utils/alert_utils.dart';

// App-specific imports
import 'search_screen.dart';
import 'product_details_screen.dart';
import 'profile_screen.dart';
import 'product_list_screen.dart'; // Import the new ProductListScreen
import '../../services/user_service.dart';
import '../../services/home_service.dart';
import '../../services/cart_service.dart'; // Added for CartService
import '../../services/products_service.dart'; // Import ProductService

// Product model to parse best-seller API response
class Product {
  final int id;
  final String name;
  final String price;
  final String description;
  final String mainImage;
  final String brandName;
  final String? brandImage;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.mainImage,
    required this.brandName,
    this.brandImage,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'غير معروف',
      price: json['price'] ?? '0.00',
      description: json['description'] ?? '',
      mainImage: json['main_image'] ?? '',
      brandName: json['brand']?['name'] ?? 'غير معروف',
      brandImage: json['brand']?['image'],
    );
  }
}

/// Home screen widget that serves as the main dashboard of the application.
///
/// This screen implements:
/// - User profile integration
/// - Dynamic content loading
/// - Image slider with caching
/// - Category navigation
/// - Best seller products display
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

  /// Service for cart operations
  final CartService _cartService =
      CartService(); // Added for cart functionality

  /// Service for product operations
  final ProductService _productService =
      ProductService(); // Add this line to your state class

  /// State variables
  String _userName = ''; // Stores the user name
  List<dynamic> _categories = []; // Stores category data
  List<dynamic> _sliderImages = []; // Stores slider image data
  List<Product> _bestSellers = []; // Stores best-seller products
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
    _loadBestSellers(); // Load best seller products
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
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error
    }
  }

  /// Loads best seller products from the home API.
  ///
  /// Requires a valid authentication token.
  /// Updates the best sellers state and loading flag.
  /// Handles loading states and error cases.
  Future<void> _loadBestSellers() async {
    try {
      final token = await _userService.getToken();
      if (token == null || token.isEmpty) {
        return; // Cannot load data without token
      }

      final response = await _homeService.getBestSellerProducts();
      if (response.statusCode == 200) {
        setState(() {
          _bestSellers =
              (response.data['data']['data'] as List)
                  .map((json) => Product.fromJson(json))
                  .toList();
        });
      }
    } catch (e) {
      setState(() {
        _bestSellers = [];
      });
      // Handle error
    }
  }

  /// Adds a product to the cart.
  Future<void> _addToCart(int productId) async {
    try {
      final token = await _cartService.getToken();
      if (token == null || token.isEmpty) {
        AlertUtils.showErrorAlert(
          context,
          'خطأ في التسجيل',
          'يرجى تسجيل الدخول لإضافة المنتج إلى العربة',
        );
        return;
      }

      final response = await _cartService.addProductToCart(
        productId: productId,
        quantity: 1,
        addId: 0,
      );

      if (response.statusCode == 200) {
        AlertUtils.showSuccessAlert(
          context,
          'تمت الإضافة',
          'تمت إضافة المنتج إلى العربة بنجاح',
        );
      } else {
        AlertUtils.showErrorAlert(
          context,
          'خطأ في الإضافة',
          'فشل إضافة المنتج إلى العربة، يرجى المحاولة مرة أخرى',
        );
      }
    } catch (e) {
      AlertUtils.showErrorAlert(
        context,
        'خطأ غير متوقع',
        'حدث خطأ أثناء محاولة إضافة المنتج: ${e.toString()}',
      );
    }
  }

  /// Builds the image slider widget with overlay text.
  /// Returns:
  /// - A placeholder container if no images are loaded
  /// - A PageView with cached images, gradient overlay, and text if images are available
  Widget _buildImageSlider(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    if (_sliderImages.isEmpty) {
      // Placeholder while loading
      return Container(
        width: double.infinity,
        height: screenHeight * 0.3,
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
      width: double.infinity,
      height: screenHeight * 0.3,
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
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
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
                      bottom: screenHeight * 0.06,
                      right: screenWidth * 0.05,
                      left: screenWidth * 0.05,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'كل ما تحتاجه من مكيفات',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: screenWidth * 0.055,
                              height: 1.2,
                              shadows: const [
                                Shadow(
                                  blurRadius: 3.0,
                                  color: Colors.black54,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.1,
                            ),
                            child: Text(
                              'أصبح سهلا الآن وبين يديك فقط أطلب ما تحتاجه ونصله إليك',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: screenWidth * 0.035,
                                height: 1.2,
                                shadows: const [
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
            bottom: screenHeight * 0.025,
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

  /// Builds the best sellers section widget.
  ///
  /// Returns:
  /// - A loading indicator if data is being loaded
  /// - A message if no best sellers are available
  /// - A horizontal scrollable list of best seller products
  Widget _buildBestSellersSection() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    if (_bestSellers.isEmpty) {
      return const SizedBox.shrink(); // Don't show section if no products
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.01,
          ),
          child: Text(
            'المنتجات الأكثر مبيعًا',
            style: TextStyle(
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
            textAlign: TextAlign.right,
          ),
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: SizedBox(
            height: screenHeight * 0.35,
            child: ListView.builder(
              reverse: true,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(
                right: screenWidth * 0.03,
                left: screenWidth * 0.03,
              ),
              itemCount: _bestSellers.length,
              itemBuilder: (context, index) {
                final product = _bestSellers[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                ProductDetailsScreen(productId: product.id),
                      ),
                    );
                  },
                  child: Container(
                    width: screenWidth * 0.5,
                    margin: EdgeInsets.only(
                      left: screenWidth * 0.02,
                      right:
                          index == _bestSellers.length - 1
                              ? screenWidth * 0.02
                              : 0,
                    ),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 3,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: CachedNetworkImage(
                                imageUrl:
                                    'https://albakr-ac.com/${product.mainImage}',
                                fit: BoxFit.cover,
                                placeholder:
                                    (context, url) => const Center(
                                      child: CircularProgressIndicator(
                                        color: Color(0xFF1D75B1),
                                      ),
                                    ),
                                errorWidget:
                                    (context, url, error) => Container(
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.image_not_supported,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.all(screenWidth * 0.02),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    product.name,
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.035,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                    textAlign: TextAlign.right,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    product.description.replaceAll(
                                      '\r\n',
                                      ', ',
                                    ),
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.028,
                                      color: Colors.grey[600],
                                    ),
                                    textAlign: TextAlign.right,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.add_shopping_cart,
                                          size: screenWidth * 0.06,
                                          color: Color(0xFF1D75B1),
                                        ),
                                        onPressed: () => _addToCart(product.id),
                                      ),
                                      if (product.brandImage != null)
                                        CachedNetworkImage(
                                          imageUrl:
                                              'https://albakr-ac.com/${product.brandImage}',
                                          width: screenWidth * 0.08,
                                          height: screenWidth * 0.08,
                                          fit: BoxFit.contain,
                                          placeholder:
                                              (context, url) => SizedBox(
                                                width: screenWidth * 0.08,
                                                height: screenWidth * 0.08,
                                                child:
                                                    const CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Color(0xFF1D75B1),
                                                    ),
                                              ),
                                          errorWidget:
                                              (context, url, error) => Icon(
                                                Icons.image_not_supported,
                                                size: screenWidth * 0.08,
                                                color: Colors.grey,
                                              ),
                                        ),
                                      Text(
                                        '${product.price} ريال',
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.032,
                                          color: Colors.green[600],
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.right,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  /// Pull to refresh data
  Future<void> _refreshData() async {
    await Future.wait([
      _loadUserName(),
      _loadSliderImages(),
      _loadCategories(),
      _loadBestSellers(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.07),
              // Header: profile button, search, user greeting
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
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
                        width: screenWidth * 0.1,
                        height: screenWidth * 0.1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.065,
                          ),
                          color: const Color(0xFF1D75B1),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/images/user.png',
                            width: screenWidth * 0.05,
                            height: screenWidth * 0.05,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.025),
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
                        width: screenWidth * 0.1,
                        height: screenWidth * 0.1,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0x451D75B1),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.065,
                          ),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/images/search-normal_broken.png',
                            width: screenWidth * 0.05,
                            height: screenWidth * 0.05,
                            color: const Color(0xFF1D75B1),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Greeting text
                    Text(
                      "مرحبا، $_userName",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: screenWidth * 0.045,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.025),

              // Slider Section
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.08,
                ),
                child: _buildImageSlider(context),
              ),

              SizedBox(height: screenHeight * 0.025),

              // Categories Grid or Loading/Empty message
              _isLoading
                  ? SizedBox(
                    height: screenHeight * 0.3,
                    child: const Center(child: CircularProgressIndicator()),
                  )
                  : _categories.length < 6
                  ? SizedBox(
                    height: screenHeight * 0.3,
                    child: const Center(
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
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: screenWidth * 0.03,
                        mainAxisSpacing: screenWidth * 0.03,
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

                        return GestureDetector(
                          onTap: () async {
                            final categoryId = category['id'];
                            try {
                              final response = await _productService
                                  .getProductsByCategory(categoryId);
                              if (response.statusCode == 200) {
                                // Navigate to ProductListScreen and pass products and category name
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ProductListScreen(
                                          products:
                                              response.data['data']['data'] ??
                                              [],
                                          categoryName: category['name'] ?? '',
                                          currentPage:
                                              response
                                                  .data['data']['current_page'] ??
                                              1,
                                          lastPage:
                                              response
                                                  .data['data']['last_page'] ??
                                              1,
                                          links:
                                              response.data['data']['links'] ??
                                              [],
                                          categoryId: category['id'],
                                        ),
                                  ),
                                );
                              } else {
                                AlertUtils.showErrorAlert(
                                  context,
                                  'خطأ',
                                  'تعذر تحميل المنتجات',
                                );
                              }
                            } catch (e) {
                              AlertUtils.showErrorAlert(
                                context,
                                'خطأ',
                                'حدث خطأ أثناء تحميل المنتجات',
                              );
                            }
                          },
                          child: Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: color,
                            child: Padding(
                              padding: EdgeInsets.all(screenWidth * 0.02),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    flex: 3,
                                    child:
                                        category['image'] != null
                                            ? CachedNetworkImage(
                                              imageUrl:
                                                  'https://albakr-ac.com/${category['image']}',
                                              height: screenHeight * 0.08,
                                              width: screenWidth * 0.2,
                                              fit: BoxFit.contain,
                                              errorWidget:
                                                  (context, url, error) => Icon(
                                                    Icons.image_not_supported,
                                                    size: screenWidth * 0.12,
                                                    color: Colors.white,
                                                  ),
                                              placeholder:
                                                  (context, url) => SizedBox(
                                                    width: screenWidth * 0.08,
                                                    height: screenWidth * 0.08,
                                                    child:
                                                        const CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          color: Colors.white,
                                                        ),
                                                  ),
                                            )
                                            : Icon(
                                              Icons.category,
                                              size: screenWidth * 0.12,
                                              color: Colors.white,
                                            ),
                                  ),
                                  SizedBox(height: screenHeight * 0.005),
                                  Flexible(
                                    flex: 2,
                                    child: Text(
                                      category['name'] ?? 'غير معروف',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenWidth * 0.035,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

              SizedBox(height: screenHeight * 0.025),

              // Best Sellers Section
              _buildBestSellersSection(),

              // Add space at the bottom for the navbar
              SizedBox(height: screenHeight * 0.15),
            ],
          ),
        ),
      ),
    );
  }
}
