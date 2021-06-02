import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:redrotapp/presentation/themes/app_colors.dart';
import 'package:redrotapp/presentation/themes/app_shadows.dart';
import 'package:redrotapp/presentation/themes/theme_text.dart';

class AppTheme {
  const AppTheme._();

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ThemeData().colorScheme.copyWith(
          primary: AppLightColors().primaryColor,
          secondary: AppLightColors().accentColor,
          background: AppLightColors().backgroundColor,
          onPrimary: AppLightColors().onPrimaryColor,
          onSecondary: AppLightColors().onSecondaryColor,
        ),
    scaffoldBackgroundColor: AppLightColors().backgroundColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: ThemeText.getLightTextTheme(),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ThemeData.dark().colorScheme.copyWith(
          primary: AppDarkColors().primaryColor,
          secondary: AppDarkColors().accentColor,
          background: AppDarkColors().backgroundColor,
          onPrimary: AppDarkColors().onPrimaryColor,
          onSecondary: AppDarkColors().onSecondaryColor,
        ),
    scaffoldBackgroundColor: AppDarkColors().backgroundColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: ThemeText.getDarkTextTheme(),
  );

  static Brightness get currentSystemBrightness =>
      SchedulerBinding.instance!.window.platformBrightness;

  static AppColors getAppColors(Brightness brightness) {
    return brightness == Brightness.light ? AppLightColors() : AppDarkColors();
  }

  static AppShadows getAppShadows(Brightness brightness) {
    return brightness == Brightness.light
        ? AppLightShadows()
        : AppDarkShadows();
  }
}

extension ThemeDataExtras on ThemeData {
  List<BoxShadow> get primaryBoxShadows =>
      AppTheme.getAppShadows(this.brightness).primaryShadow;
  List<BoxShadow> get secondaryBoxShadows =>
      AppTheme.getAppShadows(this.brightness).secondaryShadow;
  List<BoxShadow> get sucesssBoxShadows =>
      AppTheme.getAppShadows(this.brightness).successShadow;
  List<BoxShadow> get errorBoxShadows =>
      AppTheme.getAppShadows(this.brightness).errorShadow;
}

extension ColorSchemeExtras on ColorScheme {
  Color get cardColor => AppTheme.getAppColors(this.brightness).cardColor;
  Color get whisperColor => AppTheme.getAppColors(this.brightness).whisper;
  Color get secondaryTextColor =>
      AppTheme.getAppColors(this.brightness).secondaryTextColor;
  Color get textColor => AppTheme.getAppColors(this.brightness).textColor;
  Color get disableColor => AppTheme.getAppColors(this.brightness).disableColor;
  Color get successColor => AppTheme.getAppColors(this.brightness).successColor;
  Color get warningColor => AppTheme.getAppColors(this.brightness).warningColor;
  Color get errorColor => AppTheme.getAppColors(this.brightness).errorColor;
  Color get shimmerBackgroundColor =>
      AppTheme.getAppColors(this.brightness).shimmerBackgroundColor;
  Color get shimmerHighlightColor =>
      AppTheme.getAppColors(this.brightness).shimmerHighlightColor;
}
