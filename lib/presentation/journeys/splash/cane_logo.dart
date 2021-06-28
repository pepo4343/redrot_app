import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class CaneLogo extends StatefulWidget {
  const CaneLogo({Key? key}) : super(key: key);

  @override
  _CaneLogoState createState() => _CaneLogoState();
}

class _CaneLogoState extends State<CaneLogo> {
  Artboard? _riveArtboard;
  SMIInput<double>? _spread;
  SMIInput<double>? _node;
  SMIInput<double>? _color;

  double width = 250;
  double height = 250;
  @override
  void initState() {
    rootBundle.load('assets/flares/cane.riv').then(
      (data) async {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;

        setState(() {
          _riveArtboard = artboard
            ..addController(
              SimpleAnimation('start'),
            )
            ..addController(SimpleAnimation("leaf2_idle"))
            ..addController(SimpleAnimation("leaf1_idle"));
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        curve: Cubic(0.25, 1, 0.5, 1),
        width: width,
        height: height,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.onSecondary.withOpacity(0.2),
          borderRadius: BorderRadius.all(
            Radius.circular(
              300,
            ),
          ),
        ),
        child: Transform.rotate(
          angle: -pi / 4,
          child: _riveArtboard != null
              ? Rive(
                  artboard: _riveArtboard!,
                  fit: BoxFit.contain,
                )
              : SizedBox(),
        ),
      ),
    );
  }
}
