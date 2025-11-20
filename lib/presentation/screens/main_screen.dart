import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'class_list_screen.dart';
import 'all_subjects_screen.dart';
import 'protocol_subjects_screen.dart';
import 'export_subjects_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    ClassListScreen(),
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Klasse',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Fächer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Protokoll',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_download),
            label: 'Export',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
