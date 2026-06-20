import 'package:healthmate_mobile/core/utils/app_toast.dart';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/routing/app_routes.dart';

import '../../../../../core/constants/strings.dart';
import '../../../../../core/routing/app_router.dart';
import '../../../../../core/providers/user_provider.dart';
import '../../../domain/usecases/upload_user_avatar.dart';

class SettingsState {
  final bool isLoading;
  final bool isUploadingAvatar;
  final String? errorMessage;

  const SettingsState({
    this.isLoading = false,
    this.isUploadingAvatar = false,
    this.errorMessage,
  });

  SettingsState copyWith({
    bool? isLoading,
    bool? isUploadingAvatar,
    String? errorMessage,
  }) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
      isUploadingAvatar: isUploadingAvatar ?? this.isUploadingAvatar,
      errorMessage: errorMessage,
    );
  }
}

/// NOTIFIER
class SettingsNotifier extends StateNotifier<SettingsState> {
  final Ref ref;
  final UploadUserAvatar _uploadUserAvatar;

  SettingsNotifier(this.ref, this._uploadUserAvatar)
    : super(const SettingsState()) {
    ref.read(userProfileProvider.notifier).fetchProfile();
  }

  /// Handle Back
  void onBack() {
    AppRouter.router.go(AppRoutes.medicine);
  }

  /// Handle Basic Info
  void onBasicInfo() {
    AppRouter.router.go(AppRoutes.profile);
  }

  /// Handle Family Connect
  void onFamilyConnect() {
    AppRouter.router.push(AppRoutes.familyConnection);
  }

  /// Handle Notifications
  void onNotifications() {
    AppRouter.router.go(AppRoutes.notificationSettings);
  }

  /// Handle Advanced
  void onAdvanced() {
    AppRouter.router.go(AppRoutes.highSettings);
  }

  /// Handle Support
  Future<void> onSupport() async {
    final uri = Uri(
      scheme: 'mailto',
      path: supportLink,
      queryParameters: const {'subject': 'Contact for Support'},
    );

    final opened = await _tryLaunchSupportEmail(uri);
    if (opened) return;

    await _copySupportEmail();
  }

  Future<bool> _tryLaunchSupportEmail(Uri uri) async {
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  Future<void> _copySupportEmail() async {
    await Clipboard.setData(const ClipboardData(text: supportLink));
  }

  /// Handle Edit avatar
  Future<void> onEditAvatar(BuildContext context) async {
    if (state.isUploadingAvatar) return;

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt_rounded),
                  title: Text('settings.avatar_take_photo'.tr()),
                  onTap: () => Navigator.of(context).pop(ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_rounded),
                  title: Text('settings.avatar_upload_photo'.tr()),
                  onTap: () => Navigator.of(context).pop(ImageSource.gallery),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (source == null) return;
    await _pickAndUploadAvatar(source);
  }

  Future<void> _pickAndUploadAvatar(ImageSource source) async {
    state = state.copyWith(isUploadingAvatar: true, errorMessage: null);
    try {
      final hasPermission = await _requestAvatarPermission(source);
      if (!hasPermission) {
        final message = 'settings.avatar_permission_denied'.tr();
        state = state.copyWith(isUploadingAvatar: false, errorMessage: message);
        _showAvatarToast(message, ToastificationType.error);
        return;
      }

      final image = await ImagePicker().pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image == null) {
        state = state.copyWith(isUploadingAvatar: false);
        return;
      }

      final profile = await _uploadUserAvatar(File(image.path));

      // Clear Flutter's image cache so the new avatar loads from network.
      // A targeted evict won't work because the widget adds a ?t= cache-bust
      // param that changes the cached key vs. the raw avatarUrl stored in state.
      PaintingBinding.instance.imageCache.clear();

      ref.read(userProfileProvider.notifier).updateProfile(profile);

      state = state.copyWith(isUploadingAvatar: false);
      _showAvatarToast(
        'settings.avatar_update_success'.tr(),
        ToastificationType.success,
      );
    } catch (e) {
      final message = AppToast.message(e);
      state = state.copyWith(isUploadingAvatar: false, errorMessage: message);
      _showAvatarToast(message, ToastificationType.error);
    }
  }

  Future<bool> _requestAvatarPermission(ImageSource source) async {
    if (source == ImageSource.camera) {
      return (await Permission.camera.request()).isGranted;
    }

    final photos = await Permission.photos.request();
    if (photos.isGranted || photos.isLimited) return true;

    return (await Permission.storage.request()).isGranted;
  }

  void _showAvatarToast(String message, ToastificationType type) {
    toastification.show(
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 3),
      type: type,
      style: ToastificationStyle.flat,
    );
  }
}
