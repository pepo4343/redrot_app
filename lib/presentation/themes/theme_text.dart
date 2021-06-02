import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redrotapp/presentation/themes/app_colors.dart';
import '../../common/constants/size_constants.dart';

class ThemeText {
  const ThemeText._();

  static TextStyle get _lightHeadline1 => TextStyle(
        fontSize: 64,
        color: AppLightColors().textColor,
        fontFamily: "Kanit",
        fontWeight: FontWeight.w400,
      );
  static TextStyle get _lightHeadline2 => TextStyle(
        fontSize: 48,
        color: AppLightColors().textColor,
        fontFamily: "Kanit",
        fontWeight: FontWeight.w400,
      );
  static TextStyle get _lightHeadline3 => TextStyle(
        fontSize: 32,
        color: AppLightColors().textColor,
        fontFamily: "Kanit",
        fontWeight: FontWeight.w400,
      );
  static TextStyle get _lightHeadline4 => TextStyle(
        fontSize: 26,
        color: AppLightColors().textColor,
        fontFamily: "Kanit",
        fontWeight: FontWeight.w400,
      );
  static TextStyle get _lightHeadline5 => TextStyle(
        fontSize: 20,
        color: AppLightColors().textColor,
        fontFamily: "Kanit",
        fontWeight: FontWeight.w400,
      );
  static TextStyle get _lightHeadline6 => TextStyle(
        fontSize: 16,
        color: AppLightColors().textColor,
        fontFamily: "Kanit",
        fontWeight: FontWeight.w400,
      );

  static TextStyle get _lightBodyText1 => TextStyle(
        fontSize: 16,
        color: AppLightColors().textColor,
        fontFamily: "Kanit",
        fontWeight: FontWeight.w300,
      );

  static TextStyle get _lightBodyText2 => TextStyle(
        fontSize: 14,
        color: AppLightColors().textColor,
        fontFamily: "Kanit",
        fontWeight: FontWeight.w300,
      );

  static TextStyle get _lightCaption => TextStyle(
        fontSize: 12,
        color: AppLightColors().secondaryTextColor,
        fontFamily: "Kanit",
        fontWeight: FontWeight.w300,
      );
  static TextStyle get _darkHeadline1 => ThemeText._lightHeadline1.copyWith(
        color: AppDarkColors().textColor,
      );
  static TextStyle get _darkHeadline2 => ThemeText._lightHeadline2.copyWith(
        color: AppDarkColors().textColor,
      );
  static TextStyle get _darkHeadline3 => ThemeText._lightHeadline3.copyWith(
        color: AppDarkColors().textColor,
      );
  static TextStyle get _darkHeadline4 => ThemeText._lightHeadline4.copyWith(
        color: AppDarkColors().textColor,
      );
  static TextStyle get _darkHeadline5 => ThemeText._lightHeadline5.copyWith(
        color: AppDarkColors().textColor,
      );
  static TextStyle get _darkHeadline6 => ThemeText._lightHeadline6.copyWith(
        color: AppDarkColors().textColor,
      );

  static TextStyle get _darkBodyText1 => ThemeText._lightBodyText1.copyWith(
        color: AppDarkColors().textColor,
      );
  static TextStyle get _darkBodyText2 => ThemeText._lightBodyText2.copyWith(
        color: AppDarkColors().textColor,
      );

  static TextStyle get _darkCaption => ThemeText._lightCaption.copyWith(
        color: AppDarkColors().secondaryTextColor,
      );
  static getLightTextTheme() => TextTheme(
        headline1: _lightHeadline1,
        headline2: _lightHeadline2,
        headline3: _lightHeadline3,
        headline4: _lightHeadline4,
        headline6: _lightHeadline6,
        headline5: _lightHeadline5,
        bodyText2: _lightBodyText2,
        bodyText1: _lightBodyText1,
        caption: _lightCaption,
      );

  static getDarkTextTheme() => TextTheme(
        headline1: _darkHeadline1,
        headline2: _darkHeadline2,
        headline3: _darkHeadline3,
        headline4: _darkHeadline4,
        headline6: _darkHeadline6,
        headline5: _darkHeadline5,
        bodyText2: _darkBodyText2,
        bodyText1: _darkBodyText1,
        caption: _darkCaption,
      );
}
