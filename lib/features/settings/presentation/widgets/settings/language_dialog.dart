import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';

class LanguageDialog extends StatelessWidget {
  final String title;
  final String currentLocale;
  final List<LanguageOption> options;
  final Function(String) onSelect;
  final VoidCallback onClose;

  const LanguageDialog({
    super.key,
    required this.title,
    required this.currentLocale,
    required this.options,
    required this.onSelect,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.symmetric(horizontal: 32.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.r)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 280.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                const Spacer(),
                Expanded(
                  flex: 8,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.typoBlack,
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: onClose,
                    child: Icon(
                      Icons.close,
                      color: AppColors.typoDisable.withOpacity(0.6),
                      size: 24.sp,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // Options
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: options.length,
              separatorBuilder: (context, index) => Divider(
                color: AppColors.typoDisable.withOpacity(0.1),
                height: 1.h,
              ),
              itemBuilder: (context, index) {
                final option = options[index];
                final isSelected = option.locale == currentLocale;

                return GestureDetector(
                  onTap: () => onSelect(option.locale),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          option.name,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.typoBlack,
                          ),
                        ),
                        if (isSelected)
                          Container(
                            width: 24.w,
                            height: 24.w,
                            decoration: const BoxDecoration(
                              color: Color(0xFF34C759),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16.sp,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LanguageOption {
  final String name;
  final String locale;

  LanguageOption({required this.name, required this.locale});
}
