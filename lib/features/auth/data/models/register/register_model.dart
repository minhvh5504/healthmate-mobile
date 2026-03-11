import '../../../domain/entities/register.dart';

class RegisterModel extends Register {
  const RegisterModel({
    required super.message,
    required super.success,
    required super.statusCode,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      message: json['message']?.toString() ?? '',
      success: json['success'] ?? false,
      statusCode: json['statusCode'] ?? 200,
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'success': success,
    'statusCode': statusCode,
  };
}
