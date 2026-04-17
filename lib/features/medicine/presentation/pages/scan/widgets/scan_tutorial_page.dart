import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/widgets/header/header_with_back.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/widgets/button/button.dart';
import 'scan_illustration.dart';

class ScanTutorialPage extends StatelessWidget {
  final String title;
  final List<Widget> tips;
  final VoidCallback onBack;
  final VoidCallback onTakePhoto;
  final VoidCallback onUploadPhoto;
  final bool isLoading;
  final String? errorMessage;
  final String? capturedImagePath;

  const ScanTutorialPage({
    super.key,
    required this.title,
    required this.tips,
    required this.onBack,
    required this.onTakePhoto,
    required this.onUploadPhoto,
    this.isLoading = false,
    this.errorMessage,
    this.capturedImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: HeaderWithBack(
                  showTitle: false,
                  showMore: false,
                  onBack: onBack,
                ),
              ),

              /// Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ScanIllustration(
                        imagePath:
                            capturedImagePath ??
                            'assets/images/scan/scan_tutorial.png',
                        isScanning: isLoading,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.typoHeading,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      ...tips,
                    ],
                  ),
                ),
              ),

              /// Action Buttons
              Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  children: [
                    Button(
                      text: 'Chụp ảnh',
                      onPressed: isLoading ? null : onTakePhoto,
                      color: AppColors.bgWhite,
                      textColor: AppColors.typoBlack,
                      icon: Icon(Icons.camera_alt_outlined, size: 24.sp),
                    ),
                    SizedBox(height: 16.h),
                    Button(
                      text: 'Tải ảnh lên',
                      onPressed: isLoading ? null : onUploadPhoto,
                      color: AppColors.bgWhite,
                      textColor: AppColors.typoBlack,
                      icon: Icon(Icons.upload_outlined, size: 24.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
