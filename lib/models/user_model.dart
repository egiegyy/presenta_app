class UserModel {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? photo;
  final String? gender;
  final String? batch;
  final String? training;
  final String createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.photo,
    this.gender,
    this.batch,
    this.training,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      photo: json['photo'],
      gender: json['gender'],
      batch: json['batch'],
      training: json['training'],
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'photo': photo,
      'gender': gender,
      'batch': batch,
      'training': training,
      'created_at': createdAt,
    };
  }
}
