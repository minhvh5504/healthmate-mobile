class HealthAnalysis {
  final double? userBMI;
  final double? peerBMI;
  final int? percentage;
  final String status;
  final String? peerDescription;

  const HealthAnalysis({
    this.userBMI,
    this.peerBMI,
    this.percentage,
    required this.status,
    this.peerDescription,
  });
}
