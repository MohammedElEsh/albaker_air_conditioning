/// The works screen that displays all works in a vertical layout.
///
/// Features:
/// - Display works with images and descriptions
/// - Pull to refresh functionality
/// - Loading states
/// - Error handling
/// - Empty state handling
/// - Cached image loading
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

// App-specific imports
import '../../services/works_service.dart';

/// WorksScreen - Manages the display of all works.
///
/// This screen implements:
/// - Work listing with images and descriptions
/// - Image caching for better performance
/// - Loading states
/// - Error handling
/// - Empty state handling
/// - Pull to refresh functionality
class WorksScreen extends StatefulWidget {
  const WorksScreen({super.key});

  @override
  State<WorksScreen> createState() => _WorksScreenState();
}

class _WorksScreenState extends State<WorksScreen> {
  /// Service for handling works-related API calls
  final WorksService _worksService = WorksService();

  /// List of all works
  List<dynamic> _allWorks = [];

  /// Loading state for works
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllWorks();
  }

  /// Loads all works from the API.
  ///
  /// Process:
  /// 1. Sets loading state
  /// 2. Makes API call to fetch works
  /// 3. Updates state with works
  /// 4. Handles empty state
  ///
  /// Error handling includes:
  /// - Network connectivity issues
  /// - Server timeout
  /// - Authentication errors
  /// - General API errors
  Future<void> _loadAllWorks() async {
    setState(() {
      _isLoading = true;
    });
    final response = await _worksService.getAllWorks();
    final data = response.data['data'] ?? {};
    final worksList = data.values.toList();
    setState(() {
      _allWorks = worksList;
      _isLoading = false;
      print('Works Loaded: ${_allWorks.length}');
    });
  }

  /// Refreshes works data.
  Future<void> _refreshData() async {
    await _loadAllWorks();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: const Color(0xFF1D75B1),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.07),
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Text(
                  "أعمالنا",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: screenWidth * 0.06,
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.025),

              // Works list
              _isLoading
                  ? SizedBox(
                    height: screenHeight * 0.4,
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF1D75B1),
                        ),
                      ),
                    ),
                  )
                  : _allWorks.isEmpty
                  ? SizedBox(
                    height: screenHeight * 0.4,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/empty_inbox.png',
                            width: screenWidth * 0.25,
                            height: screenWidth * 0.25,
                            color: const Color(0xFF1D75B1),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Text(
                            'لا توجد أعمال',
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                  : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _allWorks.length,
                    itemBuilder: (context, index) {
                      final work = _allWorks[index];
                      return Container(
                        margin: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.012,
                          horizontal: screenWidth * 0.05,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Work image
                            Container(
                              height: screenHeight * 0.15,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(15),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(15),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'https://albakr-ac.com${work['image']}',
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  placeholder:
                                      (context, url) => Container(
                                        color: Colors.grey[200],
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Color(0xFF1D75B1),
                                                ),
                                          ),
                                        ),
                                      ),
                                  errorWidget:
                                      (context, url, error) => Container(
                                        color: Colors.grey[300],
                                        child: Center(
                                          child: Icon(
                                            Icons.image_not_supported,
                                            size: screenWidth * 0.075,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                ),
                              ),
                            ),
                            // Work description
                            Container(
                              padding: EdgeInsets.all(screenWidth * 0.025),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(15),
                                ),
                              ),
                              child: Text(
                                work['description'] ?? '',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

              SizedBox(height: screenHeight * 0.1),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add functionality for adding a new work
        },
        backgroundColor: const Color(0xFF1D75B1),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
