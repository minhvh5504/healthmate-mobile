import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../prescription/prescription_provider.dart';
import 'add_prescription_notifier.dart';

export 'add_prescription_notifier.dart';

final addPrescriptionProvider = StateNotifierProvider.autoDispose
    .family<AddPrescriptionNotifier, AddPrescriptionState, Prescription?>(
      (ref, prescription) => AddPrescriptionNotifier(
        ref.read(createPrescriptionProvider),
        prescription,
      ),
    );
