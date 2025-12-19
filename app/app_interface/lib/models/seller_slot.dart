class SellerSlot {
  final String id;
  final String universityId;
  final String sellerId;
  final DateTime startTime;
  final DateTime endTime;
  final int capacity;
  final int bookedCount;
  final bool isActive;
  final DateTime createdAt;

  SellerSlot({
    required this.id,
    required this.universityId,
    required this.sellerId,
    required this.startTime,
    required this.endTime,
    required this.capacity,
    required this.bookedCount,
    required this.isActive,
    required this.createdAt,
  });

  factory SellerSlot.fromJson(Map<String, dynamic> json) {
    return SellerSlot(
      id: json['id'],
      universityId: json['university_id'],
      sellerId: json['seller_id'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      capacity: json['capacity'],
      bookedCount: json['booked_count'],
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  bool get isAvailable => bookedCount < capacity && isActive;
  int get spotsLeft => capacity - bookedCount;
}
