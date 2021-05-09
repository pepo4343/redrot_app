import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redrotapp/presentation/themes/app_colors.dart';
import '../../common/constants/size_constants.dart';
import 'package:sizer/sizer.dart';

class ThemeText {
  const ThemeText._();

  static TextStyle get _lightHeadline4 => TextStyle(
        fontSize: Sizes.dimen_24.sp,
        color: AppColors.lightTextColor,
        fontFamily: "Kanit",
        fontWeight: FontWeight.w400,
      );
  static TextStyle get _lightHeadline5 => TextStyle(
        fontSize: Sizes.dimen_18.sp,
        color: AppColors.lightTextColor,
        fontFamily: "Kanit",
        fontWeight: FontWeight.w400,
      );
  static TextStyle get _lightHeadline6 => TextStyle(
        fontSize: Sizes.dimen_14.sp,
        color: AppColors.lightTextColor,
        fontFamily: "Kanit",
        fontWeight: FontWeight.w400,
      );

  static TextStyle get _lightBodyText2 => TextStyle(
        fontSize: Sizes.dimen_12.sp,
        color: AppColors.lightTextColor,
        fontFamily: "Kanit",
        fontWeight: FontWeight.w400,
      );

  static TextStyle get _lightCaption => TextStyle(
        fontSize: Sizes.dimen_10.sp,
        color: AppColors.lightSecondaryTextColor,
        fontFamily: "Kanit",
        fontWeight: FontWeight.w400,
      );
  static getLigthTextTheme() => TextTheme(
      headline4: _lightHeadline4,
      headline6: _lightHeadline6,
      headline5: _lightHeadline5,
      bodyText2: _lightBodyText2,
      caption: _lightCaption);
}
