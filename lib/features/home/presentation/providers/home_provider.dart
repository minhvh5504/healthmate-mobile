import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../medicine/presentation/providers/medicine/medicine_provider.dart';
import 'home_notifier.dart';

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier(ref, ref.read(getDailyScheduleUseCaseProvider));
});
