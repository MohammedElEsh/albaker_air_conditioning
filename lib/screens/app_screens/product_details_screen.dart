import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../services/products_service.dart';
import '../../services/cart_service.dart';
import '../../utils/alert_utils.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;
  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final ProductService _productService = ProductService();
  final CartService _cartService = CartService();
  Map<String, dynamic>? product;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchProductDetails();
  }

  Future<void> _fetchProductDetails() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final response = await _productService.getProductDetails(
        widget.productId,
      );
      if (response.statusCode == 200) {
        setState(() {
          product = response.data['data'];
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'تعذر تحميل بيانات المنتج';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'حدث خطأ أثناء تحميل بيانات المنتج';
        isLoading = false;
      });
    }
  }

  Future<void> _addToCart() async {
    if (product == null) return;
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
        productId: product!['id'],
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child:
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : error != null
                  ? Center(
                    child: Text(
                      error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                  : product == null
                  ? const Center(child: Text('لا توجد بيانات'))
                  : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: screenHeight * 0.06),
                        // Header with back button and title
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Icon(
                                Icons.arrow_back,
                                color: const Color(0xFF1D75B1),
                                size: screenWidth * 0.06,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'تفاصيل المنتج',
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                              ),
                            ),
                            const Spacer(),
                            SizedBox(width: screenWidth * 0.06),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        // Main product image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://albakr-ac.com${product!['main_image']}',
                            width: screenWidth * 0.7,
                            height: screenHeight * 0.22,
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
                                    color: Colors.grey,
                                  ),
                                ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        // Images gallery
                        if (product!['images'] != null &&
                            (product!['images'] as List).isNotEmpty)
                          SizedBox(
                            height: screenHeight * 0.08,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children:
                                  (product!['images'] as List).map<Widget>((
                                    img,
                                  ) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          imageUrl: 'https://albakr-ac.com$img',
                                          width: screenWidth * 0.16,
                                          height: screenHeight * 0.08,
                                          fit: BoxFit.cover,
                                          placeholder:
                                              (context, url) => const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                          errorWidget:
                                              (context, url, error) =>
                                                  Container(
                                                    color: Colors.grey[300],
                                                    child: const Icon(
                                                      Icons.image_not_supported,
                                                      size: 24,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                        SizedBox(height: screenHeight * 0.03),
                        // Product name
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            product!['name'] ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.045,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        SizedBox(height: 10),
                        // Brand image above rating
                        if (product!['brand'] != null &&
                            product!['brand']['image'] != null)
                          Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: CachedNetworkImage(
                                imageUrl:
                                    'https://albakr-ac.com${product!['brand']['image']}',
                                width: 38,
                                height: 38,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        // Rating
                        if (product!['total_rate'] != null)
                          Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  (product!['total_rate'] as num)
                                      .toStringAsFixed(1),
                                  style: TextStyle(
                                    color: Colors.orange[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth * 0.038,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Icon(
                                  Icons.star,
                                  color: Colors.orange[700],
                                  size: screenWidth * 0.045,
                                ),
                              ],
                            ),
                          ),
                        SizedBox(height: 12),
                        // Description
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            (product!['description'] ?? '').replaceAll(
                              '\r\n',
                              '\n',
                            ),
                            style: TextStyle(
                              fontSize: screenWidth * 0.034,
                              color: Colors.grey[800],
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        SizedBox(height: 18),
                        // Price
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${product!['price']} ر.س',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.045,
                              color: Colors.green[700],
                            ),
                          ),
                        ),
                        SizedBox(height: 28),
                        // Add to cart button (icon perfectly centered)
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1D75B1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: _addToCart,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.add_shopping_cart,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 40.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        // Reviews section (placeholder)
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'تقييمات المنتج',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        if (product!['reviews'] != null &&
                            (product!['reviews'] as List).isNotEmpty)
                          ...((product!['reviews'] as List).map((review) {
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                leading: Icon(
                                  Icons.person,
                                  color: Colors.grey[600],
                                ),
                                title: Text(review['comment'] ?? ''),
                                subtitle: Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.orange[700],
                                      size: 18,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(review['rate']?.toString() ?? ''),
                                  ],
                                ),
                              ),
                            );
                          }).toList()),
                        if (product!['reviews'] == null ||
                            (product!['reviews'] as List).isEmpty)
                          const Text('لا توجد تقييمات بعد'),
                        SizedBox(height: 24),
                      ],
                    ),
                  ),
        ),
      ),
    );
  }
}
