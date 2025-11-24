import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../organisms/navigation/custom_bottom_nav.dart';
import 'classes/class_list_page.dart';
import 'subjects/all_subjects_page.dart';
import 'subjects/protocol_subjects_page.dart';
import 'subjects/export_subjects_page.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ClassListPage(),
    const AllSubjectsPage(),
    const ProtocolSubjectsPage(),
    const ExportSubjectsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          NavItem(icon: Icons.school, label: 'Klassen'),
          NavItem(icon: Icons.book, label: 'Fächer'),
          NavItem(icon: Icons.assignment, label: 'Protokoll'),
          NavItem(icon: Icons.download, label: 'Export'),
        ],
      ),
    );
  }
}
