import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDotLoadingOverlay extends StatelessWidget {
  const AppDotLoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  final bool isLoading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        if (isLoading) ...[
          const ModalBarrier(dismissible: false, color: Colors.transparent),
          const Center(child: AppDotLoader()),
        ],
      ],
    );
  }
}

class AppDotLoader extends StatefulWidget {
  const AppDotLoader({super.key});

  @override
  State<AppDotLoader> createState() => _AppDotLoaderState();
}

class _AppDotLoaderState extends State<AppDotLoader>
    with SingleTickerProviderStateMixin {
  static const _colors = [
    Color(0xFF8FD3EC),
    Color(0xFF45BDE6),
    Color(0xFF1688B8),
    Color(0xFFC91D1D),
    Color(0xFFFF4141),
  ];

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(_colors.length, (index) {
              final wave = math.sin(
                (_controller.value * 2 * math.pi) - (index * 0.75),
              );
              final progress = (wave + 1) / 2;
              final size = (9 + progress * 5).w;

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.5.w),
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: _colors[index],
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
