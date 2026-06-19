import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../../core/theme/app_colors.dart';

class AddPrescriptionImagePicker extends StatelessWidget {
  const AddPrescriptionImagePicker({
    super.key,
    required this.image,
    required this.onChangeTap,
    this.onViewImage,
  });

  final File? image;

  /// Opens image source bottom sheet (camera / gallery).
  final VoidCallback onChangeTap;

  /// Opens the full-screen image viewer. Null when no image selected.
  final VoidCallback? onViewImage;

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF4F46E5);

    return Container(
      width: double.infinity,
      height: 140.h,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: const Color(0xFFCFC7FF),
          width: 1.2,
        ),
      ),
      child: image != null
          ? Stack(
              fit: StackFit.expand,
              children: [
                // Tap image → full screen viewer
                GestureDetector(
                  onTap: onViewImage,
                  child: Image.file(image!, fit: BoxFit.cover),
                ),
                // View image chip (top-right)
                Positioned(
                  right: 12.w,
                  top: 12.h,
                  child: GestureDetector(
                    onTap: onViewImage,
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        LucideIcons.eye,
                        size: 16.sp,
                        color: AppColors.typoBlack,
                      ),
                    ),
                  ),
                ),
                // Change image chip (bottom-center)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 12.h,
                  child: Center(
                    child: GestureDetector(
                      onTap: onChangeTap,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(999.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          'prescription.add.change_image'.tr(),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.typoBlack,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : GestureDetector(
              onTap: onChangeTap,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 52.w,
                    height: 52.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEFEDFF),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(LucideIcons.plus, size: 24.sp, color: accent),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'prescription.add.image_title'.tr(),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.typoBlack,
                    ),
                  ),
                  Text(
                    'prescription.add.image_subtitle'.tr(),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.typoBody.withValues(alpha: 0.78),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
