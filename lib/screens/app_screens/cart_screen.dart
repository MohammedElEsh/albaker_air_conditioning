import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';

// App-specific imports
import '../../services/cart_service.dart';
import '../../utils/alert_utils.dart';

/// CartScreen - Display user's shopping cart
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with WidgetsBindingObserver {
  // Services
  final CartService _cartService = CartService();

  // State variables
  late Future<Map<String, dynamic>> _cartFuture;
  final Map<int, int> _updatingItems =
      {}; // لتخزين حالة التحديث لكل عنصر (item_id -> is_updating)
  double _totalPrice = 0.0; // لتخزين السعر الإجمالي

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _cartFuture = _fetchCartData().then((data) {
      if (mounted) {
        setState(() {
          _totalPrice = data['total_price'];
        });
      }
      return data;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh cart data when app is resumed
      _refreshCart();
    }
  }

  /// جلب بيانات السلة من API
  Future<Map<String, dynamic>> _fetchCartData() async {
    try {
      final response = await _cartService.getCart();

      if (response.statusCode == 200) {
        // جلب المنتجات من السلة
        List<dynamic> cartProducts =
            response.data['data']['cart_products'] ?? [];

        // معالجة بيانات المنتجات مع الاحتفاظ بكل التفاصيل
        List<Map<String, dynamic>> processedProducts = [];
        for (var product in cartProducts) {
          if (product['product'] != null) {
            // نحتفظ بكل بيانات المنتج والإضافات
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
              'full_product': product['product'], // نحتفظ بكامل بيانات المنتج
            });
          }
        }

        return {
          'items': processedProducts,
          'total_price': double.parse(
            (response.data['data']['total'] ?? 0.0).toString(),
          ),
          'error': null,
        };
      } else {
        return {
          'items': [],
          'total_price': 0.0,
          'error': 'فشل في تحميل البيانات: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'items': [],
        'total_price': 0.0,
        'error':
            'حدث خطأ أثناء تحميل البيانات: ${e is DioException ? e.message : e}',
      };
    }
  }

  /// تحديث بيانات السلة
  Future<void> _refreshCart() async {
    setState(() {
      _cartFuture = _fetchCartData().then((data) {
        if (mounted) {
          setState(() {
            _totalPrice = data['total_price'];
          });
        }
        return data;
      });
    });
  }

  /// زيادة كمية المنتج
  Future<void> _increaseQuantity(Map<String, dynamic> item) async {
    final int itemId = item['id'];

    // إذا كان العنصر قيد التحديث بالفعل، نتجاهل الطلب
    if (_updatingItems.containsKey(itemId)) return;

    final int currentQuantity = item['quantity'] ?? 1;

    // التحقق من الكمية القصوى المسموح بها (5 وحدات)
    if (currentQuantity >= 5) {
      AlertUtils.showWarningAlert(
        context,
        "تجاوز الحد المسموح",
        "عذرًا، لا يمكن طلب أكثر من 5 وحدات من نفس المنتج.",
      );
      return;
    }

    final int newQuantity = currentQuantity + 1;
    final int addId = item['adds_product_id'] ?? 0;

    // تحديث الواجهة أولاً (تحديث محلي)
    final double itemPrice = double.parse((item['price'] ?? 0).toString());
    final double priceDifference =
        itemPrice; // الفرق في السعر هو سعر العنصر الواحد

    setState(() {
      item['quantity'] = newQuantity;
      _updatingItems[itemId] = 1; // تعيين حالة التحديث للعنصر
      _totalPrice += priceDifference; // تحديث السعر الإجمالي
    });

    try {
      // تحديث الكمية في السلة (في الخلفية)
      final response = await _cartService.updateProductInCart(
        itemId: itemId,
        quantity: newQuantity,
        addId: addId,
      );

      if (response.statusCode != 200) {
        // في حالة الفشل، نعيد الكمية إلى القيمة السابقة
        if (mounted) {
          final double itemPrice = double.parse(
            (item['price'] ?? 0).toString(),
          );
          final double priceDifference = -itemPrice; // نعكس التغيير السابق

          setState(() {
            item['quantity'] = currentQuantity;
            _totalPrice += priceDifference; // تحديث السعر الإجمالي
          });
        }
      }
    } catch (e) {
      // في حالة حدوث خطأ، نعيد الكمية إلى القيمة السابقة
      if (mounted) {
        final double itemPrice = double.parse((item['price'] ?? 0).toString());
        final double priceDifference = -itemPrice; // نعكس التغيير السابق

        setState(() {
          item['quantity'] = currentQuantity;
          _totalPrice += priceDifference; // تحديث السعر الإجمالي
        });
      }
    } finally {
      // إزالة حالة التحديث للعنصر
      if (mounted) {
        setState(() {
          _updatingItems.remove(itemId);
        });
      }
    }
  }

  /// تقليل كمية المنتج
  Future<void> _decreaseQuantity(Map<String, dynamic> item) async {
    final int itemId = item['id'];

    // إذا كان العنصر قيد التحديث بالفعل، نتجاهل الطلب
    if (_updatingItems.containsKey(itemId)) return;

    final int currentQuantity = item['quantity'] ?? 1;
    if (currentQuantity <= 1) return; // لا يمكن تقليل الكمية أقل من 1

    final int newQuantity = currentQuantity - 1;
    final int addId = item['adds_product_id'] ?? 0;

    // تحديث الواجهة أولاً (تحديث محلي)
    final double itemPrice = double.parse((item['price'] ?? 0).toString());
    final double priceDifference =
        -itemPrice; // الفرق في السعر هو سالب سعر العنصر الواحد (لأننا ننقص)

    setState(() {
      item['quantity'] = newQuantity;
      _updatingItems[itemId] = 1; // تعيين حالة التحديث للعنصر
      _totalPrice += priceDifference; // تحديث السعر الإجمالي
    });

    try {
      // تحديث الكمية في السلة (في الخلفية)
      final response = await _cartService.updateProductInCart(
        itemId: itemId,
        quantity: newQuantity,
        addId: addId,
      );

      if (response.statusCode != 200) {
        // في حالة الفشل، نعيد الكمية إلى القيمة السابقة
        if (mounted) {
          final double itemPrice = double.parse(
            (item['price'] ?? 0).toString(),
          );
          final double priceDifference =
              itemPrice; // نعكس التغيير السابق (إضافة السعر لأننا قمنا بطرحه سابقًا)

          setState(() {
            item['quantity'] = currentQuantity;
            _totalPrice += priceDifference; // تحديث السعر الإجمالي
          });
        }
      }
    } catch (e) {
      // في حالة حدوث خطأ، نعيد الكمية إلى القيمة السابقة
      if (mounted) {
        final double itemPrice = double.parse((item['price'] ?? 0).toString());
        final double priceDifference =
            itemPrice; // نعكس التغيير السابق (إضافة السعر لأننا قمنا بطرحه سابقًا)

        setState(() {
          item['quantity'] = currentQuantity;
          _totalPrice += priceDifference; // تحديث السعر الإجمالي
        });
      }
    } finally {
      // إزالة حالة التحديث للعنصر
      if (mounted) {
        setState(() {
          _updatingItems.remove(itemId);
        });
      }
    }
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
                  return const SizedBox(
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
                          // final bool isProduct = item['type'] == 'product';

                          // تصميم مشابه للصورة المرجعية
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
                                  // قسم الكمية
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'حدد الكمية المطلوبة',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      // أزرار التحكم في الكمية
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
                                            // زر النقص
                                            InkWell(
                                              onTap: () {
                                                _decreaseQuantity(item);
                                              },
                                              child: Container(
                                                width: 30,
                                                height: 30,
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      blurRadius: 2,
                                                      offset: Offset(0, 1),
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
                                            // عرض الكمية
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
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                            ),
                                            // زر الزيادة
                                            InkWell(
                                              onTap: () {
                                                _increaseQuantity(item);
                                              },
                                              child: Container(
                                                width: 30,
                                                height: 30,
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      blurRadius: 2,
                                                      offset: Offset(0, 1),
                                                    ),
                                                  ],
                                                ),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.add,
                                                    size: 16,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  const Spacer(),

                                  // معلومات المنتج
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        // اسم المنتج
                                        Text(
                                          item['name'] ?? 'غير معروف',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                          textAlign: TextAlign.right,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),

                                        // العلامة التجارية
                                        if (item['brand'] != null)
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const SizedBox(width: 4),
                                              // شعار العلامة التجارية
                                              if (item['brand']['image'] !=
                                                  null)
                                                Image.network(
                                                  'https://albakr-ac.com${item['brand']['image']}',
                                                  width: 40,
                                                  height: 20,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) =>
                                                          const SizedBox.shrink(),
                                                ),
                                            ],
                                          ),

                                        const SizedBox(height: 8),

                                        // السعر
                                        Text(
                                          '${item['price'] ?? 0} ر.س',
                                          style: const TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  // صورة المنتج
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'https://albakr-ac.com${item['image']}',
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
                          color: const Color.fromRGBO(29, 117, 177, 0.1),
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
                              '${_totalPrice.toStringAsFixed(2)} ر.س',
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

                      // زر إتمام الشراء بتصميم جديد
                      SizedBox(
                        width: double.infinity,
                        height: 76,
                        child: ElevatedButton(
                          onPressed: () {
                            // عرض رسالة مؤقتة لوظيفة إتمام الشراء
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'سيتم تنفيذ وظيفة إتمام الشراء قريبًا',
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1D75B1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(38),
                            ),
                          ),
                          child: const Text(
                            "إتمام الشراء",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      // Add space at the bottom for the navbar
                      const SizedBox(height: 100),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
