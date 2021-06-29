import 'package:flutter/material.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';
import '../../../../themes/app_theme.dart';

class CompletedBody extends StatefulWidget {
  final CloneEntity cloneEntity;

  CompletedBody({required this.cloneEntity});

  @override
  _CompletedBodyState createState() => _CompletedBodyState();
}

class _CompletedBodyState extends State<CompletedBody>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1800),
    vsync: this,
  )..forward();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedResult(
        cloneEntity: widget.cloneEntity, controller: _controller);
  }
}

class AnimatedResult extends AnimatedWidget {
  final CloneEntity cloneEntity;
  final AnimationController controller;

  // final double textWidth = 130.w;

  Animation<double> get _animation => listenable as Animation<double>;

  AnimatedResult({required this.cloneEntity, required this.controller})
      : super(listenable: controller);

  Color _getTextColor(ThemeData theme) {
    switch (cloneEntity.categoryEntity!.category) {
      case 0:
        return theme.colorScheme.successColor;
      case 1:
        return theme.colorScheme.warningColor;
      default:
        return theme.colorScheme.errorColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final categoryTextTheme = theme.textTheme.headline3!.copyWith(
      height: 1.15,
      color: _getTextColor(theme),
      fontWeight: FontWeight.w300,
    );

    final categoryText = cloneEntity.categoryEntity!.categoryText;

    final scoreTextTheme = theme.textTheme.headline3!.copyWith(
      height: 1.15,
      fontWeight: FontWeight.w200,
      color: theme.colorScheme.secondaryTextColor,
    );

    final scoreText = cloneEntity.categoryEntity!.scoreAvg.toStringAsFixed(1);

    final _scaleScore = Tween<double>(
      begin: 1.3,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animation,
        curve: Interval(0.3, 0.8, curve: Curves.ease),
      ),
    );

    final _offsetText = Tween<Offset>(
      begin: Offset(-_textSize(scoreText, scoreTextTheme).width / 2, 0),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _animation,
        curve: Interval(0.3, 0.8, curve: Curves.ease),
      ),
    );

    final _opacityText = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _animation,
        curve: Interval(0.3, 0.8, curve: Curves.ease),
      ),
    );

    final widthText = Tween<double>(
      begin: 0,
      end: _textSize(categoryText, categoryTextTheme).width,
    ).animate(
      CurvedAnimation(
        parent: _animation,
        curve: Interval(0.3, 0.8, curve: Curves.ease),
      ),
    );

    final heightDivider = Tween<double>(
      begin: 0,
      end: 30,
    ).animate(
      CurvedAnimation(
        parent: _animation,
        curve: Interval(0.7, 1, curve: Curves.ease),
      ),
    );

    // TODO: implement build
    return Container(
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.scale(
            scale: _scaleScore.value,
            child: Container(
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  scoreText,
                  style: scoreTextTheme,
                ),
              ),
            ),
          ),
          Container(
            height: heightDivider.value,
            width: 1,
            color: Theme.of(context).colorScheme.textColor,
            margin: const EdgeInsets.symmetric(horizontal: Sizes.dimen_8),
          ),
          Transform.translate(
            offset: _offsetText.value,
            child: Opacity(
              opacity: _opacityText.value,
              child: Container(
                width: widthText.value,
                child: Text(
                  categoryText,
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                  softWrap: false,
                  style: categoryTextTheme,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
}
