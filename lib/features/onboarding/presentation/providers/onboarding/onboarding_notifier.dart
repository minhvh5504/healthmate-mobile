import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/routing/app_routes.dart';
import '../../widgets/login_modal.dart';

/// State
class OnboardingState {
  final int currentIndex;
  final bool isLoading;

  const OnboardingState({this.currentIndex = 0, this.isLoading = false});

  OnboardingState copyWith({int? currentIndex, bool? isLoading}) {
    return OnboardingState(
      currentIndex: currentIndex ?? this.currentIndex,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Notifier
class OnboardingNotifier extends StateNotifier<OnboardingState> {
  late final PageController controller;
  final Ref ref;

  OnboardingNotifier(this.ref) : super(const OnboardingState()) {
    controller = PageController();
  }

  /// Updates the current page index
  void onPageChanged(int index) {
    state = state.copyWith(currentIndex: index);
  }

  /// Handle next page
  void nextPage(BuildContext context) {
    context.go(AppRoutes.registerintro);
  }

  /// Handles login button
  void handleLogin(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LoginModal(
        onContinueWithEmail: () => onContinueWithEmail(context),
        onContinueWithGoogle: () => onContinueWithGoogle(context),
      ),
    );
  }

  /// Handle Continue with Email
  void onContinueWithEmail(BuildContext context) {
    context.pop();
    context.push(AppRoutes.login);
  }

  /// Handle Continue with Google
  Future<void> onContinueWithGoogle(BuildContext context) async {
    // _setLoading(true);
    // try {
    //   final androidClientId = dotenv.env['ANDROID_CLIENT_ID'];
    //   final webClientId = dotenv.env['GOOGLE_CLIENT_ID'];
    //   final clientId = defaultTargetPlatform == TargetPlatform.android
    //       ? androidClientId
    //       : webClientId;

    //   if (clientId == null || clientId.isEmpty) {
    //     throw Exception('Missing GOOGLE_CLIENT_ID / ANDROID_CLIENT_ID in .env');
    //   }

    //   final GoogleSignIn signIn = GoogleSignIn.instance;
    //   await signIn.initialize(clientId: clientId);

    //   final completer = Completer<GoogleSignInAccount?>();
    //   late final StreamSubscription sub;
    //   sub = signIn.authenticationEvents.listen((event) async {
    //     if (event is GoogleSignInAuthenticationEventSignIn) {
    //       completer.complete(event.user);
    //       await sub.cancel();
    //     } else if (event is GoogleSignInAuthenticationEventSignOut) {
    //       completer.complete(null);
    //       await sub.cancel();
    //     }
    //   });

    //   await signIn.authenticate();
    //   final GoogleSignInAccount? googleUser = await completer.future;

    //   if (googleUser == null) {
    //     throw Exception('Google Sign-In canceled');
    //   }

    //   final GoogleSignInAuthentication googleAuth = googleUser.authentication;
    //   if (googleAuth.idToken == null || googleAuth.idToken!.isEmpty) {
    //     throw Exception('Failed to get ID token from Google');
    //   }

    //   final credential = GoogleAuthProvider.credential(
    //     idToken: googleAuth.idToken,
    //   );

    //   final userCredential = await FirebaseAuth.instance.signInWithCredential(
    //     credential,
    //   );

    //   final firebaseUser = userCredential.user;
    //   if (firebaseUser == null) throw Exception('Firebase login failed');

    //   final firebaseIdToken = await firebaseUser.getIdToken();

    //   if (firebaseIdToken == null || firebaseIdToken.isEmpty) {
    //     throw Exception('Firebase token missing');
    //   }

    //   final authUser = await _loginWithGoogleUseCase(firebaseIdToken);
    //   await ref
    //       .read(authProvider.notifier)
    //       .login(
    //         accessToken: authUser.accessToken,
    //         refreshToken: authUser.refreshToken,
    //       );

    //   final prefs = await SharedPreferences.getInstance();
    //   await prefs.setString('login_type', 'google');

    //   _setLoading(false);
    //   context.go(AppRoutes.home);
    // } catch (e) {
    //   _setLoading(false);
    //   _handleFailure(context, e);
    // }
  }

  /// Disposes the page controller
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
