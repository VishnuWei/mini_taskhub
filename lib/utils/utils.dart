import 'package:flutter/material.dart';

import 'dialogs.dart';

class UtilsWithContext {
  final BuildContext utilContext;

  UtilsWithContext(this.utilContext);

  double getScreenHeight() {
    return MediaQuery.of(utilContext).size.height;
  }

  double getScreenWidth() {
    return MediaQuery.of(utilContext).size.width;
  }

  showSnackBar({required String message, bool? negative, Duration? duration}) {
    final scaffoldMessenger = ScaffoldMessenger.of(utilContext);
    final colorScheme = Theme.of(utilContext).colorScheme;
    scaffoldMessenger.showSnackBar(
      SnackBar(
        duration: duration ?? const Duration(milliseconds: 1000),
        backgroundColor: negative != null
            ? negative
                  ? colorScheme.error
                  : colorScheme.secondaryContainer
            : colorScheme.secondary,
        content: Text(
          message,
          style: Theme.of(
            utilContext,
          ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSecondary),
        ),
      ),
    );
  }
}

class Utils {
  static bool areAllFieldsFilled(
    Map<String, dynamic> formData,
    List<Map<String, dynamic>> fieldDefs,
  ) {
    for (final fieldDef in fieldDefs) {
      final fieldName = fieldDef['fieldName'] ?? fieldDef['parentFieldName'];

      final value = formData[fieldName];

      if (value == null) return false;

      if (value is String && value.trim().isEmpty) return false;

      if (value is Iterable && value.isEmpty) return false;
    }
    return true;
  }

  static bool validateFormData(
    BuildContext context,
    Map<String, dynamic> formData,
    List<Map<String, dynamic>> fieldDefs, {
    List<String>? notNeededFields,
  }) {
    for (Map<String, dynamic> fieldDef in fieldDefs) {
      String fieldName = fieldDef['fieldName'] ?? fieldDef['parentFieldName'];
      String errorMessage = fieldDef['errorMessage'] ?? 'Some field is empty';

      if (notNeededFields != null && notNeededFields.contains(fieldName)) {
        continue;
      }

      debugPrint('fieldName: $fieldName');
      debugPrint('formData[$fieldName]: ${formData[fieldName]}');
      debugPrint('errorMessage: $errorMessage');

      if (formData[fieldName] == null) {
        showCloseableDialog(context, errorMessage);
        return false;
      } else if (formData[fieldName].runtimeType == String &&
          formData[fieldName].trim().isEmpty) {
        showCloseableDialog(context, errorMessage);
        return false;
      } else if (formData[fieldName].isEmpty) {
        showCloseableDialog(context, errorMessage);
        return false;
      }
    }
    return true;
  }

  static showCloseableDialog(BuildContext context, String errorMessage) {
    return Dialogs.showCloseableDialog(
      context,
      AlertType.error,
      'Mandatory field',
      errorMessage,
    );
  }

  static bool isEmpty(dynamic value) {
    if (value == null) {
      return true;
    }
    if (value is String) {
      return value.isEmpty;
    } else if (value is List) {
      return value.isEmpty;
    } else if (value is Map) {
      return value.isEmpty;
    }
    return false;
  }
}
