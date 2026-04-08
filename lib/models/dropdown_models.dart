class BatchModel {
  final int id;
  final String name;
  final String? description;
  final List<TrainingModel> trainings;

  BatchModel({
    required this.id,
    required this.name,
    this.description,
    this.trainings = const [],
  });

  factory BatchModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'] ?? json['batch_id'] ?? json['id_batch'];

    final rawName =
        json['name'] ??
        json['batch'] ??
        json['batch_ke'] ??
        json['nama'] ??
        json['nama_batch'] ??
        json['title'];

    final trainings =
        (json['trainings'] as List<dynamic>?)
            ?.map((training) => TrainingModel.fromJson(training))
            .toList() ??
        [];

    return BatchModel(
      id: _parseInt(rawId),
      name: _parseString(rawName),
      description: _parseNullableString(
        json['description'] ?? json['desc'] ?? json['keterangan'],
      ),
      trainings: trainings,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'trainings': trainings.map((t) => t.toJson()).toList(),
    };
  }
}

class TrainingModel {
  final int id;
  final String name;
  final String? description;

  TrainingModel({required this.id, required this.name, this.description});

  factory TrainingModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'] ?? json['training_id'] ?? json['id_training'];

    final rawName =
        json['name'] ??
        json['training'] ??
        json['title'] ??
        json['nama'] ??
        json['nama_training'];

    return TrainingModel(
      id: _parseInt(rawId),
      name: _parseString(rawName),
      description: _parseNullableString(
        json['description'] ?? json['desc'] ?? json['keterangan'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'description': description};
  }
}

// ================= HELPER =================

int _parseInt(dynamic value) {
  if (value == null) return 0;

  if (value is int) return value;

  if (value is String) {
    return int.tryParse(value) ?? 0;
  }

  return 0;
}

String _parseString(dynamic value) {
  if (value == null) return '';

  return value.toString().trim();
}

String? _parseNullableString(dynamic value) {
  if (value == null) return null;

  final result = value.toString().trim();
  return result.isEmpty ? null : result;
}
