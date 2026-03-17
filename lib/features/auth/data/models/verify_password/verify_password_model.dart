import '../../../domain/entities/verify_password.dart';

class VerifyPasswordModel extends VerifyPassword {
  const VerifyPasswordModel({
    required super.resetToken,
  });

  factory VerifyPasswordModel.fromJson(Map<String, dynamic> json) {
    final raw = json['data'] is Map ? json['data'] : json;

    return VerifyPasswordModel(
      resetToken: raw['resetToken']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'resetToken': resetToken,
  };
}
