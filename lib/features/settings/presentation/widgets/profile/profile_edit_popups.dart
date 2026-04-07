import 'package:flutter/material.dart';
import 'edit_birthday_bottom_sheet.dart';
import 'edit_gender_bottom_sheet.dart';
import 'edit_name_bottom_sheet.dart';

/// HELPERS FOR SHOWING POPUPS
class ProfileEditPopups {
  static Future<void> showNameEdit(
    BuildContext context, {
    required String initialValue,
    required Function(String) onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditNameBottomSheet(
        initialValue: initialValue,
        onSave: onSave,
      ),
    );
  }

  static Future<void> showGenderEdit(
    BuildContext context, {
    required String? initialValue,
    required Function(String) onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => EditGenderBottomSheet(
        initialValue: initialValue,
        onSave: onSave,
      ),
    );
  }

  static Future<void> showBirthdayEdit(
    BuildContext context, {
    required DateTime? initialValue,
    required Function(DateTime) onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditBirthdayBottomSheet(
        initialValue: initialValue,
        onSave: onSave,
      ),
    );
  }
}
