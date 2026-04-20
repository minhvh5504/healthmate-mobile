import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/providers/user_provider.dart';
import '../../providers/home_provider.dart';
import 'widgets/home_header.dart';
import 'widgets/home_content_area.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeNotifier = ref.read(homeProvider.notifier);
    final profile = ref.watch(userProfileProvider);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              HomeHeader(
                onProfilePressed: homeNotifier.onProfile,
                onNotificationPressed: homeNotifier.onNotification,
                avatarUrl: profile?.avatarUrl,
              ),

              const SizedBox(height: 4),

              // White Card Body
              const HomeContentArea(),
            ],
          ),
        ),
      ),
    );
  }
}
