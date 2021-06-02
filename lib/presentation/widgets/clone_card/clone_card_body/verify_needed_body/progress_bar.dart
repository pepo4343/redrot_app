import 'package:flutter/material.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/common/functions.dart';
import '../../../../themes/app_theme.dart';

class ProgressBar extends StatelessWidget {
  final int completed;
  final int all;
  final double progress;

  ProgressBar(
      {required this.completed, required this.all, required this.progress});
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    final _colorScheme = _theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(Sizes.dimen_10)),
          child: LinearProgressIndicator(
            minHeight: Sizes.dimen_12,
            backgroundColor: _colorScheme.whisperColor,
            value: progress,
            color: _colorScheme.secondary,
          ),
        ),
        RichText(
          text: TextSpan(
            text: completed.toString(),
            style: _textTheme.bodyText2!.copyWith(
                color: _colorScheme.secondary, fontWeight: FontWeight.w500),
            children: [
              TextSpan(
                text: "/${all.toString()} กำลังรอการอนุมัติ",
                style: _textTheme.bodyText2!
                    .copyWith(color: _colorScheme.secondaryTextColor),
              ),
            ],
          ),
        )
      ],
    );
  }
}
