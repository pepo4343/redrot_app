import 'package:flutter/material.dart';
import 'package:redrotapp/presentation/journeys/home/tab_bar/tab_bar_foreground.dart';

import 'chip_clip_part.dart';

class TabChip extends StatefulWidget {
  const TabChip(
      {Key? key,
      required this.barHeight,
      required this.barWidth,
      required this.pageController})
      : super(key: key);

  final double barHeight;
  final double barWidth;
  final PageController pageController;

  @override
  _TabChipState createState() => _TabChipState();
}

class _TabChipState extends State<TabChip> {
  VoidCallback _pageListener = () {};
  double chipOffset = 0;

  @override
  void initState() {
    _pageListener = () {
      setState(() {
        chipOffset = widget.pageController.offset /
            widget.pageController.position.viewportDimension;
      });
    };
    widget.pageController.addListener(_pageListener);
    super.initState();
  }

  @override
  void dispose() {
    widget.pageController.removeListener(_pageListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CustomClipPath(
        barHeight: widget.barHeight,
        barWidth: widget.barWidth,
        chipOffset: chipOffset,
      ),
      child: TabForeground(
        height: widget.barHeight,
        width: widget.barWidth,
      ),
    );
  }
}
