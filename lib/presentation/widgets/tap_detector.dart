import 'package:flutter/material.dart';

class TapDetector extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;

  TapDetector({
    required this.child,
    required this.onPressed,
  });
  @override
  _TapDetectorState createState() => _TapDetectorState();
}

class _TapDetectorState extends State<TapDetector>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 100),
  );
  late Animation<double> _scaleAnimation;
  AnimationStatusListener _statusListener = (AnimationStatus _) {};

  @override
  void initState() {
    _scaleAnimation = Tween<double>(begin: 1, end: 0.8).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    )..addListener(() {
        setState(() {});
      });

    super.initState();
  }

  void _onTapDownHandler(TapDownDetails _) {
    _controller.removeStatusListener(_statusListener);
    _controller.forward();
  }

  void _onTapUpHanler(TapUpDetails _) {
    _statusListener = (status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse().then((value) => widget.onPressed());
      }
    };
    if (_controller.isAnimating) {
      _controller.addStatusListener(_statusListener);
    } else {
      _controller.reverse().then((value) => widget.onPressed());
    }
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_statusListener);
    _controller.dispose();
    super.dispose();
  }

  void _onTapCancelHandler() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: _onTapUpHanler,
      onTapDown: _onTapDownHandler,
      onTapCancel: _onTapCancelHandler,
      behavior: HitTestBehavior.deferToChild,
      child: Transform.scale(
        scale: _scaleAnimation.value,
        child: widget.child,
      ),
    );
  }
}
