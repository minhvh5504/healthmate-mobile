import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'register_intro_notifier.dart';

/// Provider
final registerIntroProvider =
    StateNotifierProvider<RegisterIntroNotifier, RegisterIntroState>(
      (ref) => RegisterIntroNotifier(ref),
    );
