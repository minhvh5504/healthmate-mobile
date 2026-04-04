import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/config/routing/app_router.dart';
import '../../../../../core/config/routing/app_routes.dart';
import '../../../domain/entities/family_connection.dart';
import 'family_connection_provider.dart';

/// STATE
class FamilyConnectionState {
  final bool isLoading;
  final List<FamilyMember>? members;
  final String? errorMessage;

  const FamilyConnectionState({
    this.isLoading = false,
    this.members,
    this.errorMessage,
  });

  FamilyConnectionState copyWith({
    bool? isLoading,
    List<FamilyMember>? members,
    String? errorMessage,
  }) {
    return FamilyConnectionState(
      isLoading: isLoading ?? this.isLoading,
      members: members ?? this.members,
      errorMessage: errorMessage,
    );
  }
}

/// NOTIFIER
class FamilyConnectionNotifier extends StateNotifier<FamilyConnectionState> {
  final Ref ref;

  FamilyConnectionNotifier(this.ref) : super(const FamilyConnectionState()) {
    loadMembers();
  }

  /// Load family members
  Future<void> loadMembers() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final getFamilyMembers = ref.read(getFamilyMembersUseCaseProvider);
      final members = await getFamilyMembers();
      state = state.copyWith(isLoading: false, members: members);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Handle Back
  void onBack() {
    AppRouter.router.go(AppRoutes.settings);
  }

  /// Handle Add Member
  void onAddMember() {
    // AppRouter.router.push(AppRoutes.addFamilyMember);
  }

  /// Refresh member list
  Future<void> onRefresh() async {
    await loadMembers();
  }
}
