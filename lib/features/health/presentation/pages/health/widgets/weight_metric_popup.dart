import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healthmate_mobile/core/constants/constant_url.dart';
import 'package:healthmate_mobile/core/theme/app_colors.dart';
import 'package:healthmate_mobile/core/widgets/button/button.dart';
import 'package:healthmate_mobile/features/health/presentation/providers/health/health_provider.dart';
import 'package:lucide_icons/lucide_icons.dart';

class MetricInputFormatter extends TextInputFormatter {
  const MetricInputFormatter({this.maxValue = 300});

  final double maxValue;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    if (RegExp(r'[^0-9.]').hasMatch(newValue.text)) return oldValue;
    if ('.'.allMatches(newValue.text).length > 1) return oldValue;

    final parts = newValue.text.split('.');
    final integerPart = parts[0];
    final decimalPart = parts.length > 1 ? parts[1] : null;

    if (integerPart.length > 3) return oldValue;
    if (decimalPart != null && decimalPart.length > 1) return oldValue;

    final value = double.tryParse(newValue.text);
    if (value != null && value > maxValue) return oldValue;

    return newValue;
  }
}

class WeightMetricPopup extends ConsumerStatefulWidget {
  final double initialValue;

  const WeightMetricPopup({super.key, required this.initialValue});

  @override
  ConsumerState<WeightMetricPopup> createState() => _WeightMetricPopupState();
}

class _WeightMetricPopupState extends ConsumerState<WeightMetricPopup> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() => setState(() {}));
    _currentValue = widget.initialValue;
    _controller = TextEditingController(
      text: _currentValue > 0 ? _currentValue.toStringAsFixed(1) : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  double _normalizedValue(double value) {
    return double.parse(value.toStringAsFixed(1));
  }

  bool get _hasChanged {
    final value = double.tryParse(_controller.text);
    if (value == null || value <= 0 || value > 300) return false;
    return _normalizedValue(value) != _normalizedValue(widget.initialValue);
  }

  TextSpan _buildValueSpan(String text) {
    if (text.isEmpty) {
      return const TextSpan();
    }

    final dotIndex = text.indexOf('.');
    if (dotIndex == -1) {
      return TextSpan(
        children: [
          _buildTextPart(text, AppColors.typoBlack),
          _buildTextPart('.0', AppColors.typoDisable.withValues(alpha: 0.35)),
        ],
      );
    }

    final integerPart = text.substring(0, dotIndex);
    final decimalPart = text.substring(dotIndex);
    final decimalHint = decimalPart == '.' ? '.0' : decimalPart;
    return TextSpan(
      children: [
        _buildTextPart(integerPart, AppColors.typoBlack),
        _buildTextPart(
          decimalHint,
          AppColors.typoDisable.withValues(alpha: 0.35),
        ),
      ],
    );
  }

  TextSpan _buildTextPart(String text, Color color) {
    return TextSpan(
      text: text,
      style: TextStyle(
        color: color,
        fontSize: 64.sp,
        fontWeight: FontWeight.w900,
        letterSpacing: 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(healthProvider.notifier);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                SizedBox(width: 36.w),
                Expanded(
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFF1F1F1)),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            AppIcons.calendarRange,
                            width: 16.w,
                            height: 16.w,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            HealthNotifier.formatDate(DateTime.now()),
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.typoBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1A1C1E),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      LucideIcons.x,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            Center(
              child: SvgPicture.asset(
                AppIcons.medicineMoreLight,
                width: 80.sp,
                height: 80.sp,
              ),
            ),

            SizedBox(height: 16.h),
            Text(
              'health.weight_title'.tr(),
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.typoBlack,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    'health.metric_subtitle'.tr(),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.typoBody.withValues(alpha: 0.5),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () => notifier.onShowWeightInfo(context),
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFAFAED5).withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      LucideIcons.info,
                      size: 12.sp,
                      color: AppColors.typoHeading,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6F9),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        IgnorePointer(
                          child: Text.rich(
                            _buildValueSpan(
                              _controller.text.isEmpty
                                  ? (_focusNode.hasFocus ? '' : '0.0')
                                  : _controller.text,
                            ),
                            style: const TextStyle(height: 1.1),
                          ),
                        ),
                        TextField(
                          onTapOutside: (_) => FocusScope.of(context).unfocus(),
                          controller: _controller,
                          focusNode: _focusNode,
                          inputFormatters: const [
                            MetricInputFormatter(maxValue: 300),
                          ],
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          textAlign: TextAlign.left,
                          cursorColor: AppColors.typoBlack,
                          style: TextStyle(
                            fontSize: 64.sp,
                            fontWeight: FontWeight.w900,
                            color: Colors.transparent,
                            height: 1.1,
                            letterSpacing: 0,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                          ),
                          onChanged: (value) => setState(() {
                            _currentValue = double.tryParse(value) ?? 0.0;
                          }),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'kg',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF9EA4C1),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),
            Button(
              text: 'health.save'.tr(),
              height: 48.h,
              width: double.infinity,
              isLoading: ref.watch(healthProvider).isLoading,
              onPressed: _hasChanged
                  ? () => notifier.saveMetric(
                      context: context,
                      weight: _currentValue,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
