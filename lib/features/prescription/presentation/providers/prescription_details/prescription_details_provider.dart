import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/prescription.dart';
import 'prescription_details_notifier.dart';

export 'prescription_details_notifier.dart';

final prescriptionDetailsProvider = StateNotifierProvider.autoDispose
    .family<
      PrescriptionDetailsNotifier,
      PrescriptionDetailsState,
      Prescription?
    >((ref, prescription) => PrescriptionDetailsNotifier(ref, prescription));
