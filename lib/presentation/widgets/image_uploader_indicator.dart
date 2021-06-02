import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/presentation/logic/cubit/image_uploader/image_uploader_cubit.dart';
import 'package:rive/rive.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../themes/app_theme.dart';

class ImageUploaderIndicator extends StatefulWidget {
  @override
  _ImageUploaderIndicatorState createState() => _ImageUploaderIndicatorState();
}

class _ImageUploaderIndicatorState extends State<ImageUploaderIndicator> {
  Artboard? _riveArtboard;
  StateMachineController? _controller;
  SMIInput<bool>? _isSuccess;
  SMIInput<bool>? _isError;
  SMIInput<bool>? _isStart;
  bool _isShowProgress = true;
  Timer? _timer;
  @override
  void initState() {
    rootBundle.load('assets/flares/imageuploadicon.riv').then(
      (data) async {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        final theme = Theme.of(context);
        artboard.forEachComponent((child) {
          if (child.name == 'ArrowHead' || child.name == 'ArrowTail') {
            final Shape arrow = child as Shape;
            arrow.strokes.first.paint.color = theme.colorScheme.secondary;
          }
          if (child.name == 'Cloud1' ||
              child.name == 'Cloud2' ||
              child.name == 'Cloud3') {
            final Shape cloud = child as Shape;
            cloud.fills.first.paint.color =
                theme.colorScheme.secondary.withOpacity(0.3);
          }
        });
        var controller =
            StateMachineController.fromArtboard(artboard, 'StateMachine2');
        if (controller != null) {
          artboard.addController(controller);
          _isSuccess = controller.findInput('isSuccess');
          _isError = controller.findInput('isError');
          _isStart = controller.findInput('isStart');
        }

        _resetSMState();
        setState(() => _riveArtboard = artboard);
      },
    );

    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        _isShowProgress = !_isShowProgress;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _resetSMState() {
    _isError?.value = false;
    _isSuccess?.value = false;
    _isStart?.value = false;
  }

  Text _buildText(ImageUploaderState uploaderState, ThemeData theme) {
    final imageUploadState = uploaderState;
    if (imageUploadState is ImageUploaderUploading) {
      final totalImages = imageUploadState.totalImages;
      final finishedImages = imageUploadState.finishedImages;
      final clone = imageUploadState.clone;
      if (_isShowProgress) {
        return Text(
          "$finishedImages/$totalImages",
          textAlign: TextAlign.end,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          key: ValueKey("progress"),
          style: theme.textTheme.bodyText2!
              .copyWith(color: theme.colorScheme.secondary),
        );
      }
      return Text(
        "${clone!.cloneName}",
        textAlign: TextAlign.end,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        key: ValueKey("name"),
        style: theme.textTheme.bodyText2!
            .copyWith(color: theme.colorScheme.secondary),
      );
    }
    if (imageUploadState is ImageUploaderSuccess) {
      final clone = imageUploadState.clone;
      return Text(
        "${clone!.cloneName}",
        textAlign: TextAlign.end,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        key: ValueKey("success"),
        style: theme.textTheme.bodyText2!
            .copyWith(color: theme.colorScheme.successColor),
      );
    }
    if (imageUploadState is ImageUploaderFailure) {
      final clone = imageUploadState.clone;
      return Text(
        "${clone!.cloneName}",
        textAlign: TextAlign.end,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        key: ValueKey("error"),
        style: theme.textTheme.bodyText2!
            .copyWith(color: theme.colorScheme.errorColor),
      );
    }
    return Text(
      "",
      key: ValueKey("empty"),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final imageUploadState = context.watch<ImageUploaderCubit>().state;
    if (imageUploadState is ImageUploaderInitial) {
      _resetSMState();
      return Container();
    }
    if (imageUploadState is ImageUploaderReady) {
      _resetSMState();
    }
    if (imageUploadState is ImageUploaderEmpty) {
      _resetSMState();
    }
    if (imageUploadState is ImageUploaderUploading) {
      _isStart?.value = true;
    }
    if (imageUploadState is ImageUploaderSuccess) {
      _riveArtboard?.forEachComponent((child) {
        if (child.name == 'Check') {
          final Shape check = child as Shape;
          check.strokes.first.paint.color = theme.colorScheme.successColor;
        }
        if (child.name == 'IconBackgroud') {
          final Shape iconBackground = child as Shape;
          iconBackground.fills.first.paint.color =
              theme.colorScheme.successColor.withOpacity(0.3);
        }
      });
      _isSuccess?.value = true;
    }
    if (imageUploadState is ImageUploaderFailure) {
      _isError?.value = true;
      _riveArtboard?.forEachComponent((child) {
        if (child.name == 'Cross1' || child.name == 'Cross2') {
          final Shape check = child as Shape;
          check.strokes.first.paint.color = theme.colorScheme.errorColor;
        }
        if (child.name == 'IconBackgroud') {
          final Shape iconBackground = child as Shape;
          iconBackground.fills.first.paint.color =
              theme.colorScheme.errorColor.withOpacity(0.3);
        }
      });
    }
    return Container(
      child: Row(
        children: [
          Container(
            width: 50,
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 1000),
              transitionBuilder: (Widget child, Animation<double> animation) {
                var curve = Curves.ease;
                var opacityTween = Tween<double>(begin: 0, end: 1)
                    .chain(CurveTween(curve: curve));
                var slideTween =
                    Tween<Offset>(begin: Offset(0.0, -1), end: Offset(0.0, 0.0))
                        .chain(CurveTween(curve: curve));
                return FadeTransition(
                  opacity: opacityTween.animate(animation),
                  child: SlideTransition(
                    child: child,
                    position: slideTween.animate(animation),
                  ),
                );
              },
              layoutBuilder: (currentChild, previousChildren) => currentChild!,
              child: _buildText(imageUploadState, theme),
            ),
          ),
          Container(
            width: 25,
            height: 40,
            child: _riveArtboard != null
                ? Rive(
                    artboard: _riveArtboard!,
                    fit: BoxFit.contain,
                  )
                : null,
          ),
          SizedBox(
            width: Sizes.dimen_8,
          ),
        ],
      ),
    );
  }
}
