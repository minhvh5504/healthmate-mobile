import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'view_all_health_history_notifier.dart';

export 'view_all_health_history_notifier.dart';

final viewAllHealthHistoryProvider =
    StateNotifierProvider.autoDispose<
      ViewAllHealthHistoryNotifier,
      ViewAllHealthHistoryState
    >((ref) => ViewAllHealthHistoryNotifier(ref));
