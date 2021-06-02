import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/presentation/widgets/tap_detector.dart';

import '../../themes/app_theme.dart';

class FloatingActionButtonItem {
  final String label;
  final String svg;
  final VoidCallback onPressed;
  FloatingActionButtonItem({
    required this.label,
    required this.svg,
    required this.onPressed,
  });
}

class MultipleItemsFloatingActionButton extends StatefulWidget {
  final List<FloatingActionButtonItem> items;
  MultipleItemsFloatingActionButton({
    required this.items,
  });
  @override
  _MultipleItemsFloatingActionButtonState createState() =>
      _MultipleItemsFloatingActionButtonState();
}

class _MultipleItemsFloatingActionButtonState
    extends State<MultipleItemsFloatingActionButton>
    with SingleTickerProviderStateMixin {
  static const double defaultSize = Sizes.dimen_60;
  static const double openWidth = Sizes.dimen_150;
  static const double openHeight = Sizes.dimen_140;

  late AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 100),
  );
  late Animation<Size> _sizeAnimation;
  late Tween<Size> _sizeTween;
  late Animation<double> _radiusAnimation;
  late Animation<double> _rotateAnimation;
  bool shouldForward = true;
  bool isOpened = false;

  double get maxTextWidth {
    return widget.items.fold<double>(0, (previousValue, element) {
      final textWidth =
          _textSize(element.label, Theme.of(context).textTheme.bodyText1!)
              .width;
      return textWidth > previousValue ? textWidth : previousValue;
    });
  }

  double get maxTextHeight {
    return widget.items.fold<double>(0, (previousValue, element) {
      final textHeight =
          _textSize(element.label, Theme.of(context).textTheme.bodyText1!)
              .height;
      return textHeight > previousValue ? textHeight : previousValue;
    });
  }

  @override
  void initState() {
    _sizeTween = Tween<Size>(
      begin: Size(defaultSize, defaultSize),
      end: Size(defaultSize, defaultSize),
    );
    _sizeAnimation = _sizeTween.animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    )..addListener(() async {
        if (_controller.value == 1) {
          await Future.delayed(Duration(milliseconds: 200));
          if (_controller.value == 1) {
            setState(() {
              isOpened = true;
            });
          }
        } else {
          setState(() {
            isOpened = false;
          });
        }
      });

    _radiusAnimation = Tween<double>(
      begin: defaultSize / 2,
      end: Sizes.dimen_8,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.ease,
    ));

    _rotateAnimation = Tween<double>(
      begin: 0,
      end: pi * 3 / 4,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onPressed() {
    if (shouldForward) {
      _sizeTween.end = Size(
        maxTextWidth + Sizes.dimen_68,
        widget.items.length * 50 + 40,
      );
      _controller.reset();
      _controller.forward();
    } else {
      _controller.reverse();
    }
    shouldForward = !shouldForward;
  }

  List<Widget> _buildSubItems() {
    List<Widget> subMenu = [];
    for (var i = 0; i < widget.items.length; i++) {
      final item = widget.items[i];
      subMenu.add(SubItem(
          onPressed: () {
            shouldForward = true;
            _controller.reverse();
            item.onPressed();
          },
          svg: item.svg,
          text: item.label,
          delay: Duration(milliseconds: 200 * i)));
      subMenu.add(AnimatedDivider(
          width: maxTextWidth + Sizes.dimen_32,
          delay: Duration(milliseconds: 200 * i + 100)));
    }
    return subMenu;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Hero(
      tag: "FAB",
      child: AnimatedContainer(
        curve: Curves.ease,
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondary,
          borderRadius: BorderRadius.all(
            Radius.circular(_radiusAnimation.value),
          ),
          boxShadow: theme.secondaryBoxShadows,
        ),
        width: _sizeAnimation.value.width,
        height: _sizeAnimation.value.height,
        child: Stack(
          children: [
            if (isOpened)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: _buildSubItems(),
                ),
              ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: TapDetector(
                  onPressed: _onPressed,
                  child: Transform.rotate(
                    angle: _rotateAnimation.value,
                    child: Icon(
                      Icons.add,
                      color: theme.colorScheme.onSecondary,
                      size: Sizes.dimen_24,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
}

class AnimatedDivider extends StatefulWidget {
  final double width;
  final Duration delay;
  const AnimatedDivider({
    Key? key,
    required this.width,
    required this.delay,
  }) : super(key: key);

  @override
  _AnimatedDividerState createState() => _AnimatedDividerState();
}

class _AnimatedDividerState extends State<AnimatedDivider> {
  bool _animate = false;

  Stream<bool> animationStream() async* {
    yield false;
    await Future.delayed(widget.delay);
    yield true;
  }

  late StreamSubscription<bool> _streamSubscription;

  @override
  void initState() {
    final _stream = animationStream();
    _streamSubscription = _stream.listen((shouldAnimate) {
      if (shouldAnimate) {
        setState(() {
          _animate = true;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      width: _animate ? widget.width : 0,
      child: Divider(
        color: Theme.of(context).colorScheme.onSecondary,
      ),
    );
  }
}

class SubItem extends StatefulWidget {
  final String svg;
  final String text;
  final Duration delay;
  final VoidCallback onPressed;
  const SubItem(
      {Key? key,
      required this.svg,
      required this.text,
      required this.delay,
      required this.onPressed})
      : super(key: key);

  @override
  _SubItemState createState() => _SubItemState();
}

class _SubItemState extends State<SubItem> with SingleTickerProviderStateMixin {
  Stream<bool> animationStream() async* {
    yield false;
    await Future.delayed(widget.delay);
    yield true;
  }

  late AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 500),
  );

  late Stream<bool> _stream;
  late StreamSubscription<bool> _streamSubscription;

  late Animation<Offset> _transitionAnimation;

  @override
  void initState() {
    _transitionAnimation = Tween<Offset>(
      begin: Offset(0, 30),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    )..addListener(() {
        setState(() {});
      });

    _stream = animationStream();
    _streamSubscription = _stream.listen((shouldAnimate) {
      if (shouldAnimate) {
        _controller.forward();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TapDetector(
      onPressed: widget.onPressed,
      child: ClipRect(
        child: Transform.translate(
          offset: _transitionAnimation.value,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                widget.svg,
                width: Sizes.dimen_24,
              ),
              SizedBox(
                width: Sizes.dimen_8,
              ),
              Expanded(
                child: Text(
                  widget.text,
                  style: theme.textTheme.bodyText1?.copyWith(
                    color: theme.colorScheme.onSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
