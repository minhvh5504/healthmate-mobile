import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../domain/entities/prescription.dart';
import '../../../domain/usecases/update_prescription.dart';
import '../../../../../core/routing/app_router.dart';

class EditPrescriptionState {
  final Prescription? initialPrescription;
  final String doctorName;
  final String clinicName;
  final String note;
  final DateTime startDate;
  final DateTime endDate;
  final File? image;
  final bool isSaving;
  final String? errorMessage;
  final String? successMessage;

  const EditPrescriptionState({
    this.initialPrescription,
    this.doctorName = '',
    this.clinicName = '',
    this.note = '',
    required this.startDate,
    required this.endDate,
    this.image,
    this.isSaving = false,
    this.errorMessage,
    this.successMessage,
  });

  factory EditPrescriptionState.initial(Prescription? prescription) {
    final now = DateTime.now();
    return EditPrescriptionState(
      initialPrescription: prescription,
      doctorName: prescription?.doctorName ?? '',
      clinicName: prescription?.clinicName ?? '',
      note: prescription?.note ?? '',
      startDate: prescription?.startDate ?? now,
      endDate: prescription?.endDate ?? now.add(const Duration(days: 30)),
    );
  }

  bool get isValid {
    final hasImage =
        image != null ||
        (initialPrescription?.imageUrl != null &&
            initialPrescription!.imageUrl!.isNotEmpty);
    return hasImage &&
        doctorName.trim().isNotEmpty &&
        clinicName.trim().isNotEmpty;
  }

  bool get hasChanges {
    if (initialPrescription == null) return false;
    final prescription = initialPrescription!;

    bool isSameDay(DateTime d1, DateTime? d2) {
      if (d2 == null) return false;
      return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
    }

    return image != null ||
        doctorName != prescription.doctorName ||
        clinicName != prescription.clinicName ||
        note != (prescription.note ?? '') ||
        !isSameDay(startDate, prescription.startDate) ||
        !isSameDay(endDate, prescription.endDate);
  }

  EditPrescriptionState copyWith({
    Prescription? initialPrescription,
    String? doctorName,
    String? clinicName,
    String? note,
    DateTime? startDate,
    DateTime? endDate,
    File? image,
    bool clearImage = false,
    bool? isSaving,
    String? errorMessage,
    bool clearError = false,
    String? successMessage,
    bool clearSuccess = false,
  }) {
    return EditPrescriptionState(
      initialPrescription: initialPrescription ?? this.initialPrescription,
      doctorName: doctorName ?? this.doctorName,
      clinicName: clinicName ?? this.clinicName,
      note: note ?? this.note,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      image: clearImage ? null : image ?? this.image,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearError ? null : errorMessage,
      successMessage: clearSuccess ? null : successMessage,
    );
  }
}

class EditPrescriptionNotifier extends StateNotifier<EditPrescriptionState> {
  final UpdatePrescription _updatePrescription;

  EditPrescriptionNotifier(this._updatePrescription, Prescription? prescription)
    : super(EditPrescriptionState.initial(prescription));

  final ImagePicker _imagePicker = ImagePicker();

  void updateDoctorName(String value) {
    state = state.copyWith(
      doctorName: value,
      clearError: true,
      clearSuccess: true,
    );
  }

  void updateClinicName(String value) {
    state = state.copyWith(
      clinicName: value,
      clearError: true,
      clearSuccess: true,
    );
  }

  void updateNote(String value) {
    state = state.copyWith(note: value, clearError: true, clearSuccess: true);
  }

  void selectStartDate(DateTime date) {
    var endDate = state.endDate;
    final minEndDate = date.add(const Duration(days: 1));
    if (endDate.isBefore(minEndDate)) {
      endDate = minEndDate;
    }
    state = state.copyWith(
      startDate: date,
      endDate: endDate,
      clearError: true,
      clearSuccess: true,
    );
  }

  void selectEndDate(DateTime date) {
    final minEndDate = state.startDate.add(const Duration(days: 1));
    final endDate = date.isBefore(minEndDate) ? minEndDate : date;
    state = state.copyWith(
      endDate: endDate,
      clearError: true,
      clearSuccess: true,
    );
  }

  Future<void> pickImage(ImageSource source) async {
    final image = await _imagePicker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1800,
    );
    if (image == null) return;

    final file = File(image.path);
    final fileSize = await file.length();
    if (fileSize > 10 * 1024 * 1024) {
      state = state.copyWith(
        errorMessage: 'prescription.add.image_too_large'.tr(),
        clearSuccess: true,
      );
      return;
    }

    state = state.copyWith(image: file, clearError: true, clearSuccess: true);
  }

  Future<void> save() async {
    if (state.isSaving) return;
    if (state.initialPrescription == null) return;

    state = state.copyWith(
      isSaving: true,
      clearError: true,
      clearSuccess: true,
    );
    try {
      await _updatePrescription(
        id: state.initialPrescription!.id,
        doctorName: state.doctorName,
        clinicName: state.clinicName,
        note: state.note,
        startDate: state.startDate,
        endDate: state.endDate,
        imageFile: state.image,
        status: state.initialPrescription!.isActive ? null : 'ACTIVE',
      );
      state = state.copyWith(
        isSaving: false,
        successMessage: 'prescription.add.save_pending'.tr(),
      );
      AppRouter.router.pop(true);
    } catch (e) {
      state = state.copyWith(isSaving: false, errorMessage: e.toString());
    }
  }

  void clearMessages() {
    state = state.copyWith(clearError: true, clearSuccess: true);
  }

  /// Discard and go back.
  void handleGoBack() => AppRouter.router.pop();
}
