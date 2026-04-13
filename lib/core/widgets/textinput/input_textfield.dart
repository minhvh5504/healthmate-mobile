import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';

class InputTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final bool isPassword;
  final bool hasError;
  final String? errorText;
  final bool isEmailOrPhone;
  final bool readOnly;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final String? suffixText;
  final VoidCallback? onTap;
  final bool? obscureText;

  const InputTextField({
    super.key,
    required this.controller,
    this.hint,
    this.label,
    this.isPassword = false,
    this.hasError = false,
    this.errorText,
    this.isEmailOrPhone = false,
    this.readOnly = false,
    this.keyboardType,
    this.suffixIcon,
    this.suffixText,
    this.onTap,
    this.obscureText,
  });

  @override
  State<InputTextField> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
  bool _isObscured = true;
  bool _showSuffixIcon = false;
  late VoidCallback _textListener;

  @override
  void initState() {
    super.initState();
    _textListener = () {
      final shouldShow = widget.controller.text.isNotEmpty;
      if (shouldShow != _showSuffixIcon && mounted) {
        setState(() => _showSuffixIcon = shouldShow);
      }
    };
    widget.controller.addListener(_textListener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_textListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color borderColor = widget.hasError
        ? AppColors.bgError.withValues(alpha: 0.6)
        : Colors.grey.shade300;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label?.isNotEmpty ?? false) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.typoBlack,
            ),
          ),
          SizedBox(height: 6.h),
        ],
        TextField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _isObscured : false,
          keyboardType: widget.keyboardType,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14.sp,
            color: AppColors.typoHeading,
          ),
          decoration: InputDecoration(
            constraints: BoxConstraints(minHeight: 36.h),
            hintText: widget.hint,
            hintStyle: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.typoHeading.withValues(alpha: 0.5),
            ),
            filled: true,
            fillColor: AppColors.typoWhite,
            contentPadding: EdgeInsets.symmetric(
              vertical: 8.h,
              horizontal: 12.w,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: borderColor, width: 0.5.w),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: borderColor, width: 0.5.w),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: widget.hasError
                    ? AppColors.bgError.withValues(alpha: 0.6)
                    : AppColors.typoHeading.withValues(alpha: 0.5),
                width: 1.0.w,
              ),
            ),
            suffixIcon: Padding(
              padding: EdgeInsets.only(right: 8.w),
              child:
                  widget.suffixIcon ??
                  (widget.isPassword && _showSuffixIcon
                      ? IconButton(
                          icon: Icon(
                            _isObscured
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey,
                            size: 20.sp,
                          ),
                          onPressed: () =>
                              setState(() => _isObscured = !_isObscured),
                        )
                      : widget.suffixText != null
                      ? Padding(
                          padding: EdgeInsets.only(top: 10.h, right: 10.w),
                          child: Text(
                            widget.suffixText!,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.typoHeading,
                            ),
                          ),
                        )
                      : null),
            ),
          ),
        ),
        if (widget.hasError && widget.errorText != null) ...[
          SizedBox(height: 6.h),
          Text(
            widget.errorText!,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12.sp,
              color: AppColors.typoError,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }
}
