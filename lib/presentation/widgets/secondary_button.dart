import 'package:flutter/material.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/presentation/widgets/tap_detector.dart';

class SecondaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double width;
  SecondaryButton({
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
          color: Colors.transparent,
          borderRadius: const BorderRadius.all(
            const Radius.circular(5),
          ),
          border: Border.all(
            color: theme.colorScheme.secondary,
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Sizes.dimen_4),
          child: Center(
            child: Text(
              text,
              style: theme.textTheme.bodyText2?.copyWith(
                color: theme.colorScheme.secondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
