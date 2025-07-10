import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../services/products_service.dart';
import '../../services/cart_service.dart';
import '../../utils/alert_utils.dart';
import 'product_details_screen.dart';

class ProductListScreen extends StatefulWidget {
  final List products;
  final String categoryName;
  final int currentPage;
  final int lastPage;
  final List links;
  final int categoryId;
  const ProductListScreen({
    super.key,
    required this.products,
    required this.categoryName,
    required this.currentPage,
    required this.lastPage,
    required this.links,
    required this.categoryId,
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late List products;
  late int currentPage;
  late int lastPage;
  late List links;
  bool isLoading = false;

  final ProductService _productService = ProductService();
  final CartService _cartService = CartService();

  @override
  void initState() {
    super.initState();
    products = widget.products;
    currentPage = widget.currentPage;
    lastPage = widget.lastPage;
    links = widget.links;
  }

  Future<void> fetchPage(int page) async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await _productService.getProductsByCategory(
        widget.categoryId,
        page: page,
      );
      if (response.statusCode == 200) {
        final data = response.data['data'];
        setState(() {
          products = data['data'] ?? [];
          currentPage = data['current_page'] ?? 1;
          lastPage = data['last_page'] ?? 1;
          links = data['links'] ?? [];
        });
      }
    } catch (e) {
      // يمكنك عرض رسالة خطأ هنا
    }
    setState(() {
      isLoading = false;
    });
  }

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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and title
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.03, // زيادة المسافة للأسفل
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xFF1D75B1),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        widget.categoryName,
                        style: TextStyle(
                          fontWeight: FontWeight.w900, // أكثر ثقلًا
                          fontSize: screenWidth * 0.055, // أكبر قليلاً
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: 0,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: null,
                    ),
                  ), // لموازنة الـ Row
                ],
              ),
            ),
            // Products Grid
            Expanded(
              child:
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.02,
                        ),
                        child:
                            products.isEmpty
                                ? Center(
                                  child: Text('لا توجد منتجات في هذا التصنيف'),
                                )
                                : GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: screenWidth * 0.01,
                                        mainAxisSpacing: screenWidth * 0.04,
                                        childAspectRatio: 0.75,
                                      ),
                                  itemCount: products.length,
                                  itemBuilder: (context, index) {
                                    final product = products[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    ProductDetailsScreen(
                                                      productId: product['id'],
                                                    ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: screenWidth * 0.5,
                                        margin: EdgeInsets.only(
                                          left: screenWidth * 0.01,
                                          right:
                                              (index % 2 == 1)
                                                  ? screenWidth * 0.01
                                                  : 0,
                                        ),
                                        child: Card(
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.vertical(
                                                        top: Radius.circular(
                                                          12,
                                                        ),
                                                      ),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        'https://albakr-ac.com/${product['main_image']}',
                                                    fit: BoxFit.cover,
                                                    placeholder:
                                                        (
                                                          context,
                                                          url,
                                                        ) => const Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                                color: Color(
                                                                  0xFF1D75B1,
                                                                ),
                                                              ),
                                                        ),
                                                    errorWidget:
                                                        (
                                                          context,
                                                          url,
                                                          error,
                                                        ) => Container(
                                                          color:
                                                              Colors.grey[300],
                                                          child: const Icon(
                                                            Icons
                                                                .image_not_supported,
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
                                                  padding: EdgeInsets.all(
                                                    screenWidth * 0.01,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          // اسم المنتج
                                                          Expanded(
                                                            child: Text(
                                                              product['name'] ??
                                                                  '',
                                                              style: TextStyle(
                                                                fontSize:
                                                                    screenWidth *
                                                                    0.035,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color:
                                                                    Colors
                                                                        .black87,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          // نجمة التقييم بجانب الاسم
                                                          if (product['total_rate'] !=
                                                              null)
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  (product['total_rate']
                                                                          as num)
                                                                      .toStringAsFixed(
                                                                        1,
                                                                      ),
                                                                  style: TextStyle(
                                                                    color:
                                                                        Colors
                                                                            .orange[700],
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        screenWidth *
                                                                        0.032,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 2,
                                                                ),
                                                                Icon(
                                                                  Icons.star,
                                                                  color:
                                                                      Colors
                                                                          .orange[700],
                                                                  size:
                                                                      screenWidth *
                                                                      0.04,
                                                                ),
                                                              ],
                                                            ),
                                                        ],
                                                      ),
                                                      Text(
                                                        (product['description'] ??
                                                                '')
                                                            .replaceAll(
                                                              '\r\n',
                                                              ', ',
                                                            ),
                                                        style: TextStyle(
                                                          fontSize:
                                                              screenWidth *
                                                              0.028,
                                                          color:
                                                              Colors.grey[600],
                                                        ),
                                                        textAlign:
                                                            TextAlign.right,
                                                        maxLines: 2,
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          // زر إضافة للعربة
                                                          IconButton(
                                                            icon: const Icon(
                                                              Icons
                                                                  .add_shopping_cart,
                                                              color: Color(
                                                                0xFF1D75B1,
                                                              ),
                                                            ),
                                                            tooltip:
                                                                'إضافة إلى العربة',
                                                            onPressed:
                                                                () => _addToCart(
                                                                  product['id'],
                                                                ),
                                                          ),
                                                          if (product['brand'] !=
                                                                  null &&
                                                              product['brand']['image'] !=
                                                                  null)
                                                            CachedNetworkImage(
                                                              imageUrl:
                                                                  'https://albakr-ac.com/${product['brand']['image']}',
                                                              width:
                                                                  screenWidth *
                                                                  0.08,
                                                              height:
                                                                  screenWidth *
                                                                  0.08,
                                                              fit:
                                                                  BoxFit
                                                                      .contain,
                                                              placeholder:
                                                                  (
                                                                    context,
                                                                    url,
                                                                  ) => SizedBox(
                                                                    width:
                                                                        screenWidth *
                                                                        0.08,
                                                                    height:
                                                                        screenWidth *
                                                                        0.08,
                                                                    child: const CircularProgressIndicator(
                                                                      strokeWidth:
                                                                          2,
                                                                      color: Color(
                                                                        0xFF1D75B1,
                                                                      ),
                                                                    ),
                                                                  ),
                                                              errorWidget:
                                                                  (
                                                                    context,
                                                                    url,
                                                                    error,
                                                                  ) => Icon(
                                                                    Icons
                                                                        .image_not_supported,
                                                                    size:
                                                                        screenWidth *
                                                                        0.08,
                                                                    color:
                                                                        Colors
                                                                            .grey,
                                                                  ),
                                                            ),
                                                          Text(
                                                            '${product['price']} ريال',
                                                            style: TextStyle(
                                                              fontSize:
                                                                  screenWidth *
                                                                  0.032,
                                                              color:
                                                                  Colors
                                                                      .green[600],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                            textAlign:
                                                                TextAlign.right,
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
            // Pagination
            if (lastPage > 1)
              Padding(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var link in links)
                        if (link['label'] != null &&
                            link['label']
                                .toString()
                                .replaceAll(RegExp(r'[^0-9]'), '')
                                .isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    link['active'] == true
                                        ? const Color(0xFF1D75B1)
                                        : Colors.white,
                                foregroundColor:
                                    link['active'] == true
                                        ? Colors.white
                                        : Colors.black,
                                minimumSize: const Size(36, 36),
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                    color: const Color(0xFF1D75B1),
                                  ),
                                ),
                              ),
                              onPressed:
                                  link['active'] == true
                                      ? null
                                      : () {
                                        final page = int.tryParse(
                                          link['label'].toString(),
                                        );
                                        if (page != null) fetchPage(page);
                                      },
                              child: Text(link['label'].toString()),
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            // Custom Navbar
            // const YourCustomNavbar(),
            SizedBox(height: screenHeight * 0.01),
          ],
        ),
      ),
    );
  }
}
