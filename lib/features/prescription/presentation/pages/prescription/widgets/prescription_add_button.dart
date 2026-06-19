import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/routing/app_routes.dart';
import '../../../../../../core/widgets/button/button.dart';
import '../../../providers/prescription/prescription_provider.dart';

class PrescriptionAddButton extends ConsumerWidget {
  const PrescriptionAddButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Button(
      text: 'prescription.add_new'.tr(),
      icon: Icon(
        Icons.add_rounded,
        size: 20.sp,
        color: Colors.white,
      ),
      onPressed: () async {
        final result = await context.push(AppRoutes.addPrescription);
        if (result == true) {
          await ref.read(prescriptionProvider.notifier).fetchPrescriptions();
        }
      },
      height: 48.h,
      width: double.infinity,
    );
  }
}
