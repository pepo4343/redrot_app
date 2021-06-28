import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redrotapp/presentation/widgets/tap_detector.dart';
import 'package:rive/rive.dart';
import '../../themes/app_theme.dart';

enum ButtonState {
  Disable,
  Initial,
  Uploading,
  Success,
  Error,
}

class UploadButton extends StatefulWidget {
  final ButtonState buttonState;
  final VoidCallback onPressed;
  UploadButton({
    this.buttonState = ButtonState.Initial,
    required this.onPressed,
  });
  @override
  _UploadButtonState createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  Artboard? _riveArtboard;
  StateMachineController? _controller;
  SMIInput<bool>? _isUploading;
  SMIInput<bool>? _isSuccess;
  SMIInput<bool>? _isError;

  @override
  void initState() {
    rootBundle.load('assets/flares/upload.riv').then(
      (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        var controller =
            StateMachineController.fromArtboard(artboard, 'StateMachine');
        if (controller != null) {
          artboard.addController(controller);
          _isUploading = controller.findInput('isUploading');
          _isSuccess = controller.findInput('isSuccess');
          _isError = controller.findInput('isError');
        }

        setState(() => _riveArtboard = artboard);
      },
    );
    super.initState();
  }

  String get _text {
    if (widget.buttonState == ButtonState.Uploading) {
      return 'กำลังอัพโหลด';
    }
    if (widget.buttonState == ButtonState.Success) {
      return 'เสร็จสิ้น';
    }
    if (widget.buttonState == ButtonState.Error) {
      return 'ผิดพลาด';
    }
    return 'อัพโหลด';
  }

  Color get _color {
    if (widget.buttonState == ButtonState.Disable) {
      return Theme.of(context).colorScheme.disableColor;
    }
    if (widget.buttonState == ButtonState.Success) {
      return Theme.of(context).colorScheme.successColor;
    }
    if (widget.buttonState == ButtonState.Error) {
      return Theme.of(context).colorScheme.errorColor;
    }
    return Theme.of(context).colorScheme.secondary;
  }

  List<BoxShadow> get _boxShadows {
    if (widget.buttonState == ButtonState.Disable) {
      return [];
    }
    if (widget.buttonState == ButtonState.Success) {
      return Theme.of(context).sucesssBoxShadows;
    }
    if (widget.buttonState == ButtonState.Error) {
      return Theme.of(context).errorBoxShadows;
    }
    return Theme.of(context).secondaryBoxShadows;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (widget.buttonState == ButtonState.Disable) {
      _isError?.value = false;
      _isSuccess?.value = false;
      _isUploading?.value = false;
    }
    if (widget.buttonState == ButtonState.Initial) {
      _isError?.value = false;
      _isSuccess?.value = false;
      _isUploading?.value = false;
    }
    if (widget.buttonState == ButtonState.Uploading) {
      _isUploading?.value = true;
    }
    if (widget.buttonState == ButtonState.Success) {
      _isSuccess?.value = true;
    }
    if (widget.buttonState == ButtonState.Error) {
      _isError!.value = true;
    }
    return _riveArtboard != null
        ? TapDetector(
            onPressed: widget.onPressed,
            child: AnimatedContainer(
              padding: const EdgeInsets.only(left: 8),
              curve: Curves.ease,
              duration: Duration(milliseconds: 300),
              width: _textSize(_text, theme.textTheme.bodyText1!).width + 50,
              height: 40,
              decoration: BoxDecoration(
                color: _color,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                boxShadow: _boxShadows,
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 25,
                      height: 40,
                      child: Rive(
                        artboard: _riveArtboard!,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          var curve = Curves.ease;
                          var opacityTween = Tween<double>(begin: 0, end: 1)
                              .chain(CurveTween(curve: curve));
                          var slideTween = Tween<Offset>(
                                  begin: Offset(0.0, -1), end: Offset(0.0, 0.0))
                              .chain(CurveTween(curve: curve));
                          return FadeTransition(
                            opacity: opacityTween.animate(animation),
                            child: SlideTransition(
                              child: child,
                              position: slideTween.animate(animation),
                            ),
                          );
                        },
                        layoutBuilder: (currentChild, previousChildren) =>
                            currentChild!,
                        child: Text(
                          _text,
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          softWrap: false,
                          key: ValueKey<String>(_text),
                          style: theme.textTheme.bodyText1!
                              .copyWith(color: theme.colorScheme.onSecondary),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        : Container();
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
