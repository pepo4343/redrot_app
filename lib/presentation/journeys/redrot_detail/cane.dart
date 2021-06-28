import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class Cane extends StatefulWidget {
  const Cane({
    Key? key,
    required this.spread,
    required this.node,
    required this.color,
    this.isShowCase = true,
  }) : super(key: key);
  final double spread;
  final double node;
  final double color;
  final bool isShowCase;
  @override
  _CaneState createState() => _CaneState();
}

class _CaneState extends State<Cane> with SingleTickerProviderStateMixin {
  late AnimationController _controller = AnimationController(
    vsync: this, // the SingleTickerProviderStateMixin
    duration: Duration(milliseconds: 600),
  );

  late Animation<double> _spreadAnimation;
  late Tween<double> _spreadTween;
  Artboard? _riveArtboard;
  SMIInput<double>? _spread;
  SMIInput<double>? _node;
  SMIInput<double>? _color;
  Timer? _timer;

  bool shouldAnimate = false;

  @override
  void initState() {
    rootBundle.load('assets/flares/cane.riv').then(
      (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        var controller =
            StateMachineController.fromArtboard(artboard, 'State Machine 1');

        if (controller != null) {
          artboard.addController(controller);

          _spread = controller.findInput('Spread');
          _node = controller.findInput('Node');
          _color = controller.findInput('Color');
        }

        // _spread?.value = 20;
        _node?.value = widget.node;
        _color?.value = widget.color;
        _spread?.value = 0;
        _spreadTween = Tween<double>(
          begin: 0,
          end: widget.spread,
        );
        _spreadAnimation = _spreadTween.animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.ease,
          ),
        )..addListener(() {
            _spread?.value = _spreadAnimation.value;
          });

        _timer = Timer(Duration(milliseconds: 1400), () {
          setState(() {
            shouldAnimate = true;
          });
        });

        setState(() {
          _riveArtboard = artboard;
        });
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_riveArtboard == null) {
      return Container();
    }

    if (shouldAnimate) {
      _spreadTween.begin = _spreadAnimation.value;
      _spreadTween.end = widget.spread;
      _node?.value = widget.node;
      _color?.value = widget.color;
      _controller.reset();
      _controller.forward();
    }

    return Container(
      width: 200,
      height: 100,
      child: Rive(
        artboard: _riveArtboard!,
        fit: BoxFit.contain,
      ),
    );
  }
}
