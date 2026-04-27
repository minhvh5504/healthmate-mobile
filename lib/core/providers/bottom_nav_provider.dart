import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider to manage the visibility of the bottom navigation bar
final bottomNavVisibleProvider = StateProvider<bool>((ref) => true);
