import 'package:flutter/material.dart';

abstract class AppColors {
  const AppColors();

  Color get backgroundColor;
  Color get cardColor;
  Color get primaryColor;
  Color get accentColor;
  Color get whisper;
  Color get textColor;
  Color get secondaryTextColor;
  Color get disableColor;
  Color get primaryShadowColor;
  Color get onSecondaryColor;
  Color get onPrimaryColor;
  Color get successColor;
  Color get warningColor;
  Color get errorColor;
  Color get shimmerBackgroundColor;
  Color get shimmerHighlightColor;
}

class AppLightColors extends AppColors {
  const AppLightColors();

  @override
  Color get accentColor => const Color(0xFF6B86FF);

  @override
  Color get backgroundColor => const Color(0xFFFAFAFA);

  @override
  Color get cardColor => const Color(0xFFFAFAFA);

  @override
  Color get disableColor => const Color(0xFFCDCDCD);

  @override
  Color get primaryColor => const Color(0xFFFAFAFA);

  @override
  Color get primaryShadowColor => const Color(0xFFD8D8D8);

  @override
  Color get secondaryTextColor => const Color(0xFF828282);

  @override
  Color get textColor => const Color(0xFF414141);

  @override
  Color get whisper => const Color(0xFFEAECF5);

  @override
  Color get errorColor => const Color(0xFFF27C8C);

  @override
  // TODO: implement successColor
  Color get successColor => const Color(0xFF6BCC85);

  @override
  // TODO: implement warningColor
  Color get warningColor => const Color(0xFFFFD141);

  @override
  // TODO: implement onPrimary
  Color get onPrimaryColor => const Color(0xFF414141);

  @override
  // TODO: implement onSecondary
  Color get onSecondaryColor => const Color(0xFFFAFAFA);

  @override
  // TODO: implement shimmerBackgroundColor
  Color get shimmerBackgroundColor => Colors.black12;

  @override
  // TODO: implement shimmerHighlightColor
  Color get shimmerHighlightColor => Colors.white12;
}

class AppDarkColors extends AppColors {
  const AppDarkColors();

  @override
  Color get accentColor => const Color(0xFF7B93FF);

  @override
  Color get backgroundColor => const Color(0xFF121212);

  @override
  Color get cardColor => const Color(0xFF2F2F2F);

  @override
  Color get disableColor => const Color(0xFF2D2D2D);

  @override
  Color get primaryColor => const Color(0xFF121212);

  @override
  Color get primaryShadowColor => const Color(0xFF121212);

  @override
  Color get secondaryTextColor => const Color(0xFFA1A1A1);

  @override
  Color get textColor => const Color(0xFFEAECF5);

  @override
  Color get whisper => const Color(0xFF464646);

  @override
  Color get errorColor => const Color(0xFFEC7887);

  @override
  // TODO: implement successColor
  Color get successColor => const Color(0xFF74B185);

  @override
  // TODO: implement warningColor
  Color get warningColor => const Color(0xFFFFD653);

  @override
  // TODO: implement onPrimary
  Color get onPrimaryColor => const Color(0xFFEAECF5);

  @override
  // TODO: implement onSecondary
  Color get onSecondaryColor => const Color(0xFFEAECF5);

  @override
  // TODO: implement shimmerBackgroundColor
  Color get shimmerBackgroundColor => Colors.white12;

  @override
  // TODO: implement shimmerHighlightColor
  Color get shimmerHighlightColor => Colors.white24;
}
