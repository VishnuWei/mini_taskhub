import 'package:flutter/material.dart';
import 'package:mini_taskhub/pages/dashboard/dashboard_screen.dart';

import '../profile/my_profile_view_screen.dart';

class HomeScreenNotifier extends ChangeNotifier {
  final int? selectedPage;

  HomeScreenNotifier({
    this.selectedPage = 0,
  });

  static BuildContext? _context;

  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _pageData = [
    {
      'title': 'Home',
      'label': 'Home',
      'actions': [],
      'icon': Icons.home_outlined,
      'fabExists': false,
      'activeIcon': Icons.home,
      'page': const DashboardScreen(),
    },
    {
      'title': 'Profile',
      'label': 'Profile',
      'fabExists': false,
      'actions': [],
      'icon': Icons.person_outline,
      'activeIcon': Icons.person,
      'page': const MyProfileViewScreen(),
    }
  ];

  List<Map<String, dynamic>> get getPageData => _pageData;

  int get getSelectedIndex => _selectedIndex;

  static BuildContext get contextData => _context!;

  updateContext(BuildContext context) {
    _context = context;
    notifyListeners();
  }

  void onTabTapped(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}