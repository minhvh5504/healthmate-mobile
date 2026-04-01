import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_notifier.dart';

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier(ref);
});
