import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/common/enum.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';
import 'package:redrotapp/presentation/journeys/clone_detail/fab_add_redrot.dart';
import 'package:redrotapp/presentation/journeys/images_upload/upload_button.dart';
import 'package:redrotapp/presentation/logic/cubit/image_uploader/image_uploader_cubit.dart';
import 'package:redrotapp/presentation/widgets/checkmark.dart';
import 'package:redrotapp/presentation/widgets/loading_indicator.dart';

import 'package:redrotapp/presentation/widgets/redrot_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redrotapp/presentation/widgets/tap_detector.dart';

import '../../themes/app_theme.dart';
import 'clone_detail/clone_detail.dart';

class ImagesUploadScreen extends StatefulWidget {
  @override
  _ImagesUploadScreenState createState() => _ImagesUploadScreenState();
}

class _ImagesUploadScreenState extends State<ImagesUploadScreen> {
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uploadState = context.watch<ImageUploaderCubit>().state;
    final redrotImages = uploadState.redrotImages;

    if (uploadState is ImageUploaderInitial) {
      return Container();
    }

    return Scaffold(
      appBar: RedrotAppBar(
        title: "อัปโหลดรูปภาพ",
      ),
      body: // With predefined options
          Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CloneDetail(
              uploadState: uploadState,
            ),
            SizedBox(
              height: Sizes.dimen_8,
            ),
            Expanded(
                child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              layoutBuilder: (currentChild, previousChildren) => currentChild!,
              child: uploadState is ImageUploaderEmpty
                  ? Center(
                      child: Text(
                        "โปรดเพิ่มรูปภาพ",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    )
                  : _ImageUploaderGrid(
                      redrotImages: redrotImages,
                      uploaderState: uploadState,
                    ),
            )),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: (uploadState is ImageUploaderReady ||
              uploadState is ImageUploaderEmpty)
          ? _AddImageFloatingActionButton()
          : null,
    );
  }
}

class _ImageUploaderGrid extends StatelessWidget {
  _ImageUploaderGrid({
    Key? key,
    required this.redrotImages,
    required this.uploaderState,
  }) : super(key: key);

  final List<RedrotImage> redrotImages;
  final ImageUploaderState uploaderState;
  final options = LiveOptions(
    showItemInterval: Duration(milliseconds: 100),
    showItemDuration: Duration(milliseconds: 600),
    visibleFraction: 0.05,
    reAnimateOnVisibility: false,
  );
  @override
  Widget build(BuildContext context) {
    return LiveGrid.options(
      key: ValueKey("Grid"),
      options: options,
      physics: const BouncingScrollPhysics(
        parent: const AlwaysScrollableScrollPhysics(),
      ),
      itemBuilder: (context, index, animation) {
        return buildAnimatedItem(
          context,
          index,
          animation,
          redrotImages[index],
        );
      },
      itemCount: redrotImages.length,
      padding: const EdgeInsets.only(top: 10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 5 / 3,
      ),
    );
  }

// Build animated item (helper for all examples)
  Widget buildAnimatedItem(BuildContext context, int index,
          Animation<double> animation, RedrotImage redrotImage) =>
      FadeTransition(
        opacity: Tween<double>(
          begin: 0,
          end: 1,
        ).chain(CurveTween(curve: Curves.ease)).animate(animation),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, -0.1),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.ease)).animate(animation),
          // Paste you Widget
          child: _RedrotImagePreview(
            redrotImage: redrotImage,
            index: index,
            uploaderState: uploaderState,
          ),
        ),
      );
}

class _AddImageFloatingActionButton extends StatelessWidget {
  const _AddImageFloatingActionButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultipleItemsFloatingActionButton(
      items: [
        FloatingActionButtonItem(
            label: "คลังรูปภาพ",
            svg: "assets/svgs/image_gallery.svg",
            onPressed: () async {
              List<Media>? res = await ImagesPicker.pick(
                count: 10,
                pickType: PickType.image,
              );
              if (res != null) {
                context.read<ImageUploaderCubit>().add(res);
              }
            }),
        FloatingActionButtonItem(
            label: "กล้องถ่ายรูป",
            svg: "assets/svgs/camera.svg",
            onPressed: () async {
              final res = await ImagesPicker.openCamera(
                pickType: PickType.image,
              );
              if (res != null) {
                context.read<ImageUploaderCubit>().add(res);
              }
            }),
      ],
    );
  }
}

class _RedrotImagePreview extends StatefulWidget {
  const _RedrotImagePreview(
      {Key? key,
      required this.redrotImage,
      required this.index,
      required this.uploaderState})
      : super(key: key);

  final RedrotImage redrotImage;
  final ImageUploaderState uploaderState;
  final int index;

  @override
  _RedrotImagePreviewState createState() => _RedrotImagePreviewState();
}

class _RedrotImagePreviewState extends State<_RedrotImagePreview>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  Widget get _overlay {
    final theme = Theme.of(context);
    if (widget.redrotImage.status == ImageUploadStatus.Uploading) {
      return Center(
        key: ValueKey<int>(0),
        child: LoadingIndicator(
          width: Sizes.dimen_48,
          height: Sizes.dimen_48,
        ),
      );
    }
    if (widget.redrotImage.status == ImageUploadStatus.Waiting) {
      return Container();
    }
    if (widget.redrotImage.status == ImageUploadStatus.Success) {
      return Center(
        key: ValueKey<int>(2),
        child: CheckMark(
          size: Sizes.dimen_48,
          isFill: false,
        ),
      );
    }

    if (widget.redrotImage.status == ImageUploadStatus.Failure) {
      return Center(
        key: ValueKey<int>(2),
        child: Icon(
          Icons.close_rounded,
          size: Sizes.dimen_48,
          color: theme.colorScheme.errorColor,
        ),
      );
    }

    return Container();
  }

  bool get _isRemoveable {
    if (widget.uploaderState is ImageUploaderUploading) {
      return false;
    }
    if (widget.redrotImage.status == ImageUploadStatus.Failure) {
      return true;
    }
    if (widget.redrotImage.status == ImageUploadStatus.Initial) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 1.4).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    )..addListener(() async {
        setState(() {});
      });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.redrotImage.status == ImageUploadStatus.Uploading) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    return TapDetector(
      onPressed: () {
        if (widget.uploaderState is ImageUploaderReady) {
          Navigator.of(context).pushNamed(
            '/photoview',
            arguments: widget.index,
          );
        }
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          const Radius.circular(8),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Transform.scale(
              scale: _scaleAnimation.value,
              child: Hero(
                tag: widget.index,
                child: Image.file(
                  File(widget.redrotImage.path),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              color: widget.redrotImage.status == ImageUploadStatus.Initial
                  ? Colors.transparent
                  : Colors.black54,
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  var curve = Curves.ease;
                  var opacityTween = Tween<double>(begin: 0, end: 1)
                      .chain(CurveTween(curve: curve));
                  var scaleTween = Tween<double>(begin: 1.5, end: 1)
                      .chain(CurveTween(curve: curve));
                  return FadeTransition(
                    opacity: opacityTween.animate(animation),
                    child: ScaleTransition(
                      child: child,
                      scale: scaleTween.animate(animation),
                    ),
                  );
                },
                child: _overlay,
                layoutBuilder: (currentChild, previousChildren) =>
                    currentChild!,
              ),
            ),
            if (_isRemoveable)
              Align(
                alignment: Alignment.topRight,
                child: TapDetector(
                  onPressed: () =>
                      context.read<ImageUploaderCubit>().remove(widget.index),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(Sizes.dimen_4),
                    margin: const EdgeInsets.all(Sizes.dimen_4),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
