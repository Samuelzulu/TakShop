class University {
  final String id;
  final String name;
  final String? city;
  final bool isActive;
  final DateTime createdAt;

  University({
    required this.id,
    required this.name,
    this.city,
    required this.isActive,
    required this.createdAt,
  });

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      id: json['id'],
      name: json['name'],
      city: json['city'],
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
    };
  }
}