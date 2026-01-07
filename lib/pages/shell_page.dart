import 'package:flutter/material.dart';
import 'home_page.dart';
import 'explore_page.dart';
import 'profile_page.dart';

class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int _index = 0;

  String? _selectedCity;     
  String? _selectedCategory; 

  void _applyFilters({String? city, String? category}) {
    setState(() {
      _selectedCity = (city == null || city == 'Tümü') ? null : city;
      _selectedCategory = (category == null || category == 'Tümü') ? null : category;
      _index = 0; // filtre uygula -> ana sayfaya dön
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomePage(
        selectedCity: _selectedCity,
        selectedCategory: _selectedCategory,
      ),
      ExplorePage(
        selectedCity: _selectedCity,
        selectedCategory: _selectedCategory,
        onApply: _applyFilters,
      ),
      const ProfilePage(),
    ];

    return Scaffold(
      body: SafeArea(child: pages[_index]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Ana Sayfa'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Keşfet'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Hesap'),
        ],
      ),
    );
  }
}
