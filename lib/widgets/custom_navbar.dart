import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomNavbar extends StatefulWidget {
  const CustomNavbar({Key? key}) : super(key: key);

  @override
  State<CustomNavbar> createState() => _CustomNavbarState();
}

class _CustomNavbarState extends State<CustomNavbar> {
  int _selectedIndex = 4; // Default to home (index 4)

  final List<Map<String, String>> _navbarItems = [
    {
      'title': 'المزيد',
      'icon': 'assets/images/dots.png',
      'activeIcon': 'assets/animations/active_dots.json',
    },
    {
      'title': 'أعمالنا',
      'icon': 'assets/images/works.png',
      'activeIcon': 'assets/animations/active_works.json',
    },
    {
      'title': 'مشاريعنا',
      'icon': 'assets/images/trend.png',
      'activeIcon': 'assets/animations/active_trend.json',
    },
    {
      'title': 'العربة',
      'icon': 'assets/images/cart.png',
      'activeIcon': 'assets/animations/active_cart.json',
    },
    {
      'title': 'الرئيسية',
      'icon': 'assets/images/home.png',
      'activeIcon': 'assets/animations/active_home.json',
    },
  ];

  void _onItemTapped(int index, BuildContext context) {
    setState(() {
      _selectedIndex = index;
    });

    NavbarTapNotification(index).dispatch(context);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(17),
            topRight: Radius.circular(17),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            _navbarItems.length,
                (index) => _buildNavItem(index, context),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, BuildContext context) {
    final bool isActive = _selectedIndex == index;
    final item = _navbarItems[index];

    return GestureDetector(
      onTap: () => _onItemTapped(index, context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 30,
            height: 30,
            child: isActive
                ? Lottie.asset(
              item['activeIcon']!,
              repeat: false,
              fit: BoxFit.contain,
              delegates: LottieDelegates(
                values: [
                  ValueDelegate.colorFilter(
                    const ['**'],
                    value: const ColorFilter.mode(
                      Color(0xFF1D75B1),
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            )
                : Image.asset(item['icon']!, fit: BoxFit.contain),
          ),
          const SizedBox(height: 4),
          Text(
            item['title']!,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              color: isActive ? const Color(0xFF1D75B1) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom notification class for navbar taps
class NavbarTapNotification extends Notification {
  final int index;

  NavbarTapNotification(this.index);
}
