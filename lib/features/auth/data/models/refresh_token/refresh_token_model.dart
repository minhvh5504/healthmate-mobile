import '../../../domain/entities/refresh_token.dart';

class RefreshTokenModel extends RefreshToken {
  const RefreshTokenModel({
    required super.accessToken,
    required super.refreshToken,
    required super.tokenType,
    required super.expiresIn,
  });

  factory RefreshTokenModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;

    if (data == null) {
      throw Exception('Invalid refresh-token response: missing data field');
    }

    return RefreshTokenModel(
      accessToken:
          (data['accessToken'] ?? data['access_token'])?.toString() ?? '',
      refreshToken:
          (data['refreshToken'] ?? data['refresh_token'])?.toString() ?? '',
      tokenType: data['token_type']?.toString() ?? 'Bearer',
      expiresIn: (data['expiresIn'] ?? data['expires_in'])?.toString() ?? '',
    );
  }
}
