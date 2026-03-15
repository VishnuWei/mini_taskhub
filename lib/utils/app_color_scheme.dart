import 'package:flutter/material.dart';

class AppColorScheme {

  static const ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,

    primary: Color(0xFFF2C94C),
    onPrimary: Color(0xFF1F2A35),

    secondary: Color(0xFF4E6572),
    onSecondary: Color(0xFFFFFFFF),

    tertiary: Color(0xFF3E5563),
    onTertiary: Color(0xFFFFFFFF),

    surface: Color(0xFF1F2A35),
    onSurface: Color(0xFFFFFFFF),

    onSurfaceVariant: Color(0xFF9AA6B2),

    error: Color(0xFFD32F2F),
    onError: Color(0xFFFFFFFF),

    secondaryContainer: Color(0xFF4E6572),
    tertiaryContainer: Color(0xFF3E5563),

    outline: Color(0xFF6B7C8A),
    outlineVariant: Color(0xFF9AA6B2),

    shadow: Color(0xFF000000),
  );

  static const ColorScheme light = ColorScheme(
    brightness: Brightness.light,

    primary: Color(0xFFF2C94C),
    onPrimary: Colors.black,

    secondary: Color(0xFFE3EDF3),
    onSecondary: Color(0xFF1F2A35),

    tertiary: Color(0xFFF1F5F8),
    onTertiary: Color(0xFF1F2A35),

    surface: Colors.white,
    onSurface: Color(0xFF1F2A35),

    onSurfaceVariant: Color(0xFF6B7C8A),

    error: Color(0xFFD32F2F),
    onError: Colors.white,

    secondaryContainer: Color(0xFFE3EDF3),
    tertiaryContainer: Color(0xFFF1F5F8),

    outline: Color(0xFF9AA6B2),
    outlineVariant: Color(0xFF6B7C8A),

    shadow: Color(0x22000000),
  );
}