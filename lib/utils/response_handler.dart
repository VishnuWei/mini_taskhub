import 'package:flutter/material.dart';
import 'core_constants.dart';

class ResponseHandler {
  /// Handle success data
  CommonStatus handleSuccess(dynamic data, {String? optionalErrorText}) {
    if (data == null) {
      return CommonStatus.error(optionalErrorText ?? "No data found");
    }

    if (data is Map && data.isEmpty) {
      return CommonStatus.error(optionalErrorText ?? "No data found");
    }

    return CommonStatus.success(data);
  }

  /// Handle exception
  CommonStatus catchError(dynamic e, StackTrace stackTrace) {
    debugPrint("Error: $e");
    debugPrintStack(stackTrace: stackTrace);

    return CommonStatus.error(e.toString());
  }

  /// Full screen response handler
  static Widget getResponseScreen(
    BuildContext context,
    CommonStatus status,
    Widget successScreen, {
    Widget? initialScreen,
    Widget? loadingScreen,
    Widget? errorScreen,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    if (status.screenState == ScreenStateEnum.loading) {
      return loadingScreen ??
          const SafeArea(
            child: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
    }

    if (status.screenState == ScreenStateEnum.error) {
      return errorScreen ??
          Scaffold(
            body: Center(
              child: Text(
                status.errorText ?? "Unknown Error",
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
              ),
            ),
          );
    }

    if (status.screenState == ScreenStateEnum.success) {
      return successScreen;
    }

    return initialScreen ?? const SizedBox();
  }

  /// Widget-level response handler
  static Widget getResponseWidget(
    BuildContext context,
    CommonStatus status,
    Widget successWidget, {
    Widget? initialWidget,
    Widget? loadingWidget,
    Widget? errorWidget,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    if (status.screenState == ScreenStateEnum.loading) {
      return loadingWidget ?? const CircularProgressIndicator();
    }

    if (status.screenState == ScreenStateEnum.error) {
      return errorWidget ??
          Text(
            status.errorText ?? "Unknown Error",
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
          );
    }

    if (status.screenState == ScreenStateEnum.success) {
      return successWidget;
    }

    return initialWidget ?? const SizedBox();
  }

  /// List widget handler
  static List<Widget> getResponseListWidget(
    BuildContext context,
    CommonStatus status,
    List<Widget> successWidget, {
    List<Widget>? initialWidget,
    List<Widget>? loadingWidget,
    List<Widget>? errorWidget,
  }) {
    final screenSize = MediaQuery.sizeOf(context);

    if (status.screenState == ScreenStateEnum.loading) {
      return loadingWidget ??
          [
            SizedBox(
              width: screenSize.width * 0.6,
              child: const LinearProgressIndicator(),
            ),
          ];
    }

    if (status.screenState == ScreenStateEnum.error) {
      return errorWidget ?? [Text(status.errorText ?? "Unknown Error")];
    }

    if (status.screenState == ScreenStateEnum.success) {
      return successWidget;
    }

    return initialWidget ?? [const SizedBox()];
  }
}
