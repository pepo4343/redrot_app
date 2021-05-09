import 'package:flutter/material.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import '../../../themes/app_theme.dart';
import "package:sizer/sizer.dart";
import "../../../themes/app_theme.dart";

class DetailCardProgressBar extends StatelessWidget {
  final int completed;
  final int all;
  DetailCardProgressBar({required this.completed, required this.all});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(Sizes.dimen_10)),
          child: LinearProgressIndicator(
            minHeight: Sizes.dimen_12,
            backgroundColor: Theme.of(context).whisperColor,
            value: completed / all,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        RichText(
          text: TextSpan(
            text: completed.toString(),
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w500),
            children: [
              TextSpan(
                text: "/${all.toString()} กำลังรอการอนุมัติ",
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: Theme.of(context).secondaryTextColor),
              ),
            ],
          ),
        )
      ],
    );
  }
}
