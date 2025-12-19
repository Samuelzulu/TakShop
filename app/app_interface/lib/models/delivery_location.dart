class DeliveryLocation {
  final String id;
  final String universityId;
  final String name;
  final String? description;
  final bool isActive;
  final int sortOrder;

  DeliveryLocation({
    required this.id,
    required this.universityId,
    required this.name,
    this.description,
    required this.isActive,
    required this.sortOrder,
  });

  factory DeliveryLocation.fromJson(Map<String, dynamic> json) {
    return DeliveryLocation(
      id: json['id'],
      universityId: json['university_id'],
      name: json['name'],
      description: json['description'],
      isActive: json['is_active'] ?? true,
      sortOrder: json['sort_order'] ?? 0,
    );
  }
}
