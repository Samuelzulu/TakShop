class Listing {
  final String id;
  final String universityId;
  final String sellerId;
  final String title;
  final String description;
  final double price;
  final String currency;
  final String category;
  final bool isActive;
  final DateTime createdAt;
  final List<String> photoUrls;

  // Additional fields from joins
  String? sellerName;
  double? rating;
  int? reviewCount;

  Listing({
    required this.id,
    required this.universityId,
    required this.sellerId,
    required this.title,
    required this.description,
    required this.price,
    required this.currency,
    required this.category,
    required this.isActive,
    required this.createdAt,
    required this.photoUrls,
    this.sellerName,
    this.rating,
    this.reviewCount,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    List<String> photos = [];
    if (json['listing_photos'] != null) {
      photos = (json['listing_photos'] as List)
          .map((p) => p['url'] as String)
          .toList();
    }

    return Listing(
      id: json['id'],
      universityId: json['university_id'],
      sellerId: json['seller_id'],
      title: json['title'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] ?? 'ZMW',
      category: json['category'],
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      photoUrls: photos,
      sellerName: json['seller']?['name'],
      rating: json['rating']?.toDouble(),
      reviewCount: json['review_count'],
    );
  }
}