import 'user_medication.dart';

enum ScanStatus {
  processing,
  success,
  failed,
}

class ScanTask {
  final String id;
  final DateTime createdAt;
  final ScanStatus status;
  final String? errorMessage;
  final String? imagePath;
  final List<UserMedication>? userMedications;

  const ScanTask({
    required this.id,
    required this.createdAt,
    required this.status,
    this.errorMessage,
    this.imagePath,
    this.userMedications,
  });

  ScanTask copyWith({
    ScanStatus? status,
    String? errorMessage,
    String? imagePath,
    List<UserMedication>? userMedications,
  }) {
    return ScanTask(
      id: id,
      createdAt: createdAt,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      imagePath: imagePath ?? this.imagePath,
      userMedications: userMedications ?? this.userMedications,
    );
  }
}
