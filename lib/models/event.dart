class EventModel {
  final int id;
  final String title;
  final String category;
  final DateTime startAt;
  final String city;
  final String venue;
  final String? imageUrl;

  EventModel({
    required this.id,
    required this.title,
    required this.category,
    required this.startAt,
    required this.city,
    required this.venue,
    this.imageUrl,
  });

  static EventModel fromJson(Map<String, dynamic> j) {
    int parseInt(dynamic v) => int.tryParse(v?.toString() ?? '') ?? 0;

    final rawDate =
        (j['startAt'] ?? j['StartAt'] ?? j['date'] ?? j['Date'])?.toString();

    final dt = (rawDate == null || rawDate.trim().isEmpty)
        ? DateTime.now()
        : (DateTime.tryParse(rawDate) ?? DateTime.now());

    final img = (j['imageUrl'] ?? j['ImageUrl'] ?? j['image'] ?? '')
        .toString()
        .trim();

    return EventModel(
      id: parseInt(j['id'] ?? j['Id']),
      title: (j['title'] ?? j['Title'] ?? '').toString(),
      category: (j['category'] ?? j['Category'] ?? 'Etkinlik').toString(),
      startAt: dt,
      city: (j['city'] ?? j['City'] ?? '').toString(),
      venue: (j['venue'] ?? j['Venue'] ?? '').toString(),
      imageUrl: img.isEmpty ? null : img,
    );
  }
}