import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tracks whether the app has completed its initial splash/onboarding sequence.
final appInitializedProvider = StateProvider<bool>((ref) => false);
