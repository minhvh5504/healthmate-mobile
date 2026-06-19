import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:toastification/toastification.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/constant_url.dart';
import '../routing/app_router.dart';
import '../routing/app_routes.dart';
import '../theme/app_colors.dart';

/// Centralized toast utility.
/// Use [AppToast.error] to show any error as a human-readable toast.
class AppToast {
  AppToast._();

  static void success(String message) {
    toastification.show(
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 3),
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
    );
  }

  static void notification({required String title, required String message}) {
    toastification.showCustom(
      autoCloseDuration: const Duration(seconds: 6),
      alignment: Alignment.topCenter,
      builder: (context, holder) {
        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: _NotificationToast(
              key: ValueKey(holder.id),
              title: title,
              message: message,
              onDismiss: () => toastification.dismiss(holder),
              onTap: () {
                toastification.dismiss(holder);
                AppRouter.router.push(AppRoutes.notifications);
              },
            ),
          ),
        );
      },
    );
  }

  /// Shows a user-friendly error toast.
  /// Accepts any object (DioException, Exception, String, etc.)
  static void error(Object? err) {
    final message = _parseError(err);
    toastification.show(
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 4),
      type: ToastificationType.error,
      style: ToastificationStyle.flat,
    );
  }

  static void warning(String message) {
    toastification.show(
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 3),
      type: ToastificationType.warning,
      style: ToastificationStyle.flat,
    );
  }

  static String _parseError(Object? err) {
    if (err == null) return 'error.unknown'.tr();

    if (err is DioException) {
      return _parseDioError(err);
    }

    final raw = err.toString();
    if (raw.contains('Exception:')) {
      return raw.split('Exception:').last.trim();
    }

    return raw.isNotEmpty ? raw : 'error.unknown'.tr();
  }

  static String _parseDioError(DioException err) {
    final data = err.response?.data;
    if (data is Map<String, dynamic>) {
      final msg =
          data['message'] as String? ??
          data['error'] as String? ??
          data['msg'] as String?;
      if (msg != null && msg.isNotEmpty) return msg;
    }

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'error.timeout'.tr();
      case DioExceptionType.connectionError:
        return 'error.no_connection'.tr();
      case DioExceptionType.badResponse:
        final status = err.response?.statusCode;
        if (status == 401) return 'error.unauthorized'.tr();
        if (status == 403) return 'error.forbidden'.tr();
        if (status == 404) return 'error.not_found'.tr();
        if (status != null && status >= 500) return 'error.server'.tr();
        return 'error.bad_response'.tr();
      default:
        return 'error.unknown'.tr();
    }
  }
}

class _NotificationToast extends StatefulWidget {
  final String title;
  final String message;
  final VoidCallback onDismiss;
  final VoidCallback onTap;

  const _NotificationToast({
    super.key,
    required this.title,
    required this.message,
    required this.onDismiss,
    required this.onTap,
  });

  @override
  State<_NotificationToast> createState() => _NotificationToastState();
}

class _NotificationToastState extends State<_NotificationToast> {
  bool _dismissed = false;

  @override
  Widget build(BuildContext context) {
    if (_dismissed) return const SizedBox.shrink();

    return Dismissible(
      key: widget.key ?? ValueKey('${widget.title}-${widget.message}'),
      direction: DismissDirection.up,
      onDismissed: (_) {
        setState(() => _dismissed = true);
        widget.onDismiss();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.typoNavi.withValues(alpha: 0.06),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48.w,
                    height: 48.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6B66FF),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6B66FF).withValues(alpha: 0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: SvgPicture.asset(
                      AppIcons.bell,
                      width: 30.w,
                      height: 30.w,
                      colorFilter: const ColorFilter.mode(
                        AppColors.bgWhite,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.typoBlack,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.message,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.typoBody.withValues(alpha: 0.82),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    LucideIcons.chevronRight,
                    color: AppColors.typoBody.withValues(alpha: 0.35),
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
