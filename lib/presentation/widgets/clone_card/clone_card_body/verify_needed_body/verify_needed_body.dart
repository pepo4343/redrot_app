import 'package:flutter/material.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/common/functions.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';

import 'percentage_text.dart';
import 'progress_bar.dart';

class VerifyNeededBody extends StatefulWidget {
  final List<RedrotEntity> redrots;
  final bool animation;
  VerifyNeededBody({
    required this.redrots,
    required this.animation,
  });

  @override
  _VerifyNeededBodyState createState() => _VerifyNeededBodyState();
}

class _VerifyNeededBodyState extends State<VerifyNeededBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  );
  Animation<double>? _progressAnimation;
  double percentage = 0;
  void _animationListener() {
    setState(() {
      percentage = ((_progressAnimation?.value ?? 0) * 100);
    });
  }

  @override
  void didChangeDependencies() {
    _controller.reset();
    _progressAnimation?.removeListener(_animationListener);

    _progressAnimation =
        Tween<double>(begin: 0, end: numCompleted / numAll).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.5,
          1,
          curve: Curves.ease,
        ),
      ),
    )..addListener(_animationListener);

    _controller.forward();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int get numCompleted => getCompletedNum(widget.redrots);
  int get numAll => widget.redrots.length;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            child: ProgressBar(
              all: numAll,
              completed: numCompleted,
              progress: _progressAnimation?.value ?? 0,
            ),
          ),
        ),
        const SizedBox(
          width: Sizes.dimen_8,
        ),
        PercentageText(
          percentage: percentage.toStringAsFixed(0),
        )
      ],
    );
    ;
  }
}
