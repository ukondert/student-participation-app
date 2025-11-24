import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../organisms/navigation/custom_bottom_nav.dart';
import 'classes/class_list_page.dart';
import '../screens/all_subjects_screen.dart';
import '../screens/protocol_subjects_screen.dart';
import '../screens/export_subjects_screen.dart';

/// Main Page
/// 
/// The main shell of the application, providing the bottom navigation
/// and switching between the main content pages.
class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    ClassListPage(),
    AllSubjectsScreen(),
    ProtocolSubjectsScreen(),
    ExportSubjectsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          NavItem(
            icon: Icons.school,
            label: 'Klasse',
          ),
          NavItem(
            icon: Icons.book,
            label: 'Fächer',
          ),
          NavItem(
            icon: Icons.assignment,
            label: 'Protokoll',
          ),
          NavItem(
            icon: Icons.file_download,
            label: 'Export',
          ),
        ],
      ),
    );
  }
}
