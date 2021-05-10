import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class AnimatedCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final double sensitivity;
  AnimatedCard(
      {required this.child,
      this.width,
      this.height,
      this.onTap,
      this.sensitivity = 0.1});

  @override
  _AnimatedCardState createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with AfterLayoutMixin<AnimatedCard>, SingleTickerProviderStateMixin {
  GlobalKey _key = GlobalKey();

  Size size = Size(0, 0);

  late AnimationController _controller;
  late Animation<double> _rotateXAnimation;
  late Tween<double> _rotateXTween;
  late Animation<double> _rotateYAnimation;
  late Tween<double> _rotateYTween;

  late Animation<double> _scaleAnimation;
  late CurvedAnimation _curvedAnimation;
  AnimationStatusListener _statusListener = (_) {};

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
    _curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _controller.addListener(() {});

    _rotateXTween = Tween<double>(begin: 0, end: 0.5);
    _rotateXAnimation = _rotateXTween.animate(_curvedAnimation)
      ..addListener(() {
        setState(() {});
      });

    _rotateYTween = Tween<double>(begin: 0, end: 0.5);
    _rotateYAnimation = _rotateYTween.animate(_curvedAnimation);

    _scaleAnimation =
        Tween<double>(begin: 1, end: 0.95).animate(_curvedAnimation);

    super.initState();
  }

  double _degToRad(double deg) {
    return deg / 180 * pi;
  }

  void onTapDown(BuildContext context, TapDownDetails details) {
    // print('${details.globalPosition}');
    _controller.removeStatusListener(_statusListener);
    RenderBox box = context.findRenderObject() as RenderBox;

    final localOffset = box.globalToLocal(details.globalPosition);

    double wMultiple = 320 / size.width;
    double multiple = wMultiple * widget.sensitivity;
    double offsetX = 0.52 - localOffset.dx / size.width;
    double offsetY = 0.52 - localOffset.dy / size.height;

    double dy = localOffset.dy - (size.height / 2);
    double dx = localOffset.dx - (size.width / 2);

    double yRotate = (offsetX - dx) * multiple;
    double xRotate = (dy - offsetY) * multiple;

    _rotateXTween.end = _degToRad(xRotate);
    _rotateYTween.end = _degToRad(yRotate);
    _controller.forward();
  }

  void onTapUp(TapUpDetails _) {
    _statusListener = (status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    };
    if (_controller.isAnimating) {
      _controller.addStatusListener(_statusListener);
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _resetAnimation() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails detail) => onTapDown(context, detail),
      onTap: widget.onTap,
      onTapUp: onTapUp,
      onTapCancel: () => _resetAnimation(),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(_rotateXAnimation.value)
              ..rotateY(_rotateYAnimation.value)
              ..scale(_scaleAnimation.value),
            origin: Offset(size.width / 2, size.height / 2),
            child: child,
          );
        },
        child: Container(
          height: widget.height,
          width: widget.width,
          key: _key,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              const Radius.circular(20),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    size = renderBox.size;
  }
}
