import 'package:flutter/material.dart';
import 'package:redrotapp/presentation/themes/app_colors.dart';
import 'package:redrotapp/presentation/themes/theme_text.dart';

class AppTheme {
  const AppTheme._();

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ThemeData().colorScheme.copyWith(
          primary: AppColors.lightPrimaryColor,
          secondary: AppColors.lightAccentColor,
          background: AppColors.lightBackgroundColor,
        ),
    scaffoldBackgroundColor: AppColors.lightBackgroundColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: ThemeText.getLigthTextTheme(),
  );
}

extension ThemeExtras on ThemeData {
  Color get whisperColor => AppColors.lightWhisper;
  Color get secondaryTextColor => AppColors.lightSecondaryTextColor;
}
