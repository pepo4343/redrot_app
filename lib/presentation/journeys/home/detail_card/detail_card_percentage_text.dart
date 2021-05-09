import 'package:flutter/material.dart';
import 'package:redrotapp/common/constants/size_constants.dart';

class DetailCardPercentageText extends StatelessWidget {
  const DetailCardPercentageText({Key? key, required this.percentage})
      : super(key: key);

  final String percentage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return RichText(
      text: TextSpan(
        text: percentage,
        style: textTheme.headline4!
            .copyWith(color: colorScheme.secondary, height: 0.7),
        children: [
          TextSpan(
            text: "%",
            style: textTheme.headline6!.copyWith(
              color: colorScheme.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
