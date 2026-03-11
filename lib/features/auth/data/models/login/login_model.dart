import '../../../domain/entities/login.dart';

class LoginModel extends Login {
  const LoginModel({
    required super.accessToken,
    required super.refreshToken,
    required super.tokenType,
    required super.expiresIn,
    super.fullName,
    super.phone,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    final raw = json['data'] is Map ? json['data'] : json;

    final user = raw['user'] is Map ? raw['user'] : {};

    return LoginModel(
      accessToken:
          (raw['accessToken'] ?? raw['access_token'])?.toString() ?? '',
      refreshToken:
          (raw['refreshToken'] ?? raw['refresh_token'])?.toString() ?? '',
      tokenType: raw['token_type']?.toString() ?? 'Bearer',
      expiresIn: (raw['expiresIn'] ?? raw['expires_in'])?.toString() ?? '',

      fullName: user['fullName']?.toString(),
      phone: user['phone']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'accessToken': accessToken,
    'refreshToken': refreshToken,
    'token_type': tokenType,
    'expiresIn': expiresIn,
    'user': {'fullName': fullName, 'phone': phone},
  };
}
