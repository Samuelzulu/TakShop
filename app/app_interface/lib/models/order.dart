class Order {
  final String id;
  final String universityId;
  final String buyerId;
  final String sellerId;
  final String listingId;
  final String slotId;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String status;
  final String? deliveryLocationId;
  final String? deliveryLocationText;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Additional fields from joins
  String? listingTitle;
  String? listingCategory;
  String? buyerName;
  String? sellerName;
  String? deliveryLocationName;
  DateTime? slotStartTime;
  DateTime? slotEndTime;

  Order({
    required this.id,
    required this.universityId,
    required this.buyerId,
    required this.sellerId,
    required this.listingId,
    required this.slotId,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.status,
    this.deliveryLocationId,
    this.deliveryLocationText,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.listingTitle,
    this.listingCategory,
    this.buyerName,
    this.sellerName,
    this.deliveryLocationName,
    this.slotStartTime,
    this.slotEndTime,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      universityId: json['university_id'],
      buyerId: json['buyer_id'],
      sellerId: json['seller_id'],
      listingId: json['listing_id'],
      slotId: json['slot_id'],
      quantity: json['quantity'],
      unitPrice: (json['unit_price'] as num).toDouble(),
      totalPrice: (json['total_price'] as num).toDouble(),
      status: json['status'],
      deliveryLocationId: json['delivery_location_id'],
      deliveryLocationText: json['delivery_location_text'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      listingTitle: json['listing_title'],
      listingCategory: json['listing_category'],
      buyerName: json['buyer_name'],
      sellerName: json['seller_name'],
      deliveryLocationName: json['delivery_location_name'],
      slotStartTime: json['slot_start_time'] != null
          ? DateTime.parse(json['slot_start_time'])
          : null,
      slotEndTime: json['slot_end_time'] != null
          ? DateTime.parse(json['slot_end_time'])
          : null,
    );
  }
}