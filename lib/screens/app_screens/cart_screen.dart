import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';

// App-specific imports
import '../../services/cart_service.dart';
import '../../utils/alert_utils.dart';
import 'product_details_screen.dart';
import 'checkout_screen.dart';

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

  /// Decreases the quantity of a product in the cart or removes it if quantity becomes 0
  Future<void> _decreaseQuantity(Map<String, dynamic> item) async {
    final int itemId = item['id'];

    // If the item is already being updated, ignore the request
    if (_updatingItems.containsKey(itemId)) return;

    final int currentQuantity = item['quantity'] ?? 1;
    final int addId = item['adds_product_id'] ?? 0;

    // If quantity is 1, set quantity to 0 to remove the item
    if (currentQuantity <= 1) {
      setState(() {
        _updatingItems[itemId] = 1; // Set updating state for the item
        _totalPrice -=
            double.parse((item['price'] ?? 0).toString()) *
            currentQuantity; // Update total price
      });

      try {
        // Update quantity to 0 to remove the item
        final response = await _cartService.updateProductInCart(
          itemId: itemId,
          quantity: 0,
          addId: addId,
        );

        if (response.statusCode == 200) {
          // Refresh cart data to remove the item from UI
          _loadCartData();
        } else {
          // On failure, revert total price
          if (mounted) {
            setState(() {
              _totalPrice +=
                  double.parse((item['price'] ?? 0).toString()) *
                  currentQuantity;
            });
            AlertUtils.showWarningAlert(
              context,
              "Error",
              "Failed to remove product from cart.",
            );
          }
        }
      } catch (e) {
        // On error, revert total price
        if (mounted) {
          setState(() {
            _totalPrice +=
                double.parse((item['price'] ?? 0).toString()) * currentQuantity;
          });
          AlertUtils.showWarningAlert(
            context,
            "Error",
            "Error removing product: ${e is DioException ? e.message : e}",
          );
        }
      } finally {
        // Remove updating state for the item
        if (mounted) {
          setState(() {
            _updatingItems.remove(itemId);
          });
        }
      }
      return;
    }

    // If quantity > 1, proceed with decreasing quantity
    final int newQuantity = currentQuantity - 1;

    // Update UI first (local update)
    final double itemPrice = double.parse((item['price'] ?? 0).toString());
    final double priceDifference =
        -itemPrice; // Price difference is negative item price

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
          final double priceDifference = itemPrice; // Reverse previous change

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
        final double priceDifference = itemPrice; // Reverse previous change

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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshCart,
        child: SizedBox(
          height:
              screenHeight, // Ensure SingleChildScrollView has full screen height
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.07),
                // Cart header
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "عربة التسوق",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: screenWidth * 0.06,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.025),

                // Cart content using FutureBuilder
                FutureBuilder<Map<String, dynamic>>(
                  future: _cartFuture,
                  builder: (context, snapshot) {
                    // Handle loading state
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: screenHeight * 0.5,
                        child: const Center(child: CircularProgressIndicator()),
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
                        height: screenHeight * 0.5,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: screenWidth * 0.2,
                                color: Colors.red,
                              ),
                              SizedBox(height: screenHeight * 0.025),
                              Text(
                                errorMessage,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  color: Colors.red,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: screenHeight * 0.025),
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
                        height: screenHeight * 0.5,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/empty_cart.png',
                                width: screenWidth * 0.5,
                                height: screenWidth * 0.5,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.shopping_cart_outlined,
                                    size: screenWidth * 0.25,
                                    color: const Color(0xFF1D75B1),
                                  );
                                },
                              ),
                              SizedBox(height: screenHeight * 0.025),
                              Text(
                                'عربة التسوق فارغة',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Text(
                                'قم بإضافة منتجات إلى سلة التسوق',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
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
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                      ),
                      child: Column(
                        children: [
                          // Cart items list
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              final item = cartItems[index];
                              return GestureDetector(
                                onTap: () {
                                  if (item['product_id'] != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => ProductDetailsScreen(
                                              productId: item['product_id'],
                                            ),
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                    bottom: screenHeight * 0.02,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(screenWidth * 0.04),
                                    child: Row(
                                      children: [
                                        // Product image
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                'https://albakr-ac.com${item['image']}',
                                            width: screenWidth * 0.2,
                                            height: screenWidth * 0.2,
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
                                                (
                                                  context,
                                                  url,
                                                  error,
                                                ) => Container(
                                                  color: Colors.grey[300],
                                                  child: Icon(
                                                    Icons.image_not_supported,
                                                    size: screenWidth * 0.075,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                          ),
                                        ),
                                        SizedBox(width: screenWidth * 0.04),
                                        // Product details
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item['name'] ?? '',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: screenWidth * 0.04,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              SizedBox(
                                                height: screenHeight * 0.005,
                                              ),
                                              Text(
                                                '${item['price']} ريال',
                                                style: TextStyle(
                                                  color: const Color(
                                                    0xFF1D75B1,
                                                  ),
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: screenWidth * 0.035,
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
                                            Text(
                                              'الكمية',
                                              style: TextStyle(
                                                fontSize: screenWidth * 0.03,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(
                                              height: screenHeight * 0.01,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  // Decrease button
                                                  InkWell(
                                                    onTap:
                                                        () => _decreaseQuantity(
                                                          item,
                                                        ),
                                                    child: Container(
                                                      width:
                                                          screenWidth * 0.075,
                                                      height:
                                                          screenWidth * 0.075,
                                                      decoration:
                                                          const BoxDecoration(
                                                            color: Colors.white,
                                                            shape:
                                                                BoxShape.circle,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color:
                                                                    Colors
                                                                        .black12,
                                                                blurRadius: 2,
                                                                offset: Offset(
                                                                  0,
                                                                  1,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.remove,
                                                          size:
                                                              screenWidth *
                                                              0.04,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  // Quantity display
                                                  Container(
                                                    width: screenWidth * 0.1,
                                                    alignment: Alignment.center,
                                                    child:
                                                        _updatingItems
                                                                .containsKey(
                                                                  item['id'],
                                                                )
                                                            ? SizedBox(
                                                              width:
                                                                  screenWidth *
                                                                  0.04,
                                                              height:
                                                                  screenWidth *
                                                                  0.04,
                                                              child:
                                                                  const CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        2,
                                                                  ),
                                                            )
                                                            : Text(
                                                              '${item['quantity'] ?? 1}',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    screenWidth *
                                                                    0.04,
                                                              ),
                                                            ),
                                                  ),
                                                  // Increase button
                                                  InkWell(
                                                    onTap:
                                                        () => _increaseQuantity(
                                                          item,
                                                        ),
                                                    child: Container(
                                                      width:
                                                          screenWidth * 0.075,
                                                      height:
                                                          screenWidth * 0.075,
                                                      decoration:
                                                          const BoxDecoration(
                                                            color: Colors.white,
                                                            shape:
                                                                BoxShape.circle,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color:
                                                                    Colors
                                                                        .black12,
                                                                blurRadius: 2,
                                                                offset: Offset(
                                                                  0,
                                                                  1,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.add,
                                                          size:
                                                              screenWidth *
                                                              0.04,
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
                                ),
                              );
                            },
                          ),

                          // Total price section
                          Container(
                            margin: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.025,
                            ),
                            padding: EdgeInsets.all(screenWidth * 0.05),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'المجموع',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.045,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '$_totalPrice ريال',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.045,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF1D75B1),
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => CheckoutScreen(
                                          totalPrice: _totalPrice,
                                        ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1D75B1),
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.02,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(38),
                                ),
                              ),
                              child: Text(
                                'إتمام الطلب',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            height: screenHeight * 0.12,
                          ), // Bottom padding
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
