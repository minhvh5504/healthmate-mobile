import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../prescription/prescription_provider.dart';
import 'edit_prescription_notifier.dart';

export 'edit_prescription_notifier.dart';

final editPrescriptionProvider = StateNotifierProvider.autoDispose
    .family<EditPrescriptionNotifier, EditPrescriptionState, Prescription?>(
  (ref, prescription) => EditPrescriptionNotifier(
    ref.read(updatePrescriptionProvider),
    prescription,
  ),
);
