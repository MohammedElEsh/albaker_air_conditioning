// Flutter imports
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

// App-specific imports
import '../../services/works_service.dart';

/// WorksScreen - Displays our works with type filtering
class WorksScreen extends StatefulWidget {
  const WorksScreen({super.key});

  @override
  State<WorksScreen> createState() => _WorksScreenState();
}

class _WorksScreenState extends State<WorksScreen> {
  // Services
  final WorksService _worksService = WorksService();

  // State variables
  List<dynamic> _allWorks = [];
  List<dynamic> _filteredWorks = [];
  bool _isLoading = true;
  String _selectedType = 'all'; // Default filter is 'all'

  // Work types
  final List<Map<String, String>> _workTypes = [
    {'id': 'all', 'name': 'الكل'},
    {'id': 'installation', 'name': 'التركيب'},
    {'id': 'maintenance', 'name': 'الصيانة'},
    {'id': 'cleaning', 'name': 'التنظيف'},
  ];

  @override
  void initState() {
    super.initState();
    _loadAllWorks();
  }

  /// Load all works from API
  Future<void> _loadAllWorks() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final response = await _worksService.getAllWorks();
      if (response.statusCode == 200) {
        setState(() {
          _allWorks = response.data['data'] ?? [];
          _filteredWorks = _allWorks; // Initially show all works
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

  /// Load works filtered by type
  Future<void> _loadWorksByType(String type) async {
    if (type == 'all') {
      // If "all" is selected, simply use the cached allWorks
      setState(() {
        _filteredWorks = _allWorks;
      });
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });
      final response = await _worksService.getWorksByType(type);
      if (response.statusCode == 200) {
        setState(() {
          _filteredWorks = response.data['data'] ?? [];
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

  /// Handle type filter selection
  void _selectType(String type) {
    if (_selectedType != type) {
      setState(() {
        _selectedType = type;
      });
      _loadWorksByType(type);
    }
  }

  /// Pull to refresh data
  Future<void> _refreshData() async {
    if (_selectedType == 'all') {
      await _loadAllWorks();
    } else {
      await _loadWorksByType(_selectedType);
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
                    "أعمالنا",
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

            // Work types horizontal list
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _workTypes.length,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemBuilder: (context, index) {
                  final type = _workTypes[index];
                  final isSelected = _selectedType == type['id'];

                  return GestureDetector(
                    onTap: () => _selectType(type['id']!),
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? const Color(0xFF1D75B1) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF1D75B1),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          type['name']!,
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

            // Works list
            _isLoading
                ? const SizedBox(
                  height: 400,
                  child: Center(child: CircularProgressIndicator()),
                )
                : _filteredWorks.isEmpty
                ? const SizedBox(
                  height: 400,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.work_outline,
                          size: 100,
                          color: Color(0xFF1D75B1),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'لا توجد أعمال في هذا التصنيف',
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
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _filteredWorks.length,
                    itemBuilder: (context, index) {
                      final work = _filteredWorks[index];

                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.only(bottom: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Work image
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                              child: CachedNetworkImage(
                                imageUrl:
                                    'https://albakr-ac.com/${work['image']}',
                                width: double.infinity,
                                height: 200,
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
                                      height: 200,
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

                            // Work details
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title and type
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          work['name'] ?? 'غير معروف',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFF1D75B1,
                                          ).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        child: Text(
                                          _getTypeDisplayName(
                                            work['type'] ?? '',
                                          ),
                                          style: const TextStyle(
                                            color: Color(0xFF1D75B1),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 10),

                                  // Description
                                  Text(
                                    work['description'] ?? '',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  const SizedBox(height: 10),

                                  // Date
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_today,
                                        size: 16,
                                        color: Color(0xFF1D75B1),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        work['created_at'] != null
                                            ? work['created_at']
                                                .toString()
                                                .split('T')[0]
                                            : '',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
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
                ),

            // Add space at the bottom for the navbar
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  /// Convert API type value to display name
  String _getTypeDisplayName(String type) {
    switch (type) {
      case 'installation':
        return 'التركيب';
      case 'maintenance':
        return 'الصيانة';
      case 'cleaning':
        return 'التنظيف';
      default:
        return 'غير معروف';
    }
  }
}
