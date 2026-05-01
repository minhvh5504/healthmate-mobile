import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../routing/app_routes.dart';
import '../providers/app_state_provider.dart';
import '../../features/settings/presentation/providers/family_connection/family_connection_provider.dart';

class DeepLinkHandler {
  static String? handleRedirect(Ref ref, GoRouterState state) {
    // Family Invitation Accept deep link: healthmate://family/accept?status=success&token=...
    if (state.uri.path == AppRoutes.familyAccept) {
      final status = state.uri.queryParameters['status'];

      // Backend already accepted the invitation before redirecting here.
      // Only call the API again if there is no status (direct in-app deep link without backend processing).
      if (status == null) {
        final token = state.uri.queryParameters['token'];
        if (token != null) {
          ref
              .read(familyConnectionProvider.notifier)
              .acceptInvitationByToken(token);
        }
      } else if (status == 'success') {
        // Backend already accepted — just refresh the list
        ref.read(familyConnectionProvider.notifier).onRefresh();
      }
      // status == 'error': navigate to family connection page to show current state

      final isInitialized = ref.read(appInitializedProvider);
      return isInitialized ? AppRoutes.familyConnection : AppRoutes.splash;
    }

    return null;
  }
}
