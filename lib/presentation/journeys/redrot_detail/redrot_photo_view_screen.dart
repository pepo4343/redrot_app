import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:redrotapp/domain/entities/clone_entity.dart';
import 'package:redrotapp/presentation/themes/app_colors.dart';
import 'package:redrotapp/presentation/widgets/redrot_dark_app_bar.dart';

class RedrotPhotoViewScreen extends StatelessWidget {
  const RedrotPhotoViewScreen({
    Key? key,
    required this.redrotEntity,
  }) : super(key: key);
  final RedrotEntity redrotEntity;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RedrotDarkAppBar(
        title: "ภาพเหี่ยวเน่าแดง",
      ),
      backgroundColor: AppDarkColors().backgroundColor,
      body: PhotoView(
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 4.1,
        imageProvider: NetworkImage(redrotEntity.imageUrl),
        heroAttributes: PhotoViewHeroAttributes(tag: redrotEntity.redrotId),
      ),
    );
  }
}
