import 'package:flutter/material.dart';
import 'package:mini_taskhub/utils/text_styles.dart';

ThemeData buildTheme(ColorScheme colorScheme) {
  return ThemeData(
    brightness: colorScheme.brightness,
    useMaterial3: true,
    colorScheme: colorScheme,
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: colorScheme.surface,

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: headingTextBoldTextStyle(
        colorScheme.onSurface,
      ),
    ),

    cardTheme: CardThemeData(
      color: colorScheme.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.outline,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        textStyle: buttonTextStyle(colorScheme.onPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.primary,
        side: BorderSide(color: colorScheme.primary),
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: colorScheme.secondary,
      contentTextStyle: bodyContentTextStyle(
        colorScheme.onSecondary,
      ),
      behavior: SnackBarBehavior.floating,
    ),

    inputDecorationTheme: InputDecorationTheme(
      hintStyle: labelTextStyle(colorScheme.onSurfaceVariant),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colorScheme.primary),
      ),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStatePropertyAll(colorScheme.primary),
      checkColor: WidgetStatePropertyAll(colorScheme.onPrimary),
    ),

    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStatePropertyAll(colorScheme.onSurface),
      ),
    ),

    listTileTheme: ListTileThemeData(
      titleTextStyle: subHeadingTextBoldTextStyle(
        colorScheme.onSurface,
      ),
      subtitleTextStyle: labelTextStyle(
        colorScheme.onSurfaceVariant,
      ),
    ),

    textTheme: TextTheme(
      displayLarge: headingTextBoldTextStyle(
        colorScheme.onSurface,
      ),
      bodyLarge: bodyContentTextStyle(colorScheme.onSurface),
      bodySmall: labelTextStyle(colorScheme.onSurfaceVariant),
    ),
  );
}
