import 'package:healthmate_mobile/features/health/domain/entities/health_analysis.dart';
import 'package:healthmate_mobile/features/health/domain/entities/user_profile.dart';
import 'package:healthmate_mobile/features/health/domain/repositories/health_repository.dart';
import 'package:healthmate_mobile/features/health/data/datasources/health_remote_datasource.dart';

class HealthRepositoryImpl implements HealthRepository {
  final HealthRemoteDataSource remoteDataSource;

  HealthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserProfile> getProfile() {
    return remoteDataSource.getProfile();
  }

  @override
  Future<UserProfile> updateProfile(UserProfile profile) {
    return remoteDataSource.updateProfile(profile);
  }

  @override
  Future<HealthAnalysis> getHealthAnalysis() {
    return remoteDataSource.getHealthAnalysis();
  }
}
