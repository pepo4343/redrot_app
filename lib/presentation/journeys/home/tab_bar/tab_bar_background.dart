import 'package:flutter/material.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/common/functions.dart';
import '../../../themes/app_theme.dart';

class TabBackground extends StatelessWidget {
  final double width, height;
  final PageController pageController;
  TabBackground({
    required this.height,
    required this.width,
    required this.pageController,
  });

  Function onTapHandler = (int index, PageController pageController) {
    pageController.animateToPage(
      index,
      curve: Curves.easeOut,
      duration: Duration(milliseconds: 300),
    );
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: Sizes.dimen_8),
      decoration: BoxDecoration(
        color: colorScheme.whisperColor,
        borderRadius: BorderRadius.all(
          Radius.circular(height),
        ),
      ),
      width: width,
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () => onTapHandler(0, pageController),
            child: Container(
              color: Colors.transparent,
              width: width / 3,
              child: Center(
                child: FittedBox(
                  child: Text(
                    "รออนุมติ",
                    style: textTheme.bodyText2!
                        .copyWith(color: colorScheme.secondaryTextColor),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => onTapHandler(1, pageController),
            child: Container(
              width: width / 3,
              color: Colors.transparent,
              child: Center(
                child: FittedBox(
                  child: Text(
                    "เสร็จสิ้น",
                    style: textTheme.bodyText2!
                        .copyWith(color: colorScheme.secondaryTextColor),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => onTapHandler(2, pageController),
            child: Container(
              width: width / 3,
              color: Colors.transparent,
              child: Center(
                child: FittedBox(
                  child: Text(
                    "ทั้งหมด",
                    style: textTheme.bodyText2!
                        .copyWith(color: colorScheme.secondaryTextColor),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
