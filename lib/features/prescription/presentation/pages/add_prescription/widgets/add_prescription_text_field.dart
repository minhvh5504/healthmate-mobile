import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/app_colors.dart';

class AddPrescriptionTextField extends StatefulWidget {
  const AddPrescriptionTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.icon,
    required this.controller,
    this.minLines = 1,
    this.maxLines = 1,
    this.focusNode,
    this.textInputAction,
    this.onSubmitted,
    this.onChanged,
  });

  final String label;
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final int minLines;
  final int maxLines;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;

  @override
  State<AddPrescriptionTextField> createState() => _AddPrescriptionTextFieldState();
}

class _AddPrescriptionTextFieldState extends State<AddPrescriptionTextField> {
  FocusNode? _internalFocusNode;
  bool _isFocused = false;

  FocusNode get _effectiveFocusNode => widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _effectiveFocusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(covariant AddPrescriptionTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      final oldEffectiveNode = oldWidget.focusNode ?? _internalFocusNode;
      oldEffectiveNode?.removeListener(_handleFocusChange);
      _effectiveFocusNode.addListener(_handleFocusChange);
    }
  }

  @override
  void dispose() {
    _effectiveFocusNode.removeListener(_handleFocusChange);
    _internalFocusNode?.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (_isFocused != _effectiveFocusNode.hasFocus) {
      setState(() {
        _isFocused = _effectiveFocusNode.hasFocus;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMultiline = widget.maxLines > 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.typoBody.withValues(alpha: 0.82),
          ),
        ),
        SizedBox(height: 6.h),
        isMultiline
            ? Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.fromBorderSide(
                    _isFocused
                        ? const BorderSide(color: Color(0xFFB8B3EA), width: 1.2)
                        : const BorderSide(color: Color(0xFFE2E5F0), width: 1),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 17.w,
                        right: 12.w,
                        top: 14.h,
                      ),
                      child: Icon(
                        widget.icon,
                        size: 18.sp,
                        color: const Color(0xFF767C9D),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: widget.controller,
                        focusNode: _effectiveFocusNode,
                        minLines: widget.minLines,
                        maxLines: widget.maxLines,
                        textInputAction: widget.textInputAction,
                        onTapOutside: (_) => FocusScope.of(context).unfocus(),
                        onSubmitted: widget.onSubmitted,
                        onChanged: widget.onChanged,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.typoBlack,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: widget.hintText,
                          hintStyle: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF8B91B0),
                          ),
                          contentPadding: EdgeInsets.only(
                            right: 16.w,
                            top: 12.h,
                            bottom: 12.h,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : TextField(
                controller: widget.controller,
                focusNode: _effectiveFocusNode,
                minLines: widget.minLines,
                maxLines: widget.maxLines,
                textInputAction: widget.textInputAction,
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                onSubmitted: widget.onSubmitted,
                onChanged: widget.onChanged,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.typoBlack,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF8B91B0),
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 17.w, right: 12.w),
                    child: Icon(
                      widget.icon,
                      size: 18.sp,
                      color: const Color(0xFF767C9D),
                    ),
                  ),
                  prefixIconConstraints: BoxConstraints(minWidth: 44.w),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  border: _border(),
                  enabledBorder: _border(),
                  focusedBorder: _border(color: const Color(0xFFB8B3EA), width: 1.2),
                ),
              ),
      ],
    );
  }

  OutlineInputBorder _border({
    Color color = const Color(0xFFE2E5F0),
    double width = 1,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
