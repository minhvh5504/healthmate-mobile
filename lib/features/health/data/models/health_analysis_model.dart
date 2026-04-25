import 'package:healthmate_mobile/features/health/domain/entities/health_analysis.dart';

class HealthAnalysisModel extends HealthAnalysis {
  const HealthAnalysisModel({
    super.userBMI,
    super.peerBMI,
    super.percentage,
    required super.status,
    super.peerDescription,
  });

  factory HealthAnalysisModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return HealthAnalysisModel(
      userBMI: (data['userBMI'] as num?)?.toDouble(),
      peerBMI: (data['peerBMI'] as num?)?.toDouble(),
      percentage: (data['percentage'] as num?)?.toInt(),
      status: data['status'] as String,
      peerDescription: data['peerDescription'] as String?,
    );
  }
}
