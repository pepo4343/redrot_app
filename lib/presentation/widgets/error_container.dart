import 'package:flutter/material.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/presentation/widgets/tap_detector.dart';
import '../themes/app_theme.dart';

class ErrorContainer extends StatelessWidget {
  const ErrorContainer({
    Key? key,
    required this.onRefresh,
  }) : super(key: key);
  final VoidCallback onRefresh;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "โปรดลองใหม่อีกครั้ง",
          style: theme.textTheme.bodyText1,
        ),
        SizedBox(
          height: Sizes.dimen_18,
        ),
        RefreshButton(
          onPressed: onRefresh,
        )
      ],
    );
  }
}

class RefreshButton extends StatelessWidget {
  const RefreshButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TapDetector(
      onPressed: onPressed,
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          boxShadow: theme.secondaryBoxShadows,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.refresh,
              color: theme.colorScheme.onSecondary,
              size: Sizes.dimen_18,
            ),
            SizedBox(
              width: Sizes.dimen_4,
            ),
            Text(
              "ลองอีกครั้ง",
              style: theme.textTheme.bodyText1!
                  .copyWith(color: theme.colorScheme.onSecondary),
            )
          ],
        ),
      ),
    );
  }
}
