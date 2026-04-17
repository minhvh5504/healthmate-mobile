import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/user_medication.dart';

class MedicineQuantityPopup extends StatefulWidget {
  final UserMedication medication;
  final Function(int) onSave;

  const MedicineQuantityPopup({
    super.key,
    required this.medication,
    required this.onSave,
  });

  @override
  State<MedicineQuantityPopup> createState() => _MedicineQuantityPopupState();
}

class _MedicineQuantityPopupState extends State<MedicineQuantityPopup> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.medication.stockCount ?? 30;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Close Button
            Positioned(
              top: 16.h,
              right: 16.w,
              child: IconButton(
                onPressed: () => context.pop(),
                icon: Icon(
                  LucideIcons.x,
                  color: AppColors.typoBody.withValues(alpha: 0.4),
                  size: 24.sp,
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    'medicine.remaining_label'.tr(),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.typoBlack,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),

                  // Quantity Selector Container
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: AppColors.typoHeading.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'medicine.remaining_label'.tr(),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.typoBlack,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => setState(() {
                                if (_quantity > 0) _quantity--;
                              }),
                              icon: Icon(
                                LucideIcons.minusCircle,
                                color: AppColors.typoBody,
                                size: 24.sp,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              '$_quantity',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.typoBlack,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            IconButton(
                              onPressed: () => setState(() {
                                _quantity++;
                              }),
                              icon: Icon(
                                LucideIcons.plusCircle,
                                color: AppColors.typoBody,
                                size: 24.sp,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: () => widget.onSave(_quantity),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.typoBlack,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'medicine.save'.tr(),
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
