import 'dart:async';

import 'package:flutter/material.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/presentation/widgets/primary_button.dart';
import 'package:redrotapp/presentation/widgets/secondary_button.dart';
import '../themes/app_theme.dart';

class DeleteOverlay extends ModalRoute<void> {
  final String cloneName;
  DeleteOverlay(this.cloneName);

  @override
  Color? get barrierColor => Colors.black87;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      child: DeleteCard(
        cloneName: cloneName,
      ),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final _curvedAnimation = animation.drive(CurveTween(curve: Curves.ease));
    final _scaleAnimation = Tween<double>(begin: 0.8, end: 1)
        .animate(CurvedAnimation(parent: animation, curve: Curves.ease));
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: _curvedAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: child,
      ),
    );
  }

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);
}

class DeleteCard extends StatefulWidget {
  const DeleteCard({Key? key, required this.cloneName}) : super(key: key);
  final String cloneName;
  @override
  _DeleteCardState createState() => _DeleteCardState();
}

class _DeleteCardState extends State<DeleteCard> with TickerProviderStateMixin {
  InputDecoration _inputDecoration(String hintText) {
    final theme = Theme.of(context);
    return InputDecoration(
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 0,
      ),
      focusColor: theme.colorScheme.secondary,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.colorScheme.secondary),
      ),
      hintText: hintText,
      hintStyle: theme.textTheme.bodyText2!.copyWith(
        color: theme.colorScheme.disableColor,
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.colorScheme.errorColor),
      ),
      errorStyle: theme.textTheme.bodyText2!.copyWith(
        color: theme.colorScheme.errorColor,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: theme.colorScheme.errorColor,
        ),
      ),
    );
  }

  late AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 1000),
  );
  late Tween<double> _translateYTween = Tween<double>(begin: 0, end: 0);
  late Animation<double> _translateYAnimation = _translateYTween
      .animate(CurvedAnimation(parent: _controller, curve: Curves.ease))
        ..addListener(() {
          setState(() {});
        });

  late AnimationController _inputAnimationController = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 500),
  );
  late Tween<double> _shakeTween = Tween<double>(begin: 0, end: 1);
  late Animation<double> _shakeAnimation = _shakeTween.animate(
      CurvedAnimation(parent: _inputAnimationController, curve: Curves.ease))
    ..addListener(() {
      setState(() {});
    });

  Timer? _timer;
  TextEditingController _inputController = TextEditingController();

  final Curve curve = Curves.bounceOut;
  double shake(double animation) =>
      2 * (0.5 - (0.5 - curve.transform(animation)).abs());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _inputController.dispose();
    _timer?.cancel();
    _inputAnimationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (!_controller.isAnimating) {
      _timer?.cancel();
      _timer = Timer(Duration(milliseconds: 100), () {
        final _keyboardInsets = MediaQuery.of(context).viewInsets.bottom;
        _translateYTween.begin = _translateYAnimation.value;
        if (_keyboardInsets == 0) {
          _translateYTween.end = 0;
        } else {
          _translateYTween.end = -_keyboardInsets / 2;
        }

        if (_translateYTween.begin != _translateYTween.end) {
          _controller.reset();
          _controller.forward();
        }
      });
    }

    return Transform.translate(
      offset: Offset(0, _translateYAnimation.value),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Container(
            padding: EdgeInsets.all(Sizes.dimen_24),
            width: double.infinity,
            decoration: BoxDecoration(
                color: theme.colorScheme.cardColor,
                borderRadius: const BorderRadius.all(
                  const Radius.circular(10),
                )),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  widget.cloneName,
                  style: theme.textTheme.headline5,
                ),
                Text(
                  'พิมพ์คำว่า "ตกลง" เพื่อลบข้อมูล',
                  style: theme.textTheme.bodyText2?.copyWith(
                    color: theme.colorScheme.secondaryTextColor,
                  ),
                ),
                SizedBox(
                  height: Sizes.dimen_8,
                ),
                Transform.translate(
                  offset: Offset(20 * shake(_shakeAnimation.value), 0),
                  child: TextField(
                    controller: _inputController,
                    autocorrect: false,
                    enableSuggestions: false,
                    cursorColor: theme.colorScheme.secondary,
                    style: theme.textTheme.bodyText1,
                    decoration: _inputDecoration("ตกลง"),
                  ),
                ),
                SizedBox(
                  height: Sizes.dimen_16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SecondaryButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      text: "ยกเลิก",
                    ),
                    SizedBox(
                      width: Sizes.dimen_8,
                    ),
                    PrimaryButton(
                      onPressed: () {
                        if (_inputController.text == "ตกลง") {
                          Navigator.of(context).pop(true);
                        } else {
                          _inputAnimationController.reset();
                          _inputAnimationController.forward();
                        }
                      },
                      text: 'ยืนยัน',
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShakeWidget extends StatelessWidget {
  final Duration duration;
  final double deltaX;
  final Widget child;
  final Curve curve;

  const ShakeWidget({
    Key? key,
    this.duration = const Duration(milliseconds: 500),
    this.deltaX = 20,
    this.curve = Curves.bounceOut,
    required this.child,
  }) : super(key: key);

  /// convert 0-1 to 0-1-0
  double shake(double animation) =>
      2 * (0.5 - (0.5 - curve.transform(animation)).abs());

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: key,
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      builder: (context, animation, child) => Transform.translate(
        offset: Offset(deltaX * shake(animation), 0),
        child: child,
      ),
      child: child,
    );
  }
}
