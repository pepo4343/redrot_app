import 'package:flutter/material.dart';
import 'package:redrotapp/common/constants/size_constants.dart';
import 'package:redrotapp/presentation/logic/cubit/image_uploader/image_uploader_cubit.dart';

import 'clone_detail_content.dart';
import 'loading_indicators.dart';

class CloneDetail extends StatelessWidget {
  const CloneDetail({Key? key, required this.uploadState}) : super(key: key);
  final ImageUploaderState uploadState;
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final clone = uploadState.clone;

      if (clone == null) {
        return Container();
      }

      return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(Sizes.dimen_8)),
        child: Container(
          width: double.infinity,
          height: 80,
          child: Stack(
            children: [
              BackgroundLoadingIndicator(),
              IntermidiateLoadingIndicator(
                uploadState: uploadState,
              ),
              ForegroundLoadingIndicator(
                uploadState: uploadState,
              ),
              CloneDetailContent(clone: clone, uploadState: uploadState),
            ],
          ),
        ),
      );
    });
  }
}
