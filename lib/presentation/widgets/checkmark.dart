import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:rive/rive.dart';
import '../themes/app_theme.dart';

class CheckMark extends StatefulWidget {
  const CheckMark({
    Key? key,
    this.size = Sizes.dimen_24,
    this.color,
    this.opacity,
    this.isFill = true,
  }) : super(key: key);
  final double size;
  final Color? color;
  final double? opacity;
  final bool isFill;
  @override
  _CheckMarkState createState() => _CheckMarkState();
}

class _CheckMarkState extends State<CheckMark> {
  Artboard? _riveArtboard;
  @override
  void initState() {
    rootBundle.load('assets/flares/checkmark.riv').then(
      (data) async {
        final theme = Theme.of(context);
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        artboard.forEachComponent((child) {
          if (child.name == "Checkmark") {
            final Shape checkmark = child as Shape;

            checkmark.strokes.first.paint.strokeWidth = 6;
            checkmark.strokes.first.paint.color =
                widget.color ?? theme.colorScheme.successColor;
          }
          if (child.name == "CheckmarkBg") {
            final Shape bg = child as Shape;
            if (widget.isFill) {
              bg.fills.first.paint.color =
                  widget.color?.withOpacity(widget.opacity ?? 0.3) ??
                      theme.colorScheme.successColor
                          .withOpacity(widget.opacity ?? 0.3);
            } else {
              bg.fills.first.paint.color = Colors.transparent;
              bg.strokes.first.paint.strokeWidth = 6;
              bg.strokes.first.paint.color =
                  widget.color ?? theme.colorScheme.successColor;
            }
          }
        });
        setState(
          () => _riveArtboard = artboard
            ..addController(
              SimpleAnimation('Animation 1'),
            ),
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_riveArtboard == null) {
      return SizedBox();
    }
    return Container(
      width: widget.size,
      height: widget.size,
      child: Rive(
        artboard: _riveArtboard!,
        fit: BoxFit.fill,
      ),
    );
  }
}
