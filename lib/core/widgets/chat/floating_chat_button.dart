import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../constants/constant_url.dart';
import '../../routing/app_routes.dart';
import '../../theme/app_colors.dart';

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
      20.w,
      padding.top + 16.h,
      20.w,
      padding.bottom + 104.h,
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
                duration: _isDragging ? 55.ms : 220.ms,
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
                  onPanEnd: (_) => setState(() => _isDragging = false),
                  onPanCancel: () => setState(() => _isDragging = false),
                  child: AnimatedScale(
                    scale: _isDragging ? 1.06 : 1,
                    duration: 140.ms,
                    curve: Curves.easeOutCubic,
                    child: const _ChatButtonFace(),
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
  const _ChatButtonFace();

  @override
  Widget build(BuildContext context) {
    return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.chatSendButton,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.chatSendButton.withValues(alpha: 0.28),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppIcons.chat,
                  width: 30.w,
                  height: 30.w,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ],
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
