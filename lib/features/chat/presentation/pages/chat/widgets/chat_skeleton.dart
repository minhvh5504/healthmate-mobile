import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../core/theme/app_colors.dart';

/// Full-screen skeleton placeholder shown while Chat history is loading.
/// Mirrors the real layout: back button + alternating user/assistant
/// chat bubbles of varying widths.
class ChatSkeleton extends StatelessWidget {
  const ChatSkeleton({super.key});

  // Sample bubble layout (right = user, left = assistant) with varying widths
  // expressed as a fraction of screen width.
  static const List<_BubbleSpec> _bubbles = [
    _BubbleSpec(isUser: true, widthFactor: 0.55, lines: 1),
    _BubbleSpec(isUser: false, widthFactor: 0.72, lines: 3),
    _BubbleSpec(isUser: true, widthFactor: 0.4, lines: 1),
    _BubbleSpec(isUser: false, widthFactor: 0.65, lines: 2),
    _BubbleSpec(isUser: true, widthFactor: 0.5, lines: 1),
    _BubbleSpec(isUser: false, widthFactor: 0.7, lines: 3),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button area (chat page hides AppBar while no messages).
          Padding(
            padding: EdgeInsets.only(left: 24.w, top: 24.h, bottom: 8.h),
            child: _SkeletonBlock(
              width: 36.w,
              height: 36.w,
              borderRadius: BorderRadius.circular(18.r),
            ).animate().fadeIn(duration: 220.ms),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _bubbles.length,
              itemBuilder: (context, index) {
                final spec = _bubbles[index];
                return _BubbleSkeleton(spec: spec).animate().fadeIn(
                  duration: 220.ms,
                  delay: (60 + 60 * index).ms,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BubbleSpec {
  final bool isUser;
  final double widthFactor;
  final int lines;

  const _BubbleSpec({
    required this.isUser,
    required this.widthFactor,
    required this.lines,
  });
}

class _BubbleSkeleton extends StatelessWidget {
  final _BubbleSpec spec;

  const _BubbleSkeleton({required this.spec});

  @override
  Widget build(BuildContext context) {
    final maxWidth = spec.widthFactor.sw;

    return Align(
      alignment: spec.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
        constraints: BoxConstraints(maxWidth: maxWidth),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: Radius.circular(spec.isUser ? 16.r : 0),
            bottomRight: Radius.circular(spec.isUser ? 0 : 16.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(spec.lines, (i) {
            final isLast = i == spec.lines - 1;
            final width = isLast && spec.lines > 1 ? maxWidth * 0.6 : maxWidth;
            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 6.h),
              child: _SkeletonBlock(width: width, height: 12.h),
            );
          }),
        ),
      ),
    );
  }
}

class _SkeletonBlock extends StatelessWidget {
  const _SkeletonBlock({
    required this.width,
    required this.height,
    this.borderRadius,
  });

  final double width;
  final double height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    const baseColor = AppColors.bgHover;
    const highlightColor = Colors.white;
    final radius = borderRadius ?? BorderRadius.circular(8.r);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      period: const Duration(milliseconds: 1400),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(color: baseColor, borderRadius: radius),
      ),
    );
  }
}
