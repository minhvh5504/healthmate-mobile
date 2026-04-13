import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'add_family_member_notifier.dart';

/// Provider
final addFamilyMemberProvider =
    StateNotifierProvider<AddFamilyMemberNotifier, AddFamilyMemberState>((ref) {
      return AddFamilyMemberNotifier(ref);
    });
