import 'package:flutter/material.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/presentation/widgets/checkmark.dart';
import 'package:redrotapp/presentation/widgets/loading_indicator.dart';
import 'package:redrotapp/presentation/widgets/tap_detector.dart';
import '../../themes/app_theme.dart';

enum ConfirmButtonState { Active, Disable, Fetching, Confirmed, Failure }

class ConfirmButton extends StatefulWidget {
  const ConfirmButton({
    Key? key,
    required this.state,
    required this.onPressed,
    this.prefix = "ยืนยัน",
  }) : super(key: key);
  final ConfirmButtonState state;
  final VoidCallback onPressed;
  final String prefix;
  @override
  _ConfirmButtonState createState() => _ConfirmButtonState();
}

class _ConfirmButtonState extends State<ConfirmButton> {
  final iconSize = Sizes.dimen_18;
  final paddingSize = Sizes.dimen_16;

  String get _buttonText {
    if (widget.state == ConfirmButtonState.Active) {
      return "${widget.prefix}";
    }
    if (widget.state == ConfirmButtonState.Confirmed) {
      return "${widget.prefix}เรียบร้อย";
    }
    if (widget.state == ConfirmButtonState.Disable) {
      return "${widget.prefix}";
    }
    if (widget.state == ConfirmButtonState.Fetching) {
      return "กำลังบันทึก";
    }
    if (widget.state == ConfirmButtonState.Failure) {
      return "ผิดพลาด";
    }
    return "";
  }

  Color get _buttonColor {
    final colorScheme = Theme.of(context).colorScheme;
    if (widget.state == ConfirmButtonState.Active) {
      return colorScheme.secondary;
    }
    if (widget.state == ConfirmButtonState.Confirmed) {
      return colorScheme.successColor;
    }
    if (widget.state == ConfirmButtonState.Disable) {
      return colorScheme.disableColor;
    }
    if (widget.state == ConfirmButtonState.Fetching) {
      return colorScheme.secondary;
    }
    if (widget.state == ConfirmButtonState.Failure) {
      return colorScheme.errorColor;
    }
    return Colors.transparent;
  }

  double get _containerWidth {
    final theme = Theme.of(context);

    final textWidth = _textSize(_buttonText, theme.textTheme.bodyText2!).width;

    if (widget.state == ConfirmButtonState.Active) {
      return 100;
    }
    if (widget.state == ConfirmButtonState.Confirmed) {
      return textWidth + iconSize + Sizes.dimen_12 + paddingSize * 2;
    }
    if (widget.state == ConfirmButtonState.Disable) {
      return 100;
    }
    if (widget.state == ConfirmButtonState.Fetching) {
      return textWidth + iconSize + Sizes.dimen_8 + paddingSize * 2;
    }

    if (widget.state == ConfirmButtonState.Failure) {
      return 100;
    }
    return 0;
  }

  List<BoxShadow> get _boxShadows {
    final theme = Theme.of(context);
    if (widget.state == ConfirmButtonState.Active) {
      return theme.secondaryBoxShadows;
    }
    if (widget.state == ConfirmButtonState.Confirmed) {
      return [];
    }
    if (widget.state == ConfirmButtonState.Disable) {
      return [];
    }
    if (widget.state == ConfirmButtonState.Fetching) {
      return theme.secondaryBoxShadows;
    }
    if (widget.state == ConfirmButtonState.Failure) {
      return theme.errorBoxShadows;
    }
    return [];
  }

  BoxDecoration get _buttonDecoration {
    final theme = Theme.of(context);
    if (widget.state == ConfirmButtonState.Confirmed) {
      return BoxDecoration(
        color: theme.colorScheme.background,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: theme.colorScheme.successColor),
        boxShadow: _boxShadows,
      );
    }
    return BoxDecoration(
      color: _buttonColor,
      borderRadius: BorderRadius.all(Radius.circular(5)),
      boxShadow: _boxShadows,
    );
  }

  Widget get _buttonTextWidget {
    final theme = Theme.of(context);
    if (widget.state == ConfirmButtonState.Confirmed) {
      return Text(
        _buttonText,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.clip,
        key: ValueKey<String>(_buttonText),
        style: theme.textTheme.bodyText2!.copyWith(color: _buttonColor),
      );
    }
    return Text(
      _buttonText,
      maxLines: 1,
      softWrap: false,
      overflow: TextOverflow.clip,
      key: ValueKey<String>(_buttonText),
      style: theme.textTheme.bodyText2!
          .copyWith(color: theme.colorScheme.onSecondary),
    );
  }

  Widget get _iconWidget {
    final theme = Theme.of(context);
    if (widget.state == ConfirmButtonState.Fetching) {
      return Container(
        key: ValueKey("loadingIcon"),
        margin: const EdgeInsets.only(right: Sizes.dimen_8),
        child: LoadingIndicator(
          color: theme.colorScheme.onSecondary,
          width: iconSize,
        ),
      );
    }
    if (widget.state == ConfirmButtonState.Confirmed) {
      return Container(
        key: ValueKey("checkmarkIcon"),
        margin: const EdgeInsets.only(right: Sizes.dimen_8),
        child: CheckMark(
          size: iconSize,
        ),
      );
    }
    return Container(
      key: ValueKey("noIcon"),
    );
  }

  double get _buttonTextWidth {
    return _textSize(_buttonText, Theme.of(context).textTheme.bodyText2!).width;
  }

  EdgeInsetsGeometry get _padding {
    if (widget.state == ConfirmButtonState.Active ||
        widget.state == ConfirmButtonState.Disable ||
        widget.state == ConfirmButtonState.Failure) {
      return EdgeInsets.symmetric(horizontal: (100 - _buttonTextWidth) / 2);
    }
    return EdgeInsets.symmetric(horizontal: paddingSize);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TapDetector(
      onPressed: widget.onPressed,
      child: AnimatedContainer(
        curve: Curves.ease,
        duration: Duration(milliseconds: 300),
        width: _containerWidth,
        height: 30,
        decoration: _buttonDecoration,
        padding: _padding,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 1000),
              transitionBuilder: (Widget child, Animation<double> animation) {
                var curve = Curves.ease;
                var opacityTween = Tween<double>(begin: 0, end: 1)
                    .chain(CurveTween(curve: curve));
                return FadeTransition(
                  opacity: opacityTween.animate(animation),
                  child: child,
                );
              },
              layoutBuilder: (currentChild, previousChildren) => currentChild!,
              child: _iconWidget,
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  var curve = Curves.easeOut;
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
                child: _buttonTextWidget,
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
