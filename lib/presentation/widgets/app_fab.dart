import 'package:flutter/material.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/presentation/widgets/tap_detector.dart';
import '../themes/app_theme.dart';

class AppFab extends StatelessWidget {
  static const double buttonSize = Sizes.dimen_60;
  final Widget child;
  final VoidCallback onPressed;
  AppFab({
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Hero(
      tag: "FAB",
      child: TapDetector(
        onPressed: onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary,
            borderRadius: BorderRadius.all(
              Radius.circular(AppFab.buttonSize),
            ),
            boxShadow: theme.secondaryBoxShadows,
          ),
          width: AppFab.buttonSize,
          height: AppFab.buttonSize,
          child: child,
        ),
      ),
    );
  }
}
