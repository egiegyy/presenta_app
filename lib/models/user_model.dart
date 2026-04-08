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
      phone: json['phone']?.toString(),
      photo: json['profile_photo']?.toString() ?? json['photo']?.toString(),
      gender: json['jenis_kelamin']?.toString() ?? json['gender']?.toString(),
      batch: json['batch']?.toString() ?? json['batch_name']?.toString(),
      training:
          json['training']?.toString() ??
          json['training_name']?.toString() ??
          json['title']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
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
