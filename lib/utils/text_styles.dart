import 'package:flutter/material.dart';

TextStyle headingTextBoldTextStyle(Color optionalColor, { double? fontSize}) {
  return TextStyle(
    color: optionalColor,
    fontSize: fontSize ?? 20,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.none,
  );
}
TextStyle extraboldHeading(Color optionalColor, {double? fontSize}) {
  return TextStyle(
    color: optionalColor,
    fontSize: fontSize ?? 24,
    fontWeight: FontWeight.w700,
    decoration: TextDecoration.none,
    wordSpacing: 0.20,

  );
}

TextStyle subHeadingTextBoldTextStyle(Color optionalColor, {double? fontSize,FontWeight? fontWeight}) {
  return TextStyle(
    color: optionalColor,
    fontSize: fontSize ?? 16,
    fontWeight: fontWeight ?? FontWeight.w500,
    decoration: TextDecoration.none,
  );
}

TextStyle bodyContentTextStyle(Color? optionalColor, {double? fontSize,FontWeight? fontWeight}) {
  return TextStyle(
    color: optionalColor,
    fontSize: fontSize ?? 16,
    fontWeight: fontWeight ?? FontWeight.w400,
    decoration: TextDecoration.none,
    wordSpacing: 0.24,
  );
}

TextStyle buttonTextStyle(Color optionalColor, {double? fontSize,FontWeight? fontWeight}) {
  return TextStyle(
    color: optionalColor,
    fontSize: fontSize ?? 16,
    fontWeight:fontWeight ?? FontWeight.w800,
    decoration: TextDecoration.none,
    wordSpacing: 0.24,
  );
}

TextStyle labelTextStyle(Color optionalColor, {double? fontSize,FontWeight? fontWeight}) {
  return TextStyle(
    color: optionalColor,
    fontSize: fontSize ?? 12,
    fontWeight: fontWeight ?? FontWeight.w400,
    decoration: TextDecoration.none,
  );
}

TextStyle verySmallTextStyle(Color? optionalColor, {double? fontSize ,FontWeight? fontWeight}) {
  return TextStyle(
    color: optionalColor,
    fontSize: fontSize ?? 10,
    fontWeight: fontWeight ?? FontWeight.w400,
    decoration: TextDecoration.none,
  );
}

TextStyle linkTextStyle(Color? optionalColor, {double? fontSize}) {
  return TextStyle(
    color: optionalColor,
    fontSize: fontSize ?? 12,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.underline,
  );
}