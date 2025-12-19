class Review {
  final String id;
  final String orderId;
  final String reviewerId;
  final String revieweeId;
  final String listingId;
  final int rating;
  final String? comment;
  final DateTime createdAt;

  String? reviewerName;
  String? revieweeName;

  Review({
    required this.id,
    required this.orderId,
    required this.reviewerId,
    required this.revieweeId,
    required this.listingId,
    required this.rating,
    this.comment,
    required this.createdAt,
    this.reviewerName,
    this.revieweeName,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      orderId: json['order_id'],
      reviewerId: json['reviewer_id'],
      revieweeId: json['reviewee_id'],
      listingId: json['listing_id'],
      rating: json['rating'],
      comment: json['comment'],
      createdAt: DateTime.parse(json['created_at']),
      reviewerName: json['reviewer_name'],
      revieweeName: json['reviewee_name'],
    );
  }
}
