import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'register_intro_notifier.dart';

/// Notifier
final registerIntroNotifierProvider =
    StateNotifierProvider<RegisterIntroNotifier, RegisterIntroState>(
      (ref) => RegisterIntroNotifier(ref),
    );
