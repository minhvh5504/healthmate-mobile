import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthmate_mobile/features/settings/presentation/providers/add_family_member/add_family_member_provider.dart';
import 'package:healthmate_mobile/features/settings/presentation/providers/family_connection/family_connection_provider.dart';
import 'package:toastification/toastification.dart';
import '../../../../../core/routing/app_router.dart';
import '../../../../../core/utils/validation.dart';

/// STATE
class AddFamilyMemberState {
  final bool isLoading;
  final TextEditingController emailController;
  final String? errorMessage;
  final bool emailValid;
  final bool hasEmailError;
  final bool isValid;
  // final String? invitationLink;

  AddFamilyMemberState({
    this.isLoading = false,
    required this.emailController,
    this.errorMessage,
    this.emailValid = false,
    this.hasEmailError = false,
    this.isValid = false,
  });

  AddFamilyMemberState copyWith({
    bool? isLoading,
    TextEditingController? emailController,
    String? errorMessage,
    bool? emailValid,
    bool? hasEmailError,
    bool? isValid,
  }) {
    return AddFamilyMemberState(
      isLoading: isLoading ?? this.isLoading,
      emailController: emailController ?? this.emailController,
      errorMessage: errorMessage,
      emailValid: emailValid ?? this.emailValid,
      hasEmailError: hasEmailError ?? this.hasEmailError,
      isValid: isValid ?? this.isValid,
    );
  }
}

/// NOTIFIER
class AddFamilyMemberNotifier extends StateNotifier<AddFamilyMemberState> {
  static const int maxFamilyMembers = 5;

  final Ref ref;

  AddFamilyMemberNotifier(this.ref)
    : super(AddFamilyMemberState(emailController: TextEditingController())) {
    _initListeners();
  }

  // Listen to input changes and validate
  void _initListeners() {
    state.emailController.addListener(_validateInput);
  }

  // Validate email input
  void _validateInput() {
    final text = state.emailController.text.trim();
    final valid = Validation.isValidEmail(text);

    final hasEmailError = !valid && text.isNotEmpty;

    state = state.copyWith(
      emailValid: valid,
      hasEmailError: hasEmailError,
      isValid: valid,
    );
  }

  @override
  void dispose() {
    state.emailController.dispose();
    super.dispose();
  }

  /// Handle Connect
  Future<void> onConnect() async {
    if (state.isLoading) return;

    final email = state.emailController.text.trim();
    if (email.isEmpty || !state.emailValid) return;

    final memberCount = (ref.read(familyConnectionProvider).members ?? [])
        .where((member) => member.status != 'revoked')
        .length;
    if (memberCount >= maxFamilyMembers) {
      final errorMsg = 'add_family.errors.limit_reached'.tr(
        args: [maxFamilyMembers.toString()],
      );
      state = state.copyWith(errorMessage: errorMsg);
      toastification.show(
        title: Text(errorMsg),
        autoCloseDuration: const Duration(seconds: 4),
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
      );
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final inviteUseCase = ref.read(inviteFamilyMemberUseCaseProvider);
      await inviteUseCase(email);

      state = state.copyWith(isLoading: false);

      // Show success toast
      toastification.show(
        title: Text('add_family.invite_success'.tr()),
        autoCloseDuration: const Duration(seconds: 3),
        type: ToastificationType.success,
        style: ToastificationStyle.flat,
      );

      // Refresh list then navigate back
      await ref.read(familyConnectionProvider.notifier).onRefresh();
      AppRouter.router.pop(true);
    } catch (e) {
      final errorMsg = e.toString().contains('Exception:')
          ? e.toString().split('Exception:').last.trim()
          : e.toString();

      state = state.copyWith(isLoading: false, errorMessage: errorMsg);

      // Show error toast
      toastification.show(
        title: Text(errorMsg),
        autoCloseDuration: const Duration(seconds: 4),
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
      );
    }
  }

  /// Handle Back
  void onBack() {
    AppRouter.router.pop();
  }

  /*
  /// Copy link to clipboard
  void copyInvitationLink(BuildContext context) {
    if (state.invitationLink == null) return;

    Clipboard.setData(ClipboardData(text: state.invitationLink!)).then((_) {
      toastification.show(
        title: Text('add_family.link_copied'.tr()),
        autoCloseDuration: const Duration(seconds: 2),
        type: ToastificationType.success,
        style: ToastificationStyle.flat,
      );
    });
  }
  */
}
