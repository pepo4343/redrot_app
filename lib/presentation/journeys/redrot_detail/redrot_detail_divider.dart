import 'package:flutter/material.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import '../../themes/app_theme.dart';

class RedrotDetailDivider extends StatelessWidget {
  const RedrotDetailDivider({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.headline6,
        ),
        Divider(
          color: theme.colorScheme.disableColor,
          height: Sizes.dimen_2,
        ),
      ],
    );
  }
}
