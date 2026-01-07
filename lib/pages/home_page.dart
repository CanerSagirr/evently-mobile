import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/api_service.dart';

class HomePage extends StatefulWidget {
  final String? selectedCity;
  final String? selectedCategory;

  const HomePage({
    super.key,
    this.selectedCity,
    this.selectedCategory,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<EventModel> _events = [];
  bool _loading = true;
  String _q = "";

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final list = await ApiService.getEvents();
      setState(() {
        _events = list;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Etkinlikler alınamadı: $e")),
      );
    }
  }

  List<EventModel> get _visible {
    final city = widget.selectedCity?.trim().toLowerCase();
    final cat = widget.selectedCategory?.trim().toLowerCase();

    return _events.where((e) {
      final okQ = _q.trim().isEmpty
          ? true
          : (e.title.toLowerCase().contains(_q.toLowerCase()) ||
              e.venue.toLowerCase().contains(_q.toLowerCase()) ||
              e.city.toLowerCase().contains(_q.toLowerCase()));

      final okCity = (city == null) ? true : e.city.trim().toLowerCase() == city;
      final okCat = (cat == null) ? true : e.category.trim().toLowerCase() == cat;

      return okQ && okCity && okCat;
    }).toList();
  }

  String _dateBadge(DateTime dt) {
    const months = ["OCA","ŞUB","MAR","NİS","MAY","HAZ","TEM","AĞU","EYL","EKİ","KAS","ARA"];
    final d = dt.day.toString().padLeft(2, '0');
    final m = months[(dt.month - 1).clamp(0, 11)];
    return "$d $m";
  }

  String _timeText(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return "$h:$m";
  }

  @override
  Widget build(BuildContext context) {
    final list = _visible;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
            child: Row(
              children: [
                const Expanded(
                  child: Text("Etkinlikler",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                ),
                IconButton(
                  onPressed: _load,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              onChanged: (v) => setState(() => _q = v),
              decoration: InputDecoration(
                hintText: "Ara: sanatçı, mekan, şehir...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFFE6E8F0)),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : list.isEmpty
                    ? const Center(child: Text("Etkinlik yok"))
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 0.70,
                        ),
                        itemCount: list.length,
                        itemBuilder: (context, i) => _eventCard(list[i]),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _eventCard(EventModel e) {
    final dateText = _dateBadge(e.startAt);
    final timeText = _timeText(e.startAt);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE6E8F0)),
          boxShadow: const [
            BoxShadow(
              blurRadius: 14,
              offset: Offset(0, 6),
              color: Color(0x11000000),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: AspectRatio(
                aspectRatio: 1.2,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    (e.imageUrl == null)
                        ? Container(color: const Color(0xFFEFEFF4))
                        : Image.network(e.imageUrl!, fit: BoxFit.cover),

                    Positioned(
                      left: 10,
                      top: 10,
                      child: _pill(text: dateText, bg: Colors.white, fg: const Color(0xFF111827)),
                    ),
                    Positioned(
                      left: 10,
                      top: 44,
                      child: _pill(text: timeText, bg: Colors.white, fg: const Color(0xFF111827)),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: _pill(text: e.category, bg: const Color(0xFF111827), fg: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
              child: Text(
                e.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
              child: Text(
                "${e.city} • ${e.venue}",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pill({required String text, required Color bg, required Color fg}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE6E8F0)),
      ),
      child: Text(text, style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w800)),
    );
  }
}