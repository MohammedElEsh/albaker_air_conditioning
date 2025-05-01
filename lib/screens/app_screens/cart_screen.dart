import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

// App-specific imports
import '../../services/cart_service.dart';

/// CartScreen - Display user's shopping cart
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Services
  final CartService _cartService = CartService();

  // State variables
  List<dynamic> _cartItems = [];
  bool _isLoading = true;
  double _totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCartData();
  }

  /// Load cart data from the API
  Future<void> _loadCartData() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final response = await _cartService.getCart();
      if (response.statusCode == 200) {
        setState(() {
          _cartItems = response.data['data']['items'] ?? [];
          _totalPrice = double.parse(
            (response.data['data']['total_price'] ?? 0.0).toString(),
          );
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

  /// Update product quantity in cart
  Future<void> _updateProductQuantity(
    int itemId,
    int quantity,
    int addId,
  ) async {
    try {
      await _cartService.updateProductInCart(
        itemId: itemId,
        quantity: quantity,
        addId: addId,
      );
      _loadCartData(); // Refresh cart after update
    } catch (e) {
      // Handle error
    }
  }

  /// Update accessory quantity in cart
  Future<void> _updateAccessoryQuantity(int itemId, int quantity) async {
    try {
      await _cartService.updateAccessoryInCart(
        itemId: itemId,
        quantity: quantity,
      );
      _loadCartData(); // Refresh cart after update
    } catch (e) {
      // Handle error
    }
  }

  /// Pull to refresh cart data
  Future<void> _refreshCart() async {
    await _loadCartData();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
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
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Cart content
            _isLoading
                ? const SizedBox(
                  height: 400,
                  child: Center(child: CircularProgressIndicator()),
                )
                : _cartItems.isEmpty
                ? const SizedBox(
                  height: 400,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 100,
                          color: Color(0xFF1D75B1),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'عربة التسوق فارغة',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Cart items list
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _cartItems.length,
                        itemBuilder: (context, index) {
                          final item = _cartItems[index];
                          final bool isProduct = item['type'] == 'product';

                          return Card(
                            elevation: 3,
                            margin: const EdgeInsets.only(bottom: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  // Product/Accessory image
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'https://albakr-ac.com/${item['image']}',
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      placeholder:
                                          (context, url) => const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                      errorWidget:
                                          (context, url, error) => Container(
                                            color: Colors.grey[300],
                                            child: const Icon(
                                              Icons.image_not_supported,
                                              size: 40,
                                            ),
                                          ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Item details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['name'] ?? 'غير معروف',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Text(
                                              '${item['price'] ?? 0} ر.س',
                                              style: const TextStyle(
                                                color: Color(0xFF1D75B1),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const Spacer(),
                                            // Quantity controls
                                            Container(
                                              decoration: BoxDecoration(
                                                color: const Color(
                                                  0xFF1D75B1,
                                                ).withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  // Increase button
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.add,
                                                      size: 18,
                                                    ),
                                                    onPressed: () {
                                                      final newQuantity =
                                                          (item['quantity'] ??
                                                              1) +
                                                          1;
                                                      if (isProduct) {
                                                        _updateProductQuantity(
                                                          item['id'],
                                                          newQuantity,
                                                          item['add_id'] ?? 0,
                                                        );
                                                      } else {
                                                        _updateAccessoryQuantity(
                                                          item['id'],
                                                          newQuantity,
                                                        );
                                                      }
                                                    },
                                                  ),
                                                  // Quantity display
                                                  Text(
                                                    '${item['quantity'] ?? 1}',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  // Decrease button
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.remove,
                                                      size: 18,
                                                    ),
                                                    onPressed: () {
                                                      final currentQuantity =
                                                          item['quantity'] ?? 1;
                                                      if (currentQuantity > 1) {
                                                        final newQuantity =
                                                            currentQuantity - 1;
                                                        if (isProduct) {
                                                          _updateProductQuantity(
                                                            item['id'],
                                                            newQuantity,
                                                            item['add_id'] ?? 0,
                                                          );
                                                        } else {
                                                          _updateAccessoryQuantity(
                                                            item['id'],
                                                            newQuantity,
                                                          );
                                                        }
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      // Total price section
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1D75B1).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'المجموع:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '$_totalPrice ر.س',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1D75B1),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Checkout button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to checkout screen
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1D75B1),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'إتمام الشراء',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      // Add space at the bottom for the navbar
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
