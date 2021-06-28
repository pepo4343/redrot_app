import 'package:flutter/material.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/presentation/journeys/home/tab_bar/tab_bar_background.dart';
import 'package:redrotapp/presentation/journeys/home/tab_bar/tab_bar_chip.dart';

class TabBarApp extends StatelessWidget {
  double barWidth = Sizes.dimen_300;
  final double barHeight = 36;
  final PageController pageController;

  TabBarApp({required this.pageController});
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    barWidth =
        screenWidth < Sizes.dimen_320 ? 0.9 * screenWidth : Sizes.dimen_300;

    return Stack(children: [
      TabBackground(
        height: barHeight,
        width: barWidth,
        pageController: pageController,
      ),
      TabChip(
        barHeight: barHeight,
        barWidth: barWidth,
        pageController: pageController,
      )
    ]);
  }
}
