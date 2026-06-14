import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/constants/lottie_animation.dart';

class MedicineLogSuccessDialog extends StatefulWidget {
  final String message;

  const MedicineLogSuccessDialog({super.key, required this.message});

  static void show(BuildContext context, {String? message}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Medicine Log Success',
      barrierColor: Colors.black.withValues(alpha: 0.15),
      transitionDuration: const Duration(milliseconds: 240),
      pageBuilder: (context, anim1, anim2) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              insetPadding: EdgeInsets.symmetric(horizontal: 48.w),
              child: MedicineLogSuccessDialog(
                message: message ?? 'medicine.log_status.success_message'.tr(),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.96, end: 1).animate(
              CurvedAnimation(parent: anim1, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        );
      },
    );
  }

  @override
  State<MedicineLogSuccessDialog> createState() =>
      _MedicineLogSuccessDialogState();
}

class _MedicineLogSuccessDialogState extends State<MedicineLogSuccessDialog> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 2400), () {
      if (mounted && Navigator.of(context).canPop()) {
        context.pop();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: LottieAnimation.cheering);
  }
}
