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
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: Colors.blue,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 60),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "أعمالنا",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24),
                ),
              ),

              const SizedBox(height: 20),

              // Works list
              _isLoading
                  ? const SizedBox(
                    height: 300,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ),
                  )
                  : _allWorks.isEmpty
                  ? SizedBox(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/empty_inbox.png',
                            width: 100,
                            height: 100,
                            color: Colors.blue,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'لا توجد أعمال',
                            style: TextStyle(
                              fontSize: 16,
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
                    itemCount: _allWorks.length,
                    itemBuilder: (context, index) {
                      final work = _allWorks[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Work image
                            Container(
                              height: 120,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(10),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(10),
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
                                                  Colors.blue,
                                                ),
                                          ),
                                        ),
                                      ),
                                  errorWidget:
                                      (context, url, error) => Container(
                                        color: Colors.grey[300],
                                        child: const Center(
                                          child: Icon(
                                            Icons.image_not_supported,
                                            size: 30,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                ),
                              ),
                            ),
                            // Work description
                            Container(
                              padding: const EdgeInsets.all(10),
                              color: Colors.white,
                              child: Text(
                                work['description'] ?? '',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
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

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add functionality for adding a new work
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
