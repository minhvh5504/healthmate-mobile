import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../constants/constant_url.dart';
import '../../routing/app_routes.dart';

class FloatingChatButton extends StatefulWidget {
  const FloatingChatButton({super.key});

  @override
  State<FloatingChatButton> createState() => _FloatingChatButtonState();
}

class _FloatingChatButtonState extends State<FloatingChatButton> {
  Offset? _position;
  Size? _lastBounds;
  bool _isDragging = false;

  double get _buttonSize => 60.w;

  EdgeInsets _dragMargin(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return EdgeInsets.fromLTRB(
      8.w,
      padding.top + 8.h,
      8.w,
      padding.bottom + 80.h,
    );
  }

  Offset _defaultPosition(Size bounds, double buttonSize, EdgeInsets margin) {
    return Offset(
      bounds.width - buttonSize - margin.right,
      bounds.height - buttonSize - margin.bottom,
    );
  }

  Offset _clampPosition(
    Offset position,
    Size bounds,
    double buttonSize,
    EdgeInsets margin,
  ) {
    final maxX = (bounds.width - buttonSize - margin.right).clamp(
      margin.left,
      double.infinity,
    );
    final maxY = (bounds.height - buttonSize - margin.bottom).clamp(
      margin.top,
      double.infinity,
    );

    return Offset(
      position.dx.clamp(margin.left, maxX).toDouble(),
      position.dy.clamp(margin.top, maxY).toDouble(),
    );
  }

  void _openChat() {
    context.push(AppRoutes.chat);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bounds = Size(constraints.maxWidth, constraints.maxHeight);
        final buttonSize = _buttonSize;
        final margin = _dragMargin(context);
        final hasValidBounds =
            bounds.width.isFinite &&
            bounds.height.isFinite &&
            bounds.width > 0 &&
            bounds.height > 0;

        if (!hasValidBounds) return const SizedBox.shrink();

        final didBoundsChange = _lastBounds != bounds;
        _lastBounds = bounds;

        final currentPosition = _clampPosition(
          _position ?? _defaultPosition(bounds, buttonSize, margin),
          bounds,
          buttonSize,
          margin,
        );

        if (_position == null || didBoundsChange) {
          _position = currentPosition;
        }

        return SizedBox.expand(
          child: Stack(
            children: [
              AnimatedPositioned(
                left: currentPosition.dx,
                top: currentPosition.dy,
                duration: _isDragging ? Duration.zero : 400.ms,
                curve: _isDragging ? Curves.linear : Curves.easeOutCubic,
                child: GestureDetector(
                  onTap: _openChat,
                  onPanStart: (_) => setState(() => _isDragging = true),
                  onPanUpdate: (details) {
                    setState(() {
                      _position = _clampPosition(
                        currentPosition + details.delta,
                        bounds,
                        buttonSize,
                        margin,
                      );
                    });
                  },
                  onPanEnd: (details) {
                    setState(() {
                      _isDragging = false;

                      // Calculate slide offset based on release velocity (inertia)
                      final velocity = details.velocity.pixelsPerSecond;
                      const double kInertiaFactor = 0.15;
                      final targetPosition = Offset(
                        currentPosition.dx + velocity.dx * kInertiaFactor,
                        currentPosition.dy + velocity.dy * kInertiaFactor,
                      );

                      _position = _clampPosition(
                        targetPosition,
                        bounds,
                        buttonSize,
                        margin,
                      );
                    });
                  },
                  onPanCancel: () {
                    setState(() {
                      _isDragging = false;
                    });
                  },
                  child: AnimatedScale(
                    scale: _isDragging ? 1.08 : 1.0,
                    duration: 150.ms,
                    curve: Curves.easeOutCubic,
                    child: AnimatedRotation(
                      turns: _isDragging ? 0.04 : 0.0,
                      duration: 150.ms,
                      curve: Curves.easeOutCubic,
                      child: _ChatButtonFace(
                        isDragging: _isDragging,
                        size: buttonSize,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ChatButtonFace extends StatelessWidget {
  const _ChatButtonFace({required this.isDragging, required this.size});
  final bool isDragging;
  final double size;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
          duration: 150.ms,
          curve: Curves.easeOutCubic,
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDragging ? 0.20 : 0.12),
                blurRadius: isDragging ? 28.r : 20.r,
                offset: isDragging ? Offset(0, 14.h) : Offset(0, 8.h),
              ),
            ],
          ),
          child: Image.asset(
            AppImages.aiChatIdle,
            width: size,
            height: size,
            fit: BoxFit.contain,
          ),
        )
        .animate()
        .fadeIn(duration: 180.ms)
        .scale(
          begin: const Offset(0.92, 0.92),
          end: const Offset(1, 1),
          duration: 220.ms,
          curve: Curves.easeOutCubic,
        );
  }
}
