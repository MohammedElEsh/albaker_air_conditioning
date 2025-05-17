/// The cart screen that displays and manages the user's shopping cart.
///
/// Features:
/// - Display cart items with images and details
/// - Update item quantities
/// - Remove items from cart
/// - Calculate total price
/// - Handle loading states
/// - Error handling
/// - Auto-refresh on app resume
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';

// App-specific imports
import '../../services/cart_service.dart';
import '../../utils/alert_utils.dart';

/// CartScreen - Manages the shopping cart functionality and UI.
///
/// This screen implements:
/// - Cart item display and management
/// - Quantity updates
/// - Item removal
/// - Total price calculation
/// - Loading states
/// - Error handling
/// - Auto-refresh functionality
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with WidgetsBindingObserver {
  /// Service for handling cart-related API calls
  final CartService _cartService = CartService();

  /// Future that holds the cart data
  late Future<Map<String, dynamic>> _cartFuture;

  /// Map to track updating state of each cart item
  /// Key: item_id, Value: is_updating
  final Map<int, int> _updatingItems = {};

  /// Total price of all items in cart
  double _totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadCartData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadCartData();
    }
  }

  /// Loads cart data and updates the state
  void _loadCartData() {
    setState(() {
      _cartFuture = _fetchCartData().then((data) {
        if (mounted) {
          setState(() {
            _totalPrice = data['total_price'] ?? 0.0;
          });
        }
        return data;
      });
    });
  }

  /// Fetches cart data from the API.
  ///
  /// Returns:
  /// - Map containing cart items and total price
  /// - Empty map if API call fails
  ///
  /// Error handling includes:
  /// - Network connectivity issues
  /// - Server timeout
  /// - Authentication errors
  /// - General API errors
  Future<Map<String, dynamic>> _fetchCartData() async {
    try {
      final response = await _cartService.getCart();

      if (response.statusCode == 200) {
        final data = response.data['data'] ?? {};
        final cartProducts = data['cart_products'] ?? [];
        final total = data['total'] ?? 0.0;

        // Process cart products
        List<Map<String, dynamic>> processedProducts = [];
        for (var product in cartProducts) {
          if (product['product'] != null) {
            processedProducts.add({
              'id': product['id'],
              'cart_id': product['cart_id'],
              'quantity': product['quantity'],
              'product_id': product['product_id'],
              'adds_product_id': product['adds_product_id'],
              'type': 'product',
              'name': product['product']['name'],
              'price': product['product']['price'],
              'image': product['product']['main_image'],
              'description': product['product']['description'],
              'total_rate': product['product']['total_rate'],
              'product_quantity': product['product']['quantity'],
              'brand': product['product']['brand'],
              'add': product['add'],
              'full_product': product['product'],
            });
          }
        }

        return {
          'items': processedProducts,
          'total_price': double.parse(total.toString()),
          'error': null,
        };
      } else {
        return {
          'items': [],
          'total_price': 0.0,
          'error': 'Failed to load data: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'items': [],
        'total_price': 0.0,
        'error': 'Error loading data: ${e is DioException ? e.message : e}',
      };
    }
  }

  /// Refreshes cart data
  Future<void> _refreshCart() async {
    _loadCartData();
  }

  /// Increases the quantity of a product in the cart
  Future<void> _increaseQuantity(Map<String, dynamic> item) async {
    final int itemId = item['id'];

    // If the item is already being updated, ignore the request
    if (_updatingItems.containsKey(itemId)) return;

    final int currentQuantity = item['quantity'] ?? 1;

    // Check maximum allowed quantity (5 units)
    if (currentQuantity >= 5) {
      AlertUtils.showWarningAlert(
        context,
        "Maximum Limit Reached",
        "Sorry, you cannot order more than 5 units of the same product.",
      );
      return;
    }

    final int newQuantity = currentQuantity + 1;
    final int addId = item['adds_product_id'] ?? 0;

    // Update UI first (local update)
    final double itemPrice = double.parse((item['price'] ?? 0).toString());
    final double priceDifference =
        itemPrice; // Price difference is the item price

    setState(() {
      item['quantity'] = newQuantity;
      _updatingItems[itemId] = 1; // Set updating state for the item
      _totalPrice += priceDifference; // Update total price
    });

    try {
      // Update quantity in cart (background)
      final response = await _cartService.updateProductInCart(
        itemId: itemId,
        quantity: newQuantity,
        addId: addId,
      );

      if (response.statusCode != 200) {
        // On failure, revert quantity to previous value
        if (mounted) {
          final double itemPrice = double.parse(
            (item['price'] ?? 0).toString(),
          );
          final double priceDifference = -itemPrice; // Reverse previous change

          setState(() {
            item['quantity'] = currentQuantity;
            _totalPrice += priceDifference; // Update total price
          });
        }
      }
    } catch (e) {
      // On error, revert quantity to previous value
      if (mounted) {
        final double itemPrice = double.parse((item['price'] ?? 0).toString());
        final double priceDifference = -itemPrice; // Reverse previous change

        setState(() {
          item['quantity'] = currentQuantity;
          _totalPrice += priceDifference; // Update total price
        });
      }
    } finally {
      // Remove updating state for the item
      if (mounted) {
        setState(() {
          _updatingItems.remove(itemId);
        });
      }
    }
  }

  /// Decreases the quantity of a product in the cart
  Future<void> _decreaseQuantity(Map<String, dynamic> item) async {
    final int itemId = item['id'];

    // If the item is already being updated, ignore the request
    if (_updatingItems.containsKey(itemId)) return;

    final int currentQuantity = item['quantity'] ?? 1;
    if (currentQuantity <= 1) return; // Cannot decrease quantity below 1

    final int newQuantity = currentQuantity - 1;
    final int addId = item['adds_product_id'] ?? 0;

    // Update UI first (local update)
    final double itemPrice = double.parse((item['price'] ?? 0).toString());
    final double priceDifference =
        -itemPrice; // Price difference is negative item price (because we're decreasing)

    setState(() {
      item['quantity'] = newQuantity;
      _updatingItems[itemId] = 1; // Set updating state for the item
      _totalPrice += priceDifference; // Update total price
    });

    try {
      // Update quantity in cart (background)
      final response = await _cartService.updateProductInCart(
        itemId: itemId,
        quantity: newQuantity,
        addId: addId,
      );

      if (response.statusCode != 200) {
        // On failure, revert quantity to previous value
        if (mounted) {
          final double itemPrice = double.parse(
            (item['price'] ?? 0).toString(),
          );
          final double priceDifference =
              itemPrice; // Reverse previous change (add price because we subtracted it before)

          setState(() {
            item['quantity'] = currentQuantity;
            _totalPrice += priceDifference; // Update total price
          });
        }
      }
    } catch (e) {
      // On error, revert quantity to previous value
      if (mounted) {
        final double itemPrice = double.parse((item['price'] ?? 0).toString());
        final double priceDifference =
            itemPrice; // Reverse previous change (add price because we subtracted it before)

        setState(() {
          item['quantity'] = currentQuantity;
          _totalPrice += priceDifference; // Update total price
        });
      }
    } finally {
      // Remove updating state for the item
      if (mounted) {
        setState(() {
          _updatingItems.remove(itemId);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshCart,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 60),
              // Cart header
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 33),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "عربة التسوق",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Cart content using FutureBuilder
              FutureBuilder<Map<String, dynamic>>(
                future: _cartFuture,
                builder: (context, snapshot) {
                  // Handle loading state
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 400,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  // Handle error state
                  if (snapshot.hasError ||
                      (snapshot.hasData && snapshot.data!['error'] != null)) {
                    String errorMessage =
                        snapshot.hasError
                            ? snapshot.error.toString()
                            : snapshot.data!['error'];

                    return SizedBox(
                      height: 400,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 80,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              errorMessage,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _refreshCart,
                              child: const Text('إعادة المحاولة'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Handle data state
                  final cartItems = snapshot.data!['items'] as List<dynamic>;

                  // Empty cart state
                  if (cartItems.isEmpty) {
                    return SizedBox(
                      height: 400,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/empty_cart.png',
                              width: 150,
                              height: 150,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.shopping_cart_outlined,
                                  size: 100,
                                  color: Color(0xFF1D75B1),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'عربة التسوق فارغة',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'قم بإضافة منتجات إلى سلة التسوق',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Cart with items
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        // Cart items list
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cartItems[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    // Product image
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            'https://albakr-ac.com${item['image']}',
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        placeholder:
                                            (context, url) => Container(
                                              color: Colors.grey[200],
                                              child: const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            ),
                                        errorWidget:
                                            (context, url, error) => Container(
                                              color: Colors.grey[300],
                                              child: const Icon(
                                                Icons.image_not_supported,
                                                size: 30,
                                                color: Colors.grey,
                                              ),
                                            ),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    // Product details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['name'] ?? '',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            '${item['price']} ريال',
                                            style: const TextStyle(
                                              color: Color(0xFF1D75B1),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Quantity controls
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'الكمية',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // Decrease button
                                              InkWell(
                                                onTap:
                                                    () =>
                                                        _decreaseQuantity(item),
                                                child: Container(
                                                  width: 30,
                                                  height: 30,
                                                  decoration:
                                                      const BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color:
                                                                Colors.black12,
                                                            blurRadius: 2,
                                                            offset: Offset(
                                                              0,
                                                              1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons.remove,
                                                      size: 16,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // Quantity display
                                              Container(
                                                width: 40,
                                                alignment: Alignment.center,
                                                child:
                                                    _updatingItems.containsKey(
                                                          item['id'],
                                                        )
                                                        ? const SizedBox(
                                                          width: 16,
                                                          height: 16,
                                                          child:
                                                              CircularProgressIndicator(
                                                                strokeWidth: 2,
                                                              ),
                                                        )
                                                        : Text(
                                                          '${item['quantity'] ?? 1}',
                                                          style:
                                                              const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                              ),
                                                        ),
                                              ),
                                              // Increase button
                                              InkWell(
                                                onTap:
                                                    () =>
                                                        _increaseQuantity(item),
                                                child: Container(
                                                  width: 30,
                                                  height: 30,
                                                  decoration:
                                                      const BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color:
                                                                Colors.black12,
                                                            blurRadius: 2,
                                                            offset: Offset(
                                                              0,
                                                              1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons.add,
                                                      size: 16,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        // Total price section
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 20),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'المجموع',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '$_totalPrice ريال',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1D75B1),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Checkout button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigate to checkout
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1D75B1),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'إتمام الطلب',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
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
