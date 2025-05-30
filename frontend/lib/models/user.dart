// models/user.dart

class User {
  final int id;
  final String email;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String? mobile;
  final String? avatarUrl;
  final String? basiqUserId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastLoginAt;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    this.middleName,
    required this.lastName,
    this.mobile,
    this.avatarUrl,
    this.basiqUserId,
    required this.createdAt,
    required this.updatedAt,
    this.lastLoginAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      middleName: json['middleName'] as String?,
      lastName: json['lastName'] as String,
      mobile: json['mobile'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      basiqUserId: json['basiqUserId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      lastLoginAt: json['lastLoginAt'] != null ? DateTime.parse(json['lastLoginAt'] as String) : null,
    );
  }
}
