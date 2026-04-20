import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'medicine_stock_notifier.dart';

final medicineStockProvider =
    StateNotifierProvider<MedicineStockNotifier, MedicineStockState>((ref) {
      return MedicineStockNotifier(ref);
    });
