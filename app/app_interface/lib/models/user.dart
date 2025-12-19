class User {
  final String id;
  final String universityId;
  final String role; // 'buyer' or 'seller'
  final String name;
  final String phone;
  final DateTime createdAt;
  final bool isActive;

  User({
    required this.id,
    required this.universityId,
    required this.role,
    required this.name,
    required this.phone,
    required this.createdAt,
    required this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      universityId: json['university_id'],
      role: json['role'],
      name: json['name'],
      phone: json['phone'],
      createdAt: DateTime.parse(json['created_at']),
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'university_id': universityId,
      'role': role,
      'name': name,
      'phone': phone,
      'created_at': createdAt.toIso8601String(),
      'is_active': isActive,
    };
  }
}