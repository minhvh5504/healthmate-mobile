import 'package:flutter/material.dart';
import 'package:healthmate_mobile/core/theme/app_colors.dart';
import 'package:healthmate_mobile/features/health/presentation/pages/health/widgets/health_header.dart';
import 'package:healthmate_mobile/features/health/presentation/pages/health/widgets/health_content_area.dart';

class HealthPage extends StatelessWidget {
  const HealthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: const SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HealthHeader(),
              SizedBox(height: 4),
              HealthContentArea(),
            ],
          ),
        ),
      ),
    );
  }
}
