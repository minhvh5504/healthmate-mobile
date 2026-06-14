import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthmate_mobile/core/widgets/header/app_header.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../providers/medicine/medicine_provider.dart';
import 'widgets/medicine_calendar_strip.dart';
import 'widgets/medicine_date_label.dart';
import 'widgets/medicine_header.dart';
import 'widgets/medicine_skeleton.dart';
import 'widgets/medicine_tab_content.dart';
import '../../../../../core/providers/user_provider.dart';

class MedicinePage extends ConsumerStatefulWidget {
  const MedicinePage({super.key});

  @override
  ConsumerState<MedicinePage> createState() => _MedicinePageState();
}

class _MedicinePageState extends ConsumerState<MedicinePage>
    with SingleTickerProviderStateMixin {
  static const _scheduleControlsScrollRange = 150.0;

  late final AnimationController _scheduleControlsController;
  late final Animation<double> _scheduleControlsAnimation;

  @override
  void initState() {
    super.initState();
    _scheduleControlsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      value: 1,
    );
    _scheduleControlsAnimation = CurvedAnimation(
      parent: _scheduleControlsController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _scheduleControlsController.dispose();
    super.dispose();
  }

  void _animateScheduleDateControlsTo(double value) {
    _scheduleControlsController.animateTo(
      value,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
    );
  }

  void _showScheduleDateControls() {
    _animateScheduleDateControlsTo(1);
  }

  void _updateScheduleDateControlsByScrollDelta(double delta) {
    _scheduleControlsController.stop();
    _scheduleControlsController.value =
        (_scheduleControlsController.value -
                delta / _scheduleControlsScrollRange)
            .clamp(0.0, 1.0);
  }

  bool _handleScrollNotification(
    ScrollNotification notification,
    MedicineState state,
  ) {
    if (state.selectedTab != MedicineTab.schedule ||
        notification.metrics.axis != Axis.vertical) {
      return false;
    }

    if (notification is ScrollUpdateNotification) {
      final delta = notification.scrollDelta;
      if (delta != null && delta != 0) {
        _updateScheduleDateControlsByScrollDelta(delta);
      }
    } else if (notification is OverscrollNotification) {
      if (notification.overscroll != 0) {
        _updateScheduleDateControlsByScrollDelta(notification.overscroll);
      }
    } else if (notification is ScrollEndNotification) {
      final target = _scheduleControlsController.value >= 0.5 ? 1.0 : 0.0;
      _animateScheduleDateControlsTo(target);
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(medicineProvider);
    final notifier = ref.read(medicineProvider.notifier);
    final profile = ref.watch(userProfileProvider);

    final isInitialLoading = state.isLoading && state.isInitialLoad;
    final isScheduleTab = state.selectedTab == MedicineTab.schedule;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: isInitialLoading
              ? const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppHeader(),
                    Expanded(child: MedicineSkeleton()),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppHeader(),
                    SizedBox(height: 8.h),

                    MedicineTabBar(
                      selectedTab: state.selectedTab,
                      onTabSelected: (tab) {
                        if (tab == MedicineTab.schedule) {
                          _showScheduleDateControls();
                        }
                        notifier.selectTab(tab);
                      },
                      avatarUrl: profile?.avatarUrl,
                    ),

                    SizedBox(height: 8.h),

                    if (isScheduleTab)
                      _buildScheduleDateControls(
                        state: state,
                        onDateSelected: (date) {
                          _showScheduleDateControls();
                          notifier.selectDate(date);
                        },
                      ),

                    Expanded(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (notification) =>
                            _handleScrollNotification(notification, state),
                        child: const MedicineTabContent(),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildScheduleDateControls({
    required MedicineState state,
    required ValueChanged<DateTime> onDateSelected,
  }) {
    return ClipRect(
      child: SizeTransition(
        sizeFactor: _scheduleControlsAnimation,
        axisAlignment: -1,
        child: FadeTransition(
          opacity: _scheduleControlsAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -0.08),
              end: Offset.zero,
            ).animate(_scheduleControlsAnimation),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MedicineCalendarStrip(
                  selectedDate: state.selectedDate,
                  onDateSelected: onDateSelected,
                ),
                SizedBox(height: 8.h),
                const MedicineDateLabel(),
              ],
            ).animate().fadeIn(duration: 120.ms, curve: Curves.easeOutCubic),
          ),
        ),
      ),
    );
  }
}
