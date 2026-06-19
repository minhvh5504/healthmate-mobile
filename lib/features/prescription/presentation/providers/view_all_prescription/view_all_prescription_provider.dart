import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'view_all_prescription_notifier.dart';

export 'view_all_prescription_notifier.dart';

final viewAllPrescriptionProvider = StateNotifierProvider.autoDispose<
    ViewAllPrescriptionNotifier, ViewAllPrescriptionState>(
  (ref) => ViewAllPrescriptionNotifier(ref),
);
