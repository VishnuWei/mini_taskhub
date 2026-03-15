import 'package:flutter/material.dart';

enum AlertType { error, success, warning, info }

class Dialogs {
  static void showLoadingIndicator(context, AlertType alertType, String text) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  static Widget getLoadingIndicator() {
    return const Center(child: CircularProgressIndicator());
  }

  static Future<void> showCloseableDialog(
    BuildContext context,
    AlertType alertType,
    String title,
    String content,
  ) async {
    final colorScheme = Theme.of(context).colorScheme;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: colorScheme.surface,
          title: Text(title, style: Theme.of(context).textTheme.titleLarge),
          content: Text(content, style: Theme.of(context).textTheme.bodyMedium),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  static dismiss(BuildContext context) {
    Navigator.pop(context);
  }

  static Future<void> showAlertDialogBox({
    required BuildContext context,
    required String title,
    required String body,
    String? okButtonText,
    String? cancelButtonText,
    required bool havingTwoButtons,
    VoidCallback? onOkPressed,
  }) async {
    final colorScheme = Theme.of(context).colorScheme;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: colorScheme.surface,
          title: Text(title, style: Theme.of(context).textTheme.titleLarge),
          content: Text(body, style: Theme.of(context).textTheme.bodyMedium),
          actions: [
            if (havingTwoButtons)
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(cancelButtonText ?? "Cancel"),
              ),

            ElevatedButton(
              onPressed:
                  onOkPressed ??
                  () {
                    Navigator.pop(context);
                  },
              child: Text(okButtonText ?? "OK"),
            ),
          ],
        );
      },
    );
  }
}
