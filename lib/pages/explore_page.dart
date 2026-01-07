import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  final String? selectedCity;
  final String? selectedCategory;
  final void Function({String? city, String? category}) onApply;

  const ExplorePage({
    super.key,
    required this.selectedCity,
    required this.selectedCategory,
    required this.onApply,
  });

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late String _city;
  late String _category;

  final cities = const [
    'Tümü',
    'İzmir',
    'Ankara',
    'İstanbul',
    'Bursa',
    'Antalya',
  ];

  final categories = const [
    'Tümü',
    'Konser',
    'Tiyatro',
    'Festival',
  ];

  @override
  void initState() {
    super.initState();
    _city = widget.selectedCity ?? 'Tümü';
    _category = widget.selectedCategory ?? 'Tümü';
  }

  InputDecoration _dec(String label) => InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE6E8F0)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Keşfet", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),

          DropdownButtonFormField<String>(
            value: _city,
            items: cities.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (v) => setState(() => _city = v ?? 'Tümü'),
            decoration: _dec("Şehir"),
            borderRadius: BorderRadius.circular(16),
          ),
          const SizedBox(height: 12),

          DropdownButtonFormField<String>(
            value: _category,
            items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (v) => setState(() => _category = v ?? 'Tümü'),
            decoration: _dec("Kategori"),
            borderRadius: BorderRadius.circular(16),
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => widget.onApply(city: _city, category: _category),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text("Uygula"),
            ),
          ),
        ],
      ),
    );
  }
}