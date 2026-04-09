import 'package:presenta_app/models/user_model.dart';

class AuthSessionModel {
  final String token;
  final UserModel user;

  const AuthSessionModel({required this.token, required this.user});

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return AuthSessionModel(
      token: (data['token'] ?? '').toString(),
      user: UserModel.fromJson(
        data['user'] is Map<String, dynamic>
            ? data['user'] as Map<String, dynamic>
            : <String, dynamic>{},
      ),
    );
  }
}
