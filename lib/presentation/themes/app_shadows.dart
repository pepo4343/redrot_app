import 'package:flutter/material.dart';
import 'package:redrotapp/common/constants/size_constants.dart';

import 'app_colors.dart';

abstract class AppShadows {
  List<BoxShadow> get primaryShadow;
  List<BoxShadow> get secondaryShadow;
  List<BoxShadow> get successShadow;
  List<BoxShadow> get errorShadow;
  List<BoxShadow> get darkShadow;
  List<BoxShadow> get disableShadow;
}

class AppLightShadows extends AppShadows {
  @override
  List<BoxShadow> get primaryShadow => [
        BoxShadow(
          blurRadius: Sizes.dimen_16,
          color: const AppLightColors().primaryShadowColor,
          offset: const Offset(Sizes.dimen_0, Sizes.dimen_4),
        )
      ];

  @override
  List<BoxShadow> get secondaryShadow => [
        BoxShadow(
          blurRadius: Sizes.dimen_16,
          color: const AppLightColors().accentColor.withOpacity(0.8),
          offset: const Offset(Sizes.dimen_0, Sizes.dimen_4),
        )
      ];

  @override
  // TODO: implement errorShadow
  List<BoxShadow> get errorShadow => [
        BoxShadow(
          blurRadius: Sizes.dimen_16,
          color: const AppLightColors().errorColor.withOpacity(0.8),
          offset: const Offset(Sizes.dimen_0, Sizes.dimen_4),
        )
      ];

  @override
  List<BoxShadow> get successShadow => [
        BoxShadow(
          blurRadius: Sizes.dimen_16,
          color: const AppLightColors().successColor.withOpacity(0.8),
          offset: const Offset(Sizes.dimen_0, Sizes.dimen_4),
        )
      ];

  @override
  List<BoxShadow> get darkShadow => [
        BoxShadow(
          blurRadius: Sizes.dimen_16,
          color: const AppLightColors().darkColor.withOpacity(0.8),
          offset: const Offset(Sizes.dimen_0, Sizes.dimen_4),
        )
      ];

  @override
  List<BoxShadow> get disableShadow => [
        BoxShadow(
          blurRadius: Sizes.dimen_16,
          color: const AppLightColors().disableColor.withOpacity(0.8),
          offset: const Offset(Sizes.dimen_0, Sizes.dimen_4),
        )
      ];
}

class AppDarkShadows extends AppShadows {
  @override
  List<BoxShadow> get primaryShadow => [];

  @override
  List<BoxShadow> get secondaryShadow => [];

  @override
  List<BoxShadow> get errorShadow => [];

  @override
  List<BoxShadow> get successShadow => [];

  @override
  List<BoxShadow> get darkShadow => [];

  @override
  List<BoxShadow> get disableShadow => [];
}
