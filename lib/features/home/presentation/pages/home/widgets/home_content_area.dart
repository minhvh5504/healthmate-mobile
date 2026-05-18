import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'home_shortcuts_section.dart';
import 'home_health_today_section.dart';

class HomeContentArea extends StatelessWidget {
  const HomeContentArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 92.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeShortcutsSection(),
            SizedBox(height: 14.h),
            const HomeHealthTodaySection(),
          ],
        ),
      ),
    );
  }
}
