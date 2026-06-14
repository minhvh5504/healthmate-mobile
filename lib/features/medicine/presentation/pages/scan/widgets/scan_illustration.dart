import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/theme/app_colors.dart';

class ScanIllustration extends StatefulWidget {
  final String imagePath;
  final bool isScanning;

  const ScanIllustration({
    super.key,
    required this.imagePath,
    this.isScanning = false,
  });

  @override
  State<ScanIllustration> createState() => _ScanIllustrationState();
}

class _ScanIllustrationState extends State<ScanIllustration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    if (widget.isScanning) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(ScanIllustration oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isScanning && !oldWidget.isScanning) {
      _controller.repeat(reverse: true);
    } else if (!widget.isScanning && oldWidget.isScanning) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isAsset = widget.imagePath.startsWith('assets');

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// Dotted frame around the scan icon
          DottedBorder(
            options: RoundedRectDottedBorderOptions(
              radius: Radius.circular(36.r),
              color: AppColors.lightPurple,
              strokeWidth: 2,
              dashPattern: [6, 4],
              padding: EdgeInsets.all(12.w),
            ),
            child: SizedBox(width: 180.w, height: 200.w),
          ),

          /// Main Image
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final double scale = widget.isScanning
                  ? 1.0 + (_controller.value * 0.03)
                  : 1.0;
              return Transform.scale(
                scale: scale,
                child: Container(
                  width: 180.w,
                  height: 180.w,
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.lightPurple.withValues(
                          alpha: widget.isScanning ? 0.2 : 0.05,
                        ),
                        blurRadius: widget.isScanning ? 30 : 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28.r),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        isAsset
                            ? Image.asset(widget.imagePath, fit: BoxFit.contain)
                            : Image.file(
                                File(widget.imagePath),
                                fit: BoxFit.cover,
                                cacheWidth: 256,
                              ),
                        if (widget.isScanning) ...[
                          /// Overlay to make scanning line pop
                          Container(color: Colors.black.withValues(alpha: 0.1)),
                          Positioned(
                            top: _controller.value * 160.w,
                            left: 0,
                            right: 0,
                            child: Column(
                              children: [
                                Container(
                                  height: 3.h,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.lightPurple.withValues(
                                          alpha: 0,
                                        ),
                                        AppColors.lightPurple,
                                        AppColors.lightPurple,
                                        AppColors.lightPurple.withValues(
                                          alpha: 0,
                                        ),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.lightPurple.withValues(
                                          alpha: 0.8,
                                        ),
                                        blurRadius: 15,
                                        spreadRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),

                                /// Sub-glow below the line
                                Container(
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        AppColors.lightPurple.withValues(
                                          alpha: 0.3,
                                        ),
                                        AppColors.lightPurple.withValues(
                                          alpha: 0,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
