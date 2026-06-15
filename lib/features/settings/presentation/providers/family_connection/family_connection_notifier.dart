import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthmate_mobile/core/providers/socket_realtime_provider.dart';

import '../../../../../core/routing/app_router.dart';
import '../../../../../core/routing/app_routes.dart';
import '../../../domain/entities/family_connection.dart';
import 'family_connection_provider.dart';

/// STATE
class FamilyConnectionState {
  final bool isLoading;
  final List<FamilyMember>? members;
  final String? errorMessage;
  final Set<String> removingMemberIds;

  const FamilyConnectionState({
    this.isLoading = false,
    this.members,
    this.errorMessage,
    this.removingMemberIds = const {},
  });

  FamilyConnectionState copyWith({
    bool? isLoading,
    List<FamilyMember>? members,
    String? errorMessage,
    Set<String>? removingMemberIds,
  }) {
    return FamilyConnectionState(
      isLoading: isLoading ?? this.isLoading,
      members: members ?? this.members,
      errorMessage: errorMessage,
      removingMemberIds: removingMemberIds ?? this.removingMemberIds,
    );
  }
}

/// NOTIFIER
class FamilyConnectionNotifier extends StateNotifier<FamilyConnectionState> {
  final Ref ref;
  StreamSubscription<Map<String, dynamic>>? _relationshipSub;
  StreamSubscription<Map<String, dynamic>>? _notificationSub;
  bool _isRealtimeRefreshing = false;

  FamilyConnectionNotifier(this.ref) : super(const FamilyConnectionState()) {
    loadMembers();
    _listenToRealtimeEvents();
  }

  /// Load family members
  Future<void> loadMembers({bool showLoader = true}) async {
    if (showLoader) {
      state = state.copyWith(isLoading: true, errorMessage: null);
    }

    try {
      final getFamilyMembers = ref.read(getFamilyMembersUseCaseProvider);
      final members = await getFamilyMembers();
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        members: members,
        errorMessage: null,
      );
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void _listenToRealtimeEvents() {
    final realtimeService = ref.read(realtimeServiceProvider);

    _relationshipSub = realtimeService.onRelationshipUpdate.listen((_) {
      _refreshAfterRealtimeEvent();
    });

    _notificationSub = realtimeService.onNotification.listen((data) {
      final type = data['type']?.toString();
      if (type == 'RELATIONSHIP_ACCEPTED' ||
          type == 'RELATIONSHIP_INVITED' ||
          type == 'RELATIONSHIP_REVOKED' ||
          type == 'RELATIONSHIP_DELETED') {
        _refreshAfterRealtimeEvent();
      }
    });
  }

  Future<void> _refreshAfterRealtimeEvent() async {
    if (_isRealtimeRefreshing) return;

    _isRealtimeRefreshing = true;
    try {
      await loadMembers(showLoader: false);
    } finally {
      _isRealtimeRefreshing = false;
    }
  }

  /// Handle Back
  void onBack() {
    AppRouter.router.pop();
  }

  /// Handle Add Member
  void onAddMember() {
    AppRouter.router.push(AppRoutes.addFamilyMember);
  }

  /// Refresh member list
  Future<void> onRefresh() async {
    await loadMembers();
  }

  /// Remove an invitation or an accepted relationship.
  Future<void> removeRelationship(FamilyMember member) async {
    final previousMembers = state.members ?? const <FamilyMember>[];
    final nextRemovingIds = {...state.removingMemberIds, member.id};

    state = state.copyWith(
      members: previousMembers.where((m) => m.id != member.id).toList(),
      removingMemberIds: nextRemovingIds,
      errorMessage: null,
    );

    try {
      final removeRelationship = ref.read(removeRelationshipUseCaseProvider);
      await removeRelationship(member.id);
      if (!mounted) return;
      state = state.copyWith(
        removingMemberIds: {...state.removingMemberIds}..remove(member.id),
        errorMessage: null,
      );
      await loadMembers(showLoader: false);
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        members: previousMembers,
        removingMemberIds: {...state.removingMemberIds}..remove(member.id),
        errorMessage: e.toString(),
      );
    }
  }

  /// Accept invitation using a token (from deep link)
  Future<void> acceptInvitationByToken(String token) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final acceptInvitation = ref.read(acceptInvitationUseCaseProvider);
      await acceptInvitation(token: token);
      await loadMembers();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  @override
  void dispose() {
    _relationshipSub?.cancel();
    _notificationSub?.cancel();
    super.dispose();
  }
}
