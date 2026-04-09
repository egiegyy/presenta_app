class UserModel {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? photo;
  final String? gender;
  final int? batchId;
  final int? trainingId;
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
    this.batchId,
    this.trainingId,
    this.batch,
    this.training,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final batchData = json['batch'];
    final trainingData = json['training'];

    return UserModel(
      id: _parseInt(json['id']),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: _parseNullableString(json['phone']),
      photo: _parseNullableString(json['profile_photo'] ?? json['photo']),
      gender: _parseNullableString(json['jenis_kelamin'] ?? json['gender']),
      batchId: _parseNullableInt(json['batch_id']),
      trainingId: _parseNullableInt(json['training_id']),
      batch: _parseNullableString(
        batchData is Map<String, dynamic>
            ? batchData['batch_ke'] ?? batchData['name'] ?? batchData['title']
            : batchData,
      ),
      training: _parseNullableString(
        trainingData is Map<String, dynamic>
            ? trainingData['title'] ?? trainingData['name']
            : trainingData,
      ),
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profile_photo': photo,
      'jenis_kelamin': gender,
      'batch_id': batchId,
      'training_id': trainingId,
      'batch': batch,
      'training': training,
      'created_at': createdAt,
    };
  }
}

int _parseInt(dynamic value) {
  if (value is int) {
    return value;
  }

  return int.tryParse(value?.toString() ?? '') ?? 0;
}

int? _parseNullableInt(dynamic value) {
  if (value == null) {
    return null;
  }

  return int.tryParse(value.toString());
}

String? _parseNullableString(dynamic value) {
  if (value == null) {
    return null;
  }

  final normalizedValue = value.toString().trim();
  return normalizedValue.isEmpty ? null : normalizedValue;
}
