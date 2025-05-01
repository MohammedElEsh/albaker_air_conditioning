// Flutter imports
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

// App-specific imports
import '../../services/projects_service.dart';

/// ProjectsScreen - Display project categories and projects
class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  // Services
  final ProjectService _projectService = ProjectService();

  // State variables
  List<dynamic> _projectCategories = [];
  List<dynamic> _selectedCategoryProjects = [];
  int? _selectedCategoryId;
  String _selectedCategoryName = '';
  bool _isLoadingCategories = true;
  bool _isLoadingProjects = false;

  @override
  void initState() {
    super.initState();
    _loadProjectCategories();
  }

  /// Load project categories from API
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
            _selectedCategoryName = _projectCategories[0]['name'] ?? '';
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

  /// Load projects by selected category
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
  void _selectCategory(int categoryId, String categoryName) {
    if (_selectedCategoryId != categoryId) {
      setState(() {
        _selectedCategoryId = categoryId;
        _selectedCategoryName = categoryName;
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
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 60),
            // Header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 33),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "مشاريعنا",
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

            // Project categories horizontal list
            _isLoadingCategories
                ? const SizedBox(
                  height: 60,
                  child: Center(child: CircularProgressIndicator()),
                )
                : _projectCategories.isEmpty
                ? const SizedBox(
                  height: 60,
                  child: Center(
                    child: Text(
                      'لا توجد تصنيفات',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                )
                : SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _projectCategories.length,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemBuilder: (context, index) {
                      final category = _projectCategories[index];
                      final isSelected = _selectedCategoryId == category['id'];

                      return GestureDetector(
                        onTap:
                            () => _selectCategory(
                              category['id'],
                              category['name'] ?? '',
                            ),
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? const Color(0xFF1D75B1)
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFF1D75B1),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              category['name'] ?? 'غير معروف',
                              style: TextStyle(
                                color:
                                    isSelected
                                        ? Colors.white
                                        : const Color(0xFF1D75B1),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

            const SizedBox(height: 20),

            // Projects grid
            _isLoadingProjects
                ? const SizedBox(
                  height: 400,
                  child: Center(child: CircularProgressIndicator()),
                )
                : _selectedCategoryProjects.isEmpty
                ? SizedBox(
                  height: 400,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/empty_inbox.png',
                          width: 100,
                          height: 100,
                          color: const Color(0xFF1D75B1),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'لا توجد مشاريع في هذا التصنيف',
                          style: TextStyle(
                            fontSize: 18,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category title
                      Padding(
                        padding: const EdgeInsets.only(right: 10, bottom: 15),
                        child: Text(
                          _selectedCategoryName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D75B1),
                          ),
                        ),
                      ),

                      // Projects GridView
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              childAspectRatio: 0.8,
                            ),
                        itemCount: _selectedCategoryProjects.length,
                        itemBuilder: (context, index) {
                          final project = _selectedCategoryProjects[index];

                          return Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Project image
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        'https://albakr-ac.com/${project['image']}',
                                    width: double.infinity,
                                    height: 120,
                                    fit: BoxFit.cover,
                                    placeholder:
                                        (context, url) => Container(
                                          color: Colors.grey[200],
                                          child: const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                                    errorWidget:
                                        (context, url, error) => Container(
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

                                // Project details
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        project['title'] ?? 'غير معروف',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            size: 12,
                                            color: Color(0xFF1D75B1),
                                          ),
                                          const SizedBox(width: 3),
                                          Text(
                                            project['location'] ?? 'غير معروف',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 3),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.ac_unit,
                                            size: 12,
                                            color: Color(0xFF1D75B1),
                                          ),
                                          const SizedBox(width: 3),
                                          Expanded(
                                            child: Text(
                                              project['air_condition_type'] ??
                                                  'غير معروف',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

            // Add space at the bottom for the navbar
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
