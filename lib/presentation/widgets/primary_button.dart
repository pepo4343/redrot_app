import 'package:flutter/material.dart';

import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/presentation/widgets/tap_detector.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double width;
  PrimaryButton({
    required this.onPressed,
    required this.text,
    this.width = 100,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TapDetector(
      onPressed: onPressed,
      child: Container(
        width: width,
        decoration: BoxDecoration(
            color: theme.colorScheme.secondary,
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            boxShadow: [
              BoxShadow(
                  blurRadius: 16,
                  color: theme.colorScheme.secondary.withOpacity(0.8),
                  offset: Offset(0, 4))
            ]),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: Sizes.dimen_4),
          child: Center(
            child: Text(
              text,
              style: theme.textTheme.bodyText2?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
