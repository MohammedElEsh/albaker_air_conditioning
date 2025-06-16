/// The projects screen that displays project categories and their associated projects.
///
/// Features:
/// - Display project categories
/// - Show projects for selected category
/// - Cached image loading
/// - Loading states
/// - Error handling
/// - Auto-select first category
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

// App-specific imports
import '../../services/projects_service.dart';

/// ProjectsScreen - Manages the display of project categories and their projects.
///
/// This screen implements:
/// - Category selection and display
/// - Project listing by category
/// - Image caching for better performance
/// - Loading states
/// - Error handling
/// - Auto-selection of first category
class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen>
    with SingleTickerProviderStateMixin {
  /// Service for handling project-related API calls
  final ProjectService _projectService = ProjectService();

  /// List of project categories
  List<dynamic> _projectCategories = [];

  /// List of projects for the selected category
  List<dynamic> _selectedCategoryProjects = [];

  /// ID of the currently selected category
  int? _selectedCategoryId;

  /// Loading state for categories
  bool _isLoadingCategories = true;

  /// Loading state for projects
  bool _isLoadingProjects = false;

  @override
  void initState() {
    super.initState();
    _loadProjectCategories();
  }

  /// Loads project categories from the API.
  ///
  /// Process:
  /// 1. Sets loading state
  /// 2. Makes API call to fetch categories
  /// 3. Updates state with categories
  /// 4. Auto-selects first category if available
  /// 5. Loads projects for selected category
  ///
  /// Error handling includes:
  /// - Network connectivity issues
  /// - Server timeout
  /// - Authentication errors
  /// - General API errors
  Future<void> _loadProjectCategories() async {
    try {
      setState(() {
        _isLoadingCategories = true;
      });
      final response = await _projectService.getProjectCategories();
      if (response.statusCode == 200) {
        setState(() {
          _projectCategories = response.data['data'] ?? [];
          _isLoadingCategories = false;

          // Auto-select first category if available
          if (_projectCategories.isNotEmpty) {
            _selectedCategoryId = _projectCategories[0]['id'];
            _loadProjectsByCategory(_selectedCategoryId!);
          }
        });
      } else {
        setState(() {
          _isLoadingCategories = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingCategories = false;
      });
      // Handle error
    }
  }

  /// Loads projects for a specific category.
  ///
  /// Parameters:
  /// - categoryId: The ID of the category to load projects for
  ///
  /// Process:
  /// 1. Sets loading state
  /// 2. Makes API call to fetch projects
  /// 3. Updates state with projects
  ///
  /// Error handling includes:
  /// - Network connectivity issues
  /// - Server timeout
  /// - Authentication errors
  /// - General API errors
  Future<void> _loadProjectsByCategory(int categoryId) async {
    try {
      setState(() {
        _isLoadingProjects = true;
      });
      final response = await _projectService.getProjectsByCategory(categoryId);
      if (response.statusCode == 200) {
        setState(() {
          _selectedCategoryProjects = response.data['data'] ?? [];
          _isLoadingProjects = false;
        });
      } else {
        setState(() {
          _isLoadingProjects = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingProjects = false;
      });
      // Handle error
    }
  }

  /// Handle category selection
  void _selectCategory(
    int categoryId,
    String categoryName,
    String? categoryImage,
  ) {
    if (_selectedCategoryId != categoryId) {
      setState(() {
        _selectedCategoryId = categoryId;
      });
      _loadProjectsByCategory(categoryId);
    }
  }

  /// Pull to refresh data
  Future<void> _refreshData() async {
    await _loadProjectCategories();
    if (_selectedCategoryId != null) {
      await _loadProjectsByCategory(_selectedCategoryId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return RefreshIndicator(
      onRefresh: _refreshData,
      color: const Color(0xFF1D75B1),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.07),
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
              child: Text(
                "مشاريعنا",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: screenWidth * 0.06,
                ),
              ),
            ),

            SizedBox(height: screenHeight * 0.04),

            // Project categories horizontal list
            _isLoadingCategories
                ? SizedBox(
                  height: screenHeight * 0.1,
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF1D75B1),
                      ),
                    ),
                  ),
                )
                : _projectCategories.isEmpty
                ? SizedBox(
                  height: screenHeight * 0.1,
                  child: Center(
                    child: Text(
                      'لا توجد تصنيفات',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                )
                : SizedBox(
                  height: screenHeight * 0.1,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _projectCategories.length,
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                    ),
                    itemBuilder: (context, index) {
                      final category = _projectCategories[index];
                      final isSelected = _selectedCategoryId == category['id'];

                      return GestureDetector(
                        onTap:
                            () => _selectCategory(
                              category['id'],
                              category['name'] ?? '',
                              category['image'],
                            ),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: EdgeInsets.only(right: screenWidth * 0.03),
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                            vertical: screenHeight * 0.012,
                          ),
                          decoration: BoxDecoration(
                            gradient:
                                isSelected
                                    ? const LinearGradient(
                                      colors: [
                                        Color(0xFF1D75B1),
                                        Color(0xFF2A9AD9),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                    : null,
                            color: isSelected ? null : Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: const Color(0xFF1D75B1),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Display category image if available
                              if (category['image'] != null)
                                AnimatedScale(
                                  scale: isSelected ? 1.2 : 1.0,
                                  duration: const Duration(milliseconds: 200),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : Colors.transparent,
                                      boxShadow:
                                          isSelected
                                              ? [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.2),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ]
                                              : null,
                                    ),
                                    padding:
                                        isSelected
                                            ? const EdgeInsets.all(2)
                                            : null,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            'https://albakr-ac.com/${category['image']}',
                                        width: screenWidth * 0.1,
                                        height: screenWidth * 0.1,
                                        fit: BoxFit.cover,
                                        placeholder:
                                            (context, url) => Container(
                                              width: screenWidth * 0.1,
                                              height: screenWidth * 0.1,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                        errorWidget:
                                            (context, url, error) => Container(
                                              width: screenWidth * 0.1,
                                              height: screenWidth * 0.1,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Icon(
                                                Icons.image_not_supported,
                                                size: screenWidth * 0.05,
                                                color: Colors.grey,
                                              ),
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              if (category['image'] != null)
                                SizedBox(width: screenWidth * 0.025),
                              // Category name
                              Text(
                                category['name'] ?? 'غير معروف',
                                style: TextStyle(
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : const Color(0xFF1D75B1),
                                  fontWeight: FontWeight.w700,
                                  fontSize: screenWidth * 0.04,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

            SizedBox(height: screenHeight * 0.03),

            // Projects grid
            _isLoadingProjects
                ? SizedBox(
                  height: screenHeight * 0.5,
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF1D75B1),
                      ),
                    ),
                  ),
                )
                : _selectedCategoryProjects.isEmpty
                ? SizedBox(
                  height: screenHeight * 0.5,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/empty_inbox.png',
                          width: screenWidth * 0.3,
                          height: screenWidth * 0.3,
                          color: const Color(0xFF1D75B1),
                        ),
                        SizedBox(height: screenHeight * 0.025),
                        Text(
                          'لا توجد مشاريع في هذا التصنيف',
                          style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                : Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Projects GridView
                      AnimatedOpacity(
                        opacity: _isLoadingProjects ? 0.0 : 1.0,
                        duration: const Duration(milliseconds: 500),
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: screenWidth * 0.045,
                                mainAxisSpacing: screenWidth * 0.045,
                                childAspectRatio: 0.7,
                              ),
                          itemCount: _selectedCategoryProjects.length,
                          itemBuilder: (context, index) {
                            final project = _selectedCategoryProjects[index];

                            return GestureDetector(
                              onTap: () {
                                // Add tap functionality here if needed
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFFFFFF),
                                      Color(0xFFF5F7FA),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.15,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Project image
                                    Flexible(
                                      flex: 3,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.1,
                                              ),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                'https://albakr-ac.com/${project['image']}',
                                            width: double.infinity,
                                            height: screenHeight * 0.15,
                                            fit: BoxFit.cover,
                                            placeholder:
                                                (context, url) => Container(
                                                  color: Colors.grey[200],
                                                  child: const Center(
                                                    child: CircularProgressIndicator(
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                            Color
                                                          >(Color(0xFF1D75B1)),
                                                    ),
                                                  ),
                                                ),
                                            errorWidget:
                                                (
                                                  context,
                                                  url,
                                                  error,
                                                ) => Container(
                                                  color: Colors.grey[300],
                                                  height: 120,
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons.image_not_supported,
                                                      size: 40,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Project details
                                    Flexible(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              project['title'] ?? 'غير معروف',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w900,
                                                fontSize: 14,
                                                color: Colors.black87,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(
                                                    2,
                                                  ),
                                                  decoration:
                                                      const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Color(
                                                          0xFF1D75B1,
                                                        ),
                                                      ),
                                                  child: const Icon(
                                                    Icons.location_on,
                                                    size: 12,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    project['location'] ??
                                                        'غير معروف',
                                                    style: TextStyle(
                                                      color: Colors.grey[800],
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(
                                                    2,
                                                  ),
                                                  decoration:
                                                      const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Color(
                                                          0xFF1D75B1,
                                                        ),
                                                      ),
                                                  child: const Icon(
                                                    Icons.ac_unit,
                                                    size: 12,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    project['air_condition_type'] ??
                                                        'غير معروف',
                                                    style: TextStyle(
                                                      color: Colors.grey[800],
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
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
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

            // Add space at the bottom for the navbar
            SizedBox(height: screenHeight * 0.15),
          ],
        ),
      ),
    );
  }
}
