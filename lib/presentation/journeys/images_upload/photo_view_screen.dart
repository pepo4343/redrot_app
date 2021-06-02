import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/main.dart';
import 'package:redrotapp/presentation/logic/cubit/image_uploader/image_uploader_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redrotapp/presentation/themes/app_colors.dart';
import 'package:redrotapp/presentation/themes/app_theme.dart';
import 'package:redrotapp/presentation/widgets/app_fab.dart';
import 'package:redrotapp/presentation/widgets/redrot_app_bar.dart';
import 'package:redrotapp/presentation/widgets/redrot_dark_app_bar.dart';
import 'package:redrotapp/presentation/widgets/tap_detector.dart';

class PhotoViewScreen extends StatefulWidget {
  PhotoViewScreen({
    required this.initialIndex,
  }) : pageController = PageController(initialPage: initialIndex);
  final int initialIndex;
  final PageController pageController;

  @override
  _PhotoViewScreenState createState() => _PhotoViewScreenState();
}

class _PhotoViewScreenState extends State<PhotoViewScreen> {
  late int currentIndex = widget.initialIndex;

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<ImageUploaderCubit, ImageUploaderState>(
      listener: (context, state) {
        if (state is ImageUploaderEmpty) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: RedrotDarkAppBar(
          title: "อัพโหลดรูปภาพ",
        ),
        backgroundColor: AppDarkColors().backgroundColor,
        floatingActionButton: Builder(builder: (context) {
          final redrotImages =
              context.watch<ImageUploaderCubit>().state.redrotImages;
          return TapDetector(
            onPressed: () {
              if (currentIndex == redrotImages.length - 1 &&
                  currentIndex != 0) {
                setState(() {
                  currentIndex = currentIndex - 1;
                });
              }
              context.read<ImageUploaderCubit>().remove(currentIndex);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.all(
                  Radius.circular(AppFab.buttonSize),
                ),
              ),
              width: AppFab.buttonSize,
              height: AppFab.buttonSize,
              child: Icon(
                Icons.delete,
                color: theme.colorScheme.onSecondary,
                size: Sizes.dimen_24,
              ),
            ),
          );
        }),
        body: Builder(
          builder: (context) {
            final uploadState = context.watch<ImageUploaderCubit>().state;

            if (uploadState is ImageUploaderReady) {
              final redrotImages = uploadState.redrotImages;

              return Column(
                children: [
                  Expanded(
                    child: Container(
                      child: PhotoViewGallery.builder(
                        scrollPhysics: const BouncingScrollPhysics(),
                        builder: (BuildContext context, int index) {
                          return PhotoViewGalleryPageOptions(
                            imageProvider:
                                FileImage(File(redrotImages[index].path)),
                            initialScale:
                                PhotoViewComputedScale.contained * 0.8,
                            minScale: PhotoViewComputedScale.contained *
                                (0.5 + index / 10),
                            maxScale: PhotoViewComputedScale.covered * 4.1,
                            heroAttributes: PhotoViewHeroAttributes(tag: index),
                          );
                        },
                        backgroundDecoration: BoxDecoration(
                            color: AppDarkColors().backgroundColor),
                        pageController: widget.pageController,
                        itemCount: redrotImages.length,
                        onPageChanged: onPageChanged,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${currentIndex + 1}/${redrotImages.length}",
                      style: theme.textTheme.bodyText1!
                          .copyWith(color: Colors.white),
                    ),
                  )
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
