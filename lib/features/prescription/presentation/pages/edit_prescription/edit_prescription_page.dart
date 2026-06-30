import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/app_toast.dart';
import '../../../../../core/widgets/button/button.dart';
import '../../../domain/entities/prescription.dart';
import '../../providers/edit_prescription/edit_prescription_provider.dart';
import 'widgets/edit_prescription_date_field.dart';
import 'widgets/edit_prescription_header.dart';
import 'widgets/edit_prescription_image_picker.dart';
import 'widgets/edit_prescription_text_field.dart';

class EditPrescriptionPage extends ConsumerStatefulWidget {
  const EditPrescriptionPage({super.key, this.prescription});

  final Prescription? prescription;

  @override
  ConsumerState<EditPrescriptionPage> createState() =>
      _EditPrescriptionPageState();
}

class _EditPrescriptionPageState extends ConsumerState<EditPrescriptionPage>
    with WidgetsBindingObserver {
  late final TextEditingController _doctorController;
  late final TextEditingController _clinicController;
  late final TextEditingController _noteController;
  late final FocusNode _doctorFocusNode;
  late final FocusNode _clinicFocusNode;
  late final FocusNode _noteFocusNode;
  late final ScrollController _scrollController;
  final GlobalKey _noteFieldKey = GlobalKey();
  double? _scrollOffsetBeforeNoteFocus;
  bool _wasKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final initialState = EditPrescriptionState.initial(widget.prescription);
    _doctorController = TextEditingController(text: initialState.doctorName);
    _clinicController = TextEditingController(text: initialState.clinicName);
    _noteController = TextEditingController(text: initialState.note);
    _doctorFocusNode = FocusNode();
    _clinicFocusNode = FocusNode();
    _noteFocusNode = FocusNode();
    _scrollController = ScrollController();
    _noteFocusNode.addListener(_handleNoteFocusChanged);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _noteFocusNode.removeListener(_handleNoteFocusChanged);
    _doctorController.dispose();
    _clinicController.dispose();
    _noteController.dispose();
    _doctorFocusNode.dispose();
    _clinicFocusNode.dispose();
    _noteFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _showImageSourceSheet(EditPrescriptionNotifier notifier) async {
    _unfocusInputs();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt_rounded),
                  title: Text('prescription.add.camera'.tr()),
                  onTap: () => Navigator.of(context).pop(ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_rounded),
                  title: Text('prescription.add.gallery'.tr()),
                  onTap: () => Navigator.of(context).pop(ImageSource.gallery),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (source != null) await notifier.pickImage(source);
  }

  Future<void> _selectDate({
    required EditPrescriptionNotifier notifier,
    required DateTime initialDate,
    required DateTime firstDate,
    required bool isStartDate,
  }) async {
    _unfocusInputs();
    final pickerFirstDate = DateUtils.dateOnly(firstDate);
    final pickerInitialDate = initialDate.isBefore(pickerFirstDate)
        ? pickerFirstDate
        : initialDate;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: pickerInitialDate,
      firstDate: pickerFirstDate,
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4F46E5),
              onPrimary: Colors.white,
              onSurface: AppColors.typoBlack,
            ),
          ),
          child: child!,
        );
      },
    );

    _unfocusInputs();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _unfocusInputs();
    });

    if (pickedDate == null) return;
    if (isStartDate) {
      notifier.selectStartDate(pickedDate);
    } else {
      notifier.selectEndDate(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = editPrescriptionProvider(widget.prescription);
    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

    ref.listen<EditPrescriptionState>(provider, (previous, next) {
      final errorMessage = next.errorMessage;
      final successMessage = next.successMessage;

      if (errorMessage != null && errorMessage != previous?.errorMessage) {
        AppToast.error(errorMessage);
        notifier.clearMessages();
        return;
      }

      if (successMessage == null ||
          successMessage == previous?.successMessage) {
        return;
      }
      AppToast.success(successMessage);
      notifier.clearMessages();
    });

    return Scaffold(
      backgroundColor: AppColors.lightBlue,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _unfocusInputs,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: AppColors.backgroundGradient,
          ),
          child: SafeArea(
            child: Column(
              children: [
                const EditPrescriptionHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.fromLTRB(18.w, 0.h, 18.w, 20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EditPrescriptionImagePicker(
                          image: state.image,
                          imageUrl: widget.prescription?.imageUrl,
                          onChangeTap: () => _showImageSourceSheet(notifier),
                          onViewImage:
                              (state.image != null ||
                                  (widget.prescription?.imageUrl != null &&
                                      widget
                                          .prescription!
                                          .imageUrl!
                                          .isNotEmpty))
                              ? () => _showLargeImage(
                                  context,
                                  file: state.image,
                                  url: widget.prescription?.imageUrl,
                                )
                              : null,
                        ),
                        SizedBox(height: 18.h),
                        EditPrescriptionTextField(
                          label: 'prescription.add.doctor_label'.tr(),
                          hintText: 'prescription.add.doctor_hint'.tr(),
                          icon: LucideIcons.user,
                          controller: _doctorController,
                          focusNode: _doctorFocusNode,
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_) => _clinicFocusNode.requestFocus(),
                          onChanged: notifier.updateDoctorName,
                        ),
                        SizedBox(height: 14.h),
                        EditPrescriptionTextField(
                          label: 'prescription.add.clinic_label'.tr(),
                          hintText: 'prescription.add.clinic_hint'.tr(),
                          icon: LucideIcons.building2,
                          controller: _clinicController,
                          focusNode: _clinicFocusNode,
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_) => _noteFocusNode.requestFocus(),
                          onChanged: notifier.updateClinicName,
                        ),
                        SizedBox(height: 14.h),
                        Row(
                          children: [
                            Expanded(
                              child: EditPrescriptionDateField(
                                label: 'prescription.add.start_date'.tr(),
                                value: _isToday(state.startDate)
                                    ? 'prescription.add.today'.tr()
                                    : _formatDate(state.startDate),
                                onTap: () => _selectDate(
                                  notifier: notifier,
                                  initialDate: state.startDate,
                                  firstDate: DateTime.now(),
                                  isStartDate: true,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: EditPrescriptionDateField(
                                label: 'prescription.add.end_date'.tr(),
                                value: _isToday(state.endDate)
                                    ? 'prescription.add.today'.tr()
                                    : _formatDate(state.endDate),
                                onTap: () => _selectDate(
                                  notifier: notifier,
                                  initialDate: state.endDate,
                                  firstDate: state.startDate,
                                  isStartDate: false,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 14.h),
                        EditPrescriptionTextField(
                          key: _noteFieldKey,
                          label: 'prescription.add.note_label'.tr(),
                          hintText: 'prescription.add.note_hint'.tr(),
                          icon: LucideIcons.fileEdit,
                          controller: _noteController,
                          focusNode: _noteFocusNode,
                          minLines: 3,
                          maxLines: 4,
                          textInputAction: TextInputAction.newline,
                          onChanged: notifier.updateNote,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 14.h),
                  child: Button(
                    text: 'prescription.edit_save'.tr(),
                    icon: Icon(
                      LucideIcons.save,
                      size: 20.sp,
                      color: Colors.white,
                    ),
                    isLoading: state.isSaving,
                    onPressed:
                        (state.isSaving || !state.isValid || !state.hasChanges)
                        ? null
                        : () {
                            _unfocusInputs();
                            notifier.save();
                          },
                    height: 48.h,
                    width: double.infinity,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _unfocusInputs() {
    FocusManager.instance.primaryFocus?.unfocus();
    FocusScope.of(context).unfocus(disposition: UnfocusDisposition.scope);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    if (!mounted) return;

    final isKeyboardVisible = View.of(context).viewInsets.bottom > 0;
    if (!_wasKeyboardVisible && isKeyboardVisible && _noteFocusNode.hasFocus) {
      _scrollNoteAboveKeyboard();
    } else if (_wasKeyboardVisible && !isKeyboardVisible) {
      _restoreScrollBeforeNoteFocus();
      _noteFocusNode.unfocus();
    }
    _wasKeyboardVisible = isKeyboardVisible;
  }

  void _handleNoteFocusChanged() {
    if (_noteFocusNode.hasFocus) {
      _wasKeyboardVisible = View.of(context).viewInsets.bottom > 0;
      _scrollNoteAboveKeyboard();
    } else {
      _restoreScrollBeforeNoteFocus();
    }
  }

  void _scrollNoteAboveKeyboard() {
    if (_scrollController.hasClients) {
      _scrollOffsetBeforeNoteFocus ??= _scrollController.offset;
    }

    Future<void>.delayed(const Duration(milliseconds: 320), () async {
      if (!mounted || !_noteFocusNode.hasFocus) return;
      final noteContext = _noteFieldKey.currentContext;
      if (noteContext == null || !noteContext.mounted) return;

      await Scrollable.ensureVisible(
        noteContext,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        alignment: 0.08,
      );

      if (!mounted ||
          !_noteFocusNode.hasFocus ||
          !_scrollController.hasClients) {
        return;
      }

      final maxOffset = _scrollController.position.maxScrollExtent;
      await _scrollController.animateTo(
        (_scrollController.offset + 150.h).clamp(0.0, maxOffset),
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
      );
    });
  }

  void _restoreScrollBeforeNoteFocus() {
    final restoreOffset = _scrollOffsetBeforeNoteFocus;
    _scrollOffsetBeforeNoteFocus = null;
    if (restoreOffset == null) {
      Future<void>.delayed(const Duration(milliseconds: 80), () {
        if (!mounted || _scrollController.positions.isEmpty) return;
        _scrollController.animateTo(
          96.h,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      });
    } else {
      Future<void>.delayed(const Duration(milliseconds: 120), () {
        if (!mounted || !_scrollController.hasClients) return;
        final maxOffset = _scrollController.position.maxScrollExtent;
        _scrollController.animateTo(
          restoreOffset.clamp(0.0, maxOffset),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      });
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  String _formatDate(DateTime date) => DateFormat('dd/MM/yyyy').format(date);

  void _showLargeImage(BuildContext context, {File? file, String? url}) {
    final hasContent = file != null || (url != null && url.isNotEmpty);
    if (!hasContent) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Center(
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 5.0,
                  child: file != null
                      ? Image.file(file, fit: BoxFit.contain)
                      : Image.network(url!, fit: BoxFit.contain),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(12.r),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 38.w,
                        height: 38.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          size: 20.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
