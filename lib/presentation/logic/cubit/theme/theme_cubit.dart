import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:redrotapp/presentation/themes/app_theme.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(themeMode: ThemeMode.light));

  void updateAppTheme() {
    final Brightness currentBrightness = AppTheme.currentSystemBrightness;
    if (currentBrightness == Brightness.light) {
      emit(ThemeState(themeMode: ThemeMode.light));
    }
    if (currentBrightness == Brightness.dark) {
      emit(ThemeState(themeMode: ThemeMode.dark));
    }
  }
}
