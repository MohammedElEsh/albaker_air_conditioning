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

class _ProjectsScreenState extends State<ProjectsScreen> with SingleTickerProviderStateMixin {
  // Services
  final ProjectService _projectService = ProjectService();

  // State variables
  List<dynamic> _projectCategories = [];
  List<dynamic> _selectedCategoryProjects = [];
  int? _selectedCategoryId;
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
  void _selectCategory(int categoryId, String categoryName, String? categoryImage) {
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
    return RefreshIndicator(
      onRefresh: _refreshData,
      color: const Color(0xFF1D75B1),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 60),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 33),
              child: Text(
                "مشاريعنا",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 24,
                  // color: const Color(0xFF1D75B1),
                  // shadows: [
                  //   Shadow(
                  //     blurRadius: 4,
                  //     color: Colors.black.withOpacity(0.1),
                  //     offset: const Offset(0, 2),
                  //   ),
                  // ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Project categories horizontal list
            _isLoadingCategories
                ? const SizedBox(
              height: 80,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1D75B1)),
                ),
              ),
            )
                : _projectCategories.isEmpty
                ? SizedBox(
              height: 80,
              child: Center(
                child: Text(
                  'لا توجد تصنيفات',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            )
                : SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _projectCategories.length,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemBuilder: (context, index) {
                  final category = _projectCategories[index];
                  final isSelected = _selectedCategoryId == category['id'];

                  return GestureDetector(
                    onTap: () => _selectCategory(
                      category['id'],
                      category['name'] ?? '',
                      category['image'],
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected
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
                            color: Colors.black.withOpacity(0.1),
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
                                  color: isSelected ? Colors.white : Colors.transparent,
                                  boxShadow: isSelected
                                      ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                      : null,
                                ),
                                padding: isSelected ? const EdgeInsets.all(2) : null,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                    imageUrl: 'https://albakr-ac.com/${category['image']}',
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Icon(
                                        Icons.image_not_supported,
                                        size: 20,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (category['image'] != null) const SizedBox(width: 10),
                          // Category name
                          Text(
                            category['name'] ?? 'غير معروف',
                            style: TextStyle(
                              color: isSelected ? Colors.white : const Color(0xFF1D75B1),
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 25),

            // Projects grid
            _isLoadingProjects
                ? const SizedBox(
              height: 400,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1D75B1)),
                ),
              ),
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
                      width: 120,
                      height: 120,
                      color: const Color(0xFF1D75B1),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'لا توجد مشاريع في هذا التصنيف',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
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
                  // Projects GridView
                  AnimatedOpacity(
                    opacity: _isLoadingProjects ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 500),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 18,
                        mainAxisSpacing: 18,
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
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Project image
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
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
                                      imageUrl: 'https://albakr-ac.com/${project['image']}',
                                      width: double.infinity,
                                      height: 150,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        color: Colors.grey[200],
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                              Color(0xFF1D75B1),
                                            ),
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) => Container(
                                        color: Colors.grey[300],
                                        height: 150,
                                        child: const Center(
                                          child: Icon(
                                            Icons.image_not_supported,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // Project details
                                Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        project['title'] ?? 'غير معروف',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(3),
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xFF1D75B1),
                                            ),
                                            child: const Icon(
                                              Icons.location_on,
                                              size: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              project['location'] ?? 'غير معروف',
                                              style: TextStyle(
                                                color: Colors.grey[800],
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(3),
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xFF1D75B1),
                                            ),
                                            child: const Icon(
                                              Icons.ac_unit,
                                              size: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              project['air_condition_type'] ?? 'غير معروف',
                                              style: TextStyle(
                                                color: Colors.grey[800],
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
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
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Add space at the bottom for the navbar
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}