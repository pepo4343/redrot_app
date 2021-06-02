import 'package:flutter/material.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/common/functions.dart';

class TabForeground extends StatelessWidget {
  final double width, height;
  TabForeground({
    required this.height,
    required this.width,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: Sizes.dimen_8),
      decoration: BoxDecoration(
        color: colorScheme.secondary,
        borderRadius: BorderRadius.all(
          Radius.circular(height),
        ),
      ),
      width: width,
      height: height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: width / 3,
            child: Center(
              child: FittedBox(
                child: Text(
                  "รออนุมติ",
                  style: textTheme.bodyText2!.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
          Container(
            width: width / 3,
            child: Center(
              child: FittedBox(
                child: Text(
                  "เสร็จสิ้น",
                  style: textTheme.bodyText2!.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
          Container(
            width: width / 3,
            child: Center(
              child: FittedBox(
                child: Text(
                  "ทั้งหมด",
                  style: textTheme.bodyText2!.copyWith(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
