import 'package:flutter/material.dart';
import 'package:redrotapp/presentation/logic/cubit/image_uploader/image_uploader_cubit.dart';
import '../../../themes/app_theme.dart';

class IntermidiateLoadingIndicator extends StatelessWidget {
  const IntermidiateLoadingIndicator({
    Key? key,
    required this.uploadState,
  }) : super(key: key);

  final ImageUploaderState uploadState;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 600),
          curve: Curves.ease,
          width: (uploadState is ImageUploaderUploading)
              ? constraints.maxWidth
              : 0,
          decoration: BoxDecoration(
            color: theme.colorScheme.whisperColor,
          ),
        );
      },
    );
  }
}

class ForegroundLoadingIndicator extends StatefulWidget {
  const ForegroundLoadingIndicator({
    Key? key,
    required this.uploadState,
  }) : super(key: key);

  final ImageUploaderState uploadState;

  @override
  _ForegroundLoadingIndicatorState createState() =>
      _ForegroundLoadingIndicatorState();
}

class _ForegroundLoadingIndicatorState
    extends State<ForegroundLoadingIndicator> {
  Color get _color {
    final theme = Theme.of(context);
    if (widget.uploadState is ImageUploaderFailure) {
      return theme.colorScheme.errorColor;
    }
    if (widget.uploadState is ImageUploaderSuccess) {
      return theme.colorScheme.successColor;
    }
    return theme.colorScheme.secondary;
  }

  double get _progress {
    double loadingProgress = 0;
    if (widget.uploadState is ImageUploaderUploading) {
      loadingProgress =
          (widget.uploadState as ImageUploaderUploading).finishedImages /
              (widget.uploadState as ImageUploaderUploading).totalImages;
    }
    if (widget.uploadState is ImageUploaderSuccess) {
      loadingProgress = 1;
    }
    if (widget.uploadState is ImageUploaderFailure) {
      loadingProgress = 1;
    }
    return loadingProgress;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 600),
          curve: Curves.ease,
          width: _progress * constraints.maxWidth,
          decoration: BoxDecoration(
            color: _color,
          ),
        );
      },
    );
  }
}

class BackgroundLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration:
          BoxDecoration(color: theme.colorScheme.secondary.withOpacity(0.4)),
    );
  }
}
